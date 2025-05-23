// map.dart

// 必要なパッケージをインポート / Import necessary packages
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:river_stream_unlimited_tech/generated/l10n.dart';

// Postモデルが定義されているファイルをインポート / Import the file where Post model is defined
import 'models/post_model.dart';

// Map画面を表示するウィジェット / Widget that displays the Map screen
class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  MapScreenState createState() => MapScreenState();
}

// MapScreenのStateクラス / State class for MapScreen
class MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;       // Mapコントローラ / Map controller
  final Set<Marker> _markers = {};               // マーカーを管理するセット / Set to manage markers
  LatLng _initialPosition = const LatLng(37.785834, -122.406417); // デフォルト位置 / Default location (San Francisco)

  // 開始日と終了日を管理する変数
  DateTime _startDate = DateTime(2025, 1, 1);
  DateTime _endDate = DateTime(2025, 3, 15);

  // 開始日を選択する関数
  Future<void> _pickStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
      });
      // 日付変更後、マーカーを再取得
      _initMarkers();
    }
  }

  // 終了日を選択する関数
  Future<void> _pickEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
      // 日付変更後、マーカーを再取得
      _initMarkers();
    }
  }

  //★add nowボタン押下時に3日前から今日までに日付を設定する関数
  void _goToNow() {
    setState(() {
      final now = DateTime.now();
      _endDate = DateTime(now.year, now.month, now.day);
      _startDate = _endDate.subtract(const Duration(days: 3));
    });
    _initMarkers();
  }

  // 画面生成時に呼ばれる / Called when the screen is initialized
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCurrentLocation();
      _initMarkers();
    });
  }

  // 画面破棄時に呼ばれる / Called when the screen is disposed
  @override
  void dispose() {
    super.dispose();
  }

  // 現在地を取得して初期位置に設定 / Get current location and set initial position
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint('Location services are disabled');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint('Location authorization denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      debugPrint('Location authorization has been permanently denied');
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (!mounted) return;
      setState(() {
        _initialPosition = LatLng(position.latitude, position.longitude);
      });

      if (!mounted) return;
      _mapController.animateCamera(
        CameraUpdate.newLatLng(_initialPosition),
      );
    } catch (e) {
      debugPrint('Failed to acquire current location: $e');
    }
  }

  // Firestoreの投稿データからマーカーを生成 / Generate markers from Firestore post data
  Future<void> _initMarkers() async {
    try {
      final querySnapshot =
      await FirebaseFirestore.instance.collection('posts').get();

      if (!mounted) return;

      final Set<Marker> newMarkers = {};
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final markerId = MarkerId(data['id']);
        final postDate = DateTime.parse(data['dateTime']); // ← 日付フィールド

        // フィルタ：_startDate <= postDate <= _endDate のデータだけ表示
        if (postDate.isBefore(_startDate) || postDate.isAfter(_endDate)) {
          // 範囲外の日付の場合はスキップ
          continue;
        }

        // ★add
        final String postType = data['postType'] ?? 'river';

        // ★変更: _createCustomMarker の引数を増やして postType を渡す
        final customIcon = await _createCustomMarker(data['imagePath'], postType);

        final marker = Marker(
          markerId: markerId,
          position: LatLng(data['latitude'], data['longitude']),
          icon: customIcon,
          infoWindow: InfoWindow(
            title: data['riverName'],
            snippet: data['comment'] ?? "No comment",
          ),
          onTap: () {
            // マーカータップ時に投稿詳細をダイアログ表示 / Show post details on tap
            _showPostDetails(
              Post(
                id: data['id'],
                dateTime: postDate,
                riverName: data['riverName'],
                imagePath: data['imagePath'],
                comment: data['comment'] ?? '',
                latitude: data['latitude'],
                longitude: data['longitude'],

                // ★add
                postType: postType,
              ),
            );
          },
        );
        newMarkers.add(marker);
      }

      if (!mounted) return;
      setState(() {
        _markers.clear();
        _markers.addAll(newMarkers);
      });
    } catch (e) {
      debugPrint('Failed to initialize markers: $e');
    }
  }

  // 投稿詳細のダイアログを表示 / Show a dialog with post details
  void _showPostDetails(Post post) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title:
          Text(post.riverName.isNotEmpty ? post.riverName : S.current.moreInfo),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Image.network(
                  post.imagePath,
                  height: 200,
                  errorBuilder: (context, error, stackTrace) {
                    return Text(S.current.imageCouldntbeloaded);
                  },
                ),
                const SizedBox(height: 8),
                Text(S.current.dateandtime(
                    "${post.dateTime.year}/${post.dateTime.month}/${post.dateTime.day} "
                    "${post.dateTime.hour}:${post.dateTime.minute.toString().padLeft(2, '0')}")
                  ),
                if (post.comment.isNotEmpty)
                  Text(S.current.commentMapScreen(post.comment)),
                // ★add
                Text("Post Type: ${post.postType}"),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(S.current.closeMapScreen),
            ),
          ],
        );
      },
    );
  }

  // ★add postType によりマーカー画像に枠線色を付ける
  Future<BitmapDescriptor> _createCustomMarker(String imageUrl, String postType) async {
    try {
      final http.Response response = await http.get(Uri.parse(imageUrl));
      final Uint8List bytes = response.bodyBytes;

      final ui.Codec codec = await ui.instantiateImageCodec(
        bytes,
        targetWidth: 150,
        targetHeight: 150,
      );
      final ui.FrameInfo frameInfo = await codec.getNextFrame();
      final ui.Image originalImage = frameInfo.image;

      final recorder = ui.PictureRecorder();
      final canvas = ui.Canvas(recorder);

      // ★add
      // 川なら水色(Colors.lightBlue)、道ならオレンジ(Colors.orange)など、postType によって色を変更
      final paintColor = postType == 'river' ? Colors.lightBlue : Colors.orange;

      final paint = Paint()
        ..color = paintColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 12.0;

      final rect = Rect.fromLTWH(
        0,
        0,
        originalImage.width.toDouble(),
        originalImage.height.toDouble(),
      );

      // 画像と枠線を描画 / Draw image and border
      canvas.drawImage(originalImage, Offset.zero, Paint());
      canvas.drawRect(rect, paint);

      final picture = recorder.endRecording();
      final ui.Image markerWithBorder = await picture.toImage(
        originalImage.width,
        originalImage.height,
      );
      final ByteData? byteData =
      await markerWithBorder.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) {
        return BitmapDescriptor.defaultMarker;
      }
      return BitmapDescriptor.fromBytes(byteData.buffer.asUint8List());
    } catch (e) {
      debugPrint('Failed to create custom marker: $e');
      return BitmapDescriptor.defaultMarker;
    }
  }

  // ウィジェットのビルド / Build the widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // AppBar はタイトルのみ
      appBar: AppBar(
        title: Text(S.current.mapScreen), backgroundColor: Colors.white, 
      ),
      // body に Stack を使い、右上にウィジェットを重ねる
      body: Stack(
        children: [
          // GoogleMap を最下層に表示
          GoogleMap(
            onMapCreated: (controller) {
              _mapController = controller;
              // 取得した初期位置へ移動 / Move camera to the initial position
              _mapController.animateCamera(
                CameraUpdate.newLatLng(_initialPosition),
              );
            },
            markers: _markers,
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 14,
            ),
          ),
          // 右上に Positioned ウィジェットを置き、日付選択ウィジェットを重ねる
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              // 地図の上でも見やすいよう軽く背景色を付ける
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(8),
              ),
              //★add ここから「日付 カレンダー ~ 日付 カレンダー now」の並び
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //★add: 開始日
                  Text(
                    "${_startDate.year}/${_startDate.month.toString().padLeft(2, '0')}/${_startDate.day.toString().padLeft(2, '0')}",
                  ),
                  IconButton(
                    icon: const Icon(Icons.date_range),
                    tooltip: 'Select start date',
                    onPressed: _pickStartDate,
                  ),
                  const Text(" ~ "), // ★add
                  //★add: 終了日
                  Text(
                    "${_endDate.year}/${_endDate.month.toString().padLeft(2, '0')}/${_endDate.day.toString().padLeft(2, '0')}",
                  ),
                  IconButton(
                    icon: const Icon(Icons.date_range),
                    tooltip: 'Select end date',
                    onPressed: _pickEndDate,
                  ),
                  //★add 「Now」ボタン
                  TextButton(
                    onPressed: _goToNow,
                    child: const Text('Now'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
