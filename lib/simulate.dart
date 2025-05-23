// simulate.dart

// Flutterやその他のパッケージをインポート / Import Flutter and other packages
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // デバッグ用 / For debugging
import 'package:image_picker/image_picker.dart';
import 'package:river_stream_unlimited_tech/generated/l10n.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

// Firebase関連のパッケージ / Firebase related packages
import 'package:firebase_storage/firebase_storage.dart'; // ストレージ用 / For Firebase Storage

// Firebase初期化はmain.dart等で実行 / Firebase initialization is done in main.dart, etc.
import 'firebase_options.dart'; // Firebaseのオプション / Firebase options

/// シミュレーション画面 / Simulation screen
class SimulateScreen extends StatefulWidget {
  const SimulateScreen({Key? key}) : super(key: key);

  @override
  State<SimulateScreen> createState() => _SimulateScreenState();
}

class _SimulateScreenState extends State<SimulateScreen> {
  // 選択した画像ファイル / Selected image file
  File? _selectedImage;

  // 動画プレーヤーコントローラ / Video player controller
  VideoPlayerController? _videoController;

  // 画面下部に表示するステータスメッセージ / Status message displayed on screen
  String _statusMessage = S.current.waitingForInput;

  // 生成された動画のURL / URL of generated video
  String? _videoUrl;

  // House / River 選択ボックス / Checkboxes for House or River
  bool _isHouseSelected = false;
  bool _isRiverSelected = false;

  // 動画生成中フラグ / Flag to indicate if video is being generated
  bool _isGenerating = false;

  // チェックボックスを無効化するフラグ / Flag to disable checkboxes
  bool _isCheckboxDisabled = false;

  // 最後に生成した動画のID / ID of the last generated video
  String? _lastGenerationId;

  // APIエンドポイントは固定
  static const String _dreamMachineApiUrl =
      'https://api.lumalabs.ai/dream-machine/v1/generations';

  // ユーザーが入力したAPIキーを管理するコントローラ
  final TextEditingController _apiKeyController = TextEditingController();

  // 画像をギャラリーから選ぶ / Pick image from gallery
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (!mounted) return;
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // 画像をFirebase StorageにアップロードしてURLを返す / Upload the image to Firebase Storage and return the URL
  Future<String> _uploadImageToFirebase(File imageFile) async {
    final fileName = 'house_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final storageRef = FirebaseStorage.instance.ref().child('uploaded_images');
    final imageRef = storageRef.child(fileName);

    // 画像をアップロード / Upload image
    await imageRef.putFile(imageFile);

    // プロジェクトに合わせてURLを修正 / Adjust URL to your project
    final customUrl =
        'https://storage.googleapis.com/flood-app-7e647.firebasestorage.app/uploaded_images/$fileName';
    return customUrl;
  }

  // Dream Machine APIで動画生成 / Generate video via Dream Machine API
  Future<void> _generateVideoWithKeyframes(File? imageFile) async {
    if (imageFile == null) {
      if (!mounted) return;
      setState(() {
        _statusMessage = S.current.noImgSelected;
      });
      return;
    }

    // ユーザー入力されたAPIキーを取得
    final apiKey = _apiKeyController.text.trim();

    // APIキーが空なら処理中断
    if (apiKey.isEmpty) {
      setState(() {
        _statusMessage = 'Please set API Key.';
      });
      return;
    }

    if (!mounted) return;
    setState(() {
      _isGenerating = true;
      _statusMessage = S.current.UploadingImg;
    });

    try {
      // 1. 画像をFirebaseにアップロード / Upload image to Firebase
      final uploadedUrl = await _uploadImageToFirebase(imageFile);
      debugPrint(S.current.UploadedImgUrl(uploadedUrl));

      if (!mounted) return;

      // 2. 生成する動画のプロンプトを決める / Decide prompt for video generation
      String prompt;
      if (_isHouseSelected && !_isRiverSelected) {
        prompt = "Create a video showing a house being swept away by a large flood.";
      } else if (_isRiverSelected && !_isHouseSelected) {
        prompt = "Create a video showing the river being flooded by a large flood.";
      } else {
        if (!mounted) return;
        setState(() {
          _statusMessage = S.current.pleaseSelectOne;
        });
        return;
      }

      // Dream Machineへのリクエストボディ / Request body for Dream Machine
      final body = {
        "prompt": prompt,
        "keyframes": {
          "frame0": {
            "type": "image",
            "url": uploadedUrl,
          }
        },
        "aspect_ratio": "16:9",
        "loop": false,
      };

      if (!mounted) return;
      setState(() {
        _statusMessage = S.current.sendingtoDreamMachine;
      });

      // 3. 動画生成をリクエスト / Request video generation
      final response = await http.post(
        Uri.parse(_dreamMachineApiUrl),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (!mounted) return;

      // 4. 成功時の処理 / On success
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = jsonDecode(response.body);
        final generationId = jsonData['id'];

        setState(() {
          _statusMessage = S.current.generationStarted(generationId);
          _lastGenerationId = generationId;
        });

        // 5. 生成完了をポーリングして待機 / Poll generation status
        await _pollGenerationStatus(generationId);
      } else {
        final errorMsg =
            jsonDecode(response.body)['error'] ?? response.body.toString();
        setState(() {
          _statusMessage = S.current.errorGeneration(errorMsg);
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _statusMessage = S.current.errortype(e);
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _isGenerating = false;
      });
    }
  }

  // 既存の動画を延長生成 / Extend existing generated video
  Future<void> _extendVideo(String existingGenerationId) async {
    // ユーザー入力されたAPIキーを取得
    final apiKey = _apiKeyController.text.trim();

    // APIキーが空なら処理中断
    if (apiKey.isEmpty) {
      setState(() {
        _statusMessage = 'Please set API Key.';
      });
      return;
    }

    if (!mounted) return;
    setState(() {
      _statusMessage = 'Requesting extended video...';
    });

    // リクエストボディ / Request body
    final body = {
      "prompt": "Extended version of the existing flooding video...",
      "model": "ray-2-flash",
      "keyframes": {
        "frame0": {
          "type": "generation",
          "id": existingGenerationId,
        }
      },
      "aspect_ratio": "16:9",
      "loop": false,
    };

    try {
      // 延長生成をリクエスト / Request extended generation
      final response = await http.post(
        Uri.parse(_dreamMachineApiUrl),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      debugPrint('Extend response status: ${response.statusCode}');
      debugPrint('Extend response body: ${response.body}');

      if (!mounted) return;

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = jsonDecode(response.body);
        final newId = jsonData['id'];

        setState(() {
          _statusMessage = S.current.generationStarted(newId);
        });

        // 新しいIDをポーリング / Poll new generation status
        await _pollGenerationStatus(newId);
      } else {
        final errorMsg =
            jsonDecode(response.body)['error'] ?? response.body.toString();
        setState(() {
          _statusMessage = S.current.errorExtendingVideo(errorMsg);
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _statusMessage = S.current.errortypeextendingVideo(e);
      });
    }
  }

  // Dream Machineの状態をポーリング / Poll Dream Machine status
  Future<void> _pollGenerationStatus(String generationId) async {
    final apiKey = _apiKeyController.text.trim();

    final fetchUrl = '$_dreamMachineApiUrl/$generationId';
    int retryCount = 0;
    const maxRetries = 20; // 5秒x20 =100秒 / 5 seconds x 20 = 100 seconds

    while (retryCount < maxRetries) {
      if (!mounted) return;

      final res = await http.get(
        Uri.parse(fetchUrl),
        headers: {
          'Authorization': 'Bearer $apiKey',
        },
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final state = data['state'];

        if (!mounted) return;
        setState(() {
          _statusMessage = S.current.generatingstate(state);
        });

        // 生成完了 / Completed
        if (state == 'completed') {
          final assets = data['assets'];
          if (assets != null && assets.isNotEmpty) {
            try {
              final vidUrl = assets['video'];
              if (!mounted) return;
              setState(() {
                _videoUrl = vidUrl;
                _statusMessage = S.current.videoReadyPlaying;
              });
              _playVideo(_videoUrl!);
              return;
            } catch (e) {
              if (!mounted) return;
              setState(() {
                _statusMessage = S.current.readybutnotfound;
              });
            }
          } else {
            if (!mounted) return;
            setState(() {
              _statusMessage =
              S.current.errorretrievingUrl;
            });
          }
        } else if (state == 'failed') {
          final failReason = data['failure_reason'] ?? 'Unknown reason';
          if (!mounted) return;
          setState(() {
            _statusMessage = S.current.videogenerationFailed(failReason);
          });
          return;
        }
      } else {
        if (!mounted) return;
        setState(() {
          _statusMessage = S.current.erroeCheckingStatus;
        });
      }

      retryCount++;
      await Future.delayed(const Duration(seconds: 5));
    }

    if (!mounted) return;
    setState(() {
      _statusMessage = S.current.generationTimeOut;
    });
  }

  // 動画を再生 / Play the generated video
  void _playVideo(String url) {
    _videoController?.dispose();
    _videoController = VideoPlayerController.network(url)
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() {});
        _videoController?.play();
      });
  }

  // ウィジェット破棄 / Dispose widget
  @override
  void dispose() {
    _videoController?.dispose();
    _apiKeyController.dispose();
    super.dispose();
  }

  // UIを描画 / Build UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(S.current.simulationScreen), backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // APIキーの入力欄のみ
            TextField(
              controller: _apiKeyController,
              decoration: const InputDecoration(
                labelText: 'API Key',
                hintText: 'Enter your Dream Machine API key',
              ),
            ),
            const SizedBox(height: 40),

            // House / River チェックボックス / Checkboxes for House and River
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: _isHouseSelected,
                  onChanged: _isCheckboxDisabled
                      ? null
                      : (value) {
                    if (!mounted) return;
                    setState(() {
                      _isHouseSelected = value ?? false;
                      if (_isHouseSelected) _isRiverSelected = false;
                    });
                  },
                ),
                Text(S.current.house),
                const SizedBox(width: 40),
                Checkbox(
                  value: _isRiverSelected,
                  onChanged: _isCheckboxDisabled
                      ? null
                      : (value) {
                    if (!mounted) return;
                    setState(() {
                      _isRiverSelected = value ?? false;
                      if (_isRiverSelected) _isHouseSelected = false;
                    });
                  },
                ),
                Text(S.current.riverSimulationScreen),
              ],
            ),
            const SizedBox(height: 20),

            // 画像または動画の表示 / Display image or video
            SizedBox(
              height: 200,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  if (_selectedImage != null && _videoUrl == null)
                    Image.file(_selectedImage!, height: 200, fit: BoxFit.cover),

                  if (_videoUrl != null && _videoController != null)
                    _videoController!.value.isInitialized
                        ? AspectRatio(
                      aspectRatio: _videoController!.value.aspectRatio,
                      child: VideoPlayer(_videoController!),
                    )
                        : Text(S.current.videoLoading),

                  // 画像の選択ボタン (まだ動画が生成されていないとき)
                  if (!_isGenerating && _videoUrl == null)
                    if (_selectedImage == null)
                      Center(
                        child: IconButton(
                          icon: const Icon(Icons.image, size: 40),
                          onPressed: _pickImage,
                        ),
                      )
                    else
                      Positioned(
                        bottom: -5,
                        right: -5,
                        child: IconButton(
                          icon: const Icon(Icons.image,
                              size: 40, color: Colors.white),
                          onPressed: _pickImage,
                        ),
                      ),

                  // 動画が再生可能なときにリプレイボタンを表示
                  if (_videoUrl != null && _videoController != null)
                    Positioned(
                      bottom: -5,
                      right: -5,
                      child: IconButton(
                        icon:
                        const Icon(Icons.replay, size: 40, color: Colors.white),
                        onPressed: () {
                          if (_videoController!.value.isInitialized) {
                            _videoController!.seekTo(Duration.zero);
                            _videoController!.play();
                          }
                        },
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Generateボタン
            if (_videoUrl == null && !_isGenerating)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  if (!_isHouseSelected && !_isRiverSelected) {
                    if (!mounted) return;
                    setState(() {
                      _statusMessage = S.current.pleaseSelectRiverorHouse;
                    });
                    return;
                  }
                  if (_selectedImage == null) {
                    if (!mounted) return;
                    setState(() {
                      _statusMessage = S.current.pleaseSelectImage;
                    });
                    return;
                  }

                  if (!mounted) return;
                  setState(() {
                    _isGenerating = true;
                    _isCheckboxDisabled = true;
                  });

                  await _generateVideoWithKeyframes(_selectedImage);

                  if (!mounted) return;
                  setState(() {
                    _isGenerating = false;
                  });
                },
                child: Text(S.current.generate),
              ),

            // ローディング表示
            if (_videoUrl == null && _isGenerating)
              const CircularProgressIndicator(),

            // Extend Generateボタン
            if (_videoUrl != null)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  if (_lastGenerationId == null) {
                    if (!mounted) return;
                    setState(() {
                      _statusMessage = S.current.noIDFound;
                    });
                    return;
                  }
                  _extendVideo(_lastGenerationId!);
                },
                child: Text(S.current.extendGenerate),
              ),

            const SizedBox(height: 16),
            // ステータス表示
            Text(_statusMessage),
          ],
        ),
      ),
    );
  }
}
