// post.dart


// 必要なパッケージをインポート / Import necessary packages
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:river_stream_unlimited_tech/generated/l10n.dart';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;


// ★add
import 'package:shared_preferences/shared_preferences.dart'; //★add
import 'dart:convert'; //★add


// PostモデルとPostProviderが定義されたファイルをインポート / Import file containing Post model and PostProvider
import 'models/post_model.dart';


// 投稿画面ウィジェット / Widget for posting screen
class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);


  @override
  PostScreenState createState() => PostScreenState();
}


// Post画面のStateクラス / State class for Post screen
class PostScreenState extends State<PostScreen> {
  DateTime _selectedDateTime = DateTime.now(); // 選択した日時 / Selected date & time
  String _riverName = "";                      // 川の名前 / Name of the river
  File? _imageFile;                            // 選択した画像ファイル / Selected image file
  final TextEditingController _commentController = TextEditingController(); // コメント用コントローラ / Controller for comment


  double? _latitude;   // 緯度 / Latitude
  double? _longitude;  // 経度 / Longitude


  bool _isPosting = false; // 投稿中フラグ / Flag for indicating posting process


  // ★add - 設定画面で設定された川を取得するためのリスト。初期値として3つ入れておく。
  List<String> _riverList = ['ShounaiRiver', 'OtherRiver1', 'OtherRiver2']; //★add


  // ★add
  //        デフォルトは "river" としておきます
  String _selectedPostType = 'river';


  // 画面初期化 / Screen initialization
  @override
  void initState() {
    super.initState();
    _loadRiversFromPrefs(); //★add
    _getCurrentLocation();
  }


  // ★add - SharedPreferences からユーザーが選択した川の一覧を読み込んで _riverList に反映する
  Future<void> _loadRiversFromPrefs() async { //★add
    final prefs = await SharedPreferences.getInstance(); //★add
    final riversAsJson = prefs.getStringList('SelectedRivers'); //★add
    if (riversAsJson != null) { //★add
      final loadedRivers = <String>[]; //★add
      for (var riverJson in riversAsJson) { //★add
        final riverMap = jsonDecode(riverJson); //★add
        final name = riverMap["RiverName"]; //★add
        if (name != null) { //★add
          loadedRivers.add(name); //★add
        } //★add
      } //★add
      if (loadedRivers.isNotEmpty) { //★add
        setState(() { //★add
          _riverList = loadedRivers; //★add
        }); //★add
      } //★add
    } //★add
  } //★add


  // 破棄時処理 / Dispose resources
  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }


  // ギャラリーから画像を選択 / Select an image from gallery
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    try {
      final XFile? pickedFile =
      await picker.pickImage(source: ImageSource.gallery);


      if (pickedFile == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.current.imagenotselected)),
        );
        return;
      }


      final Directory appDir = await getApplicationDocumentsDirectory();
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
      final File savedImage =
      await File(pickedFile.path).copy('${appDir.path}/$fileName');


      if (!mounted) return;
      setState(() {
        _imageFile = savedImage;
      });
      debugPrint("Image has been saved: ${_imageFile!.path}");
    } catch (e) {
      debugPrint('Image selection error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error has occurred: $e')),
      );
    }
  }


  // 日時選択処理 / Select date & time
  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      );
      if (time != null) {
        final dateTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
        if (!mounted) return;
        setState(() {
          _selectedDateTime = dateTime;
        });
      }
    }
  }


  // 現在地を取得 / Get current location
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;


    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.current.locationisturnedoff)),
      );
      return;
    }


    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.current.locationdenied)),
        );
        return;
      }
    }


    if (permission == LocationPermission.deniedForever) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              S.current.locationpermissionspermanently),
        ),
      );
      return;
    }


    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );


      if (!mounted) return;
      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
      });
    } catch (e) {
      debugPrint('Failed to get current location: $e');
    }
  }


  // 投稿処理 / Submit post
  void _post() async {
    if (_isPosting) return; // 投稿中なら処理しない / Return if already posting


    if (_imageFile == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.current.pleaseSelectImage)),
      );
      return;
    }


    setState(() {
      _isPosting = true;
    });


    final double postLatitude = _latitude ?? 37.785834;
    final double postLongitude = _longitude ?? -122.406417;


    final postProvider = Provider.of<PostProvider>(context, listen: false);
    final String postId = const Uuid().v4();
    final ref = FirebaseStorage.instance.ref().child('posts/$postId.png');


    try {
      // Firebase Storageにアップロード / Upload image to Firebase Storage
      final uploadTask = await ref.putFile(_imageFile!);
      final imageUrl = await uploadTask.ref.getDownloadURL();


      final newPost = Post(
        id: postId,
        dateTime: _selectedDateTime,
        riverName: _riverName,
        imagePath: imageUrl,
        comment: _commentController.text,
        latitude: postLatitude,
        longitude: postLongitude,
        postType: _selectedPostType, //★add
      );


      await FirebaseFirestore.instance.collection('posts').doc(postId).set({
        'id': postId,
        'dateTime': _selectedDateTime.toIso8601String(),
        'riverName': _riverName,
        'imagePath': imageUrl,
        'comment': _commentController.text,
        'latitude': postLatitude,
        'longitude': postLongitude,
        'postType': _selectedPostType, //★add
      });


      postProvider.addPost(newPost);


      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.current.submissioncomplete)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to post: $e')),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        _isPosting = false;
      });
    }
  }


  // 画面描画 / Build UI
  @override
  Widget build(BuildContext context) {
    final isPostingNow = _isPosting;


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(S.current.postScreen), backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 日時選択 / Select date & time
            Row(
              children: [
                Text(S.current.date, style: TextStyle(fontSize: 16)),
                const SizedBox(width: 10),
                InkWell(
                  onTap: _pickDateTime,
                  child: Text(
                    '${_selectedDateTime.year}/${_selectedDateTime.month}/${_selectedDateTime.day} '
                        '${_selectedDateTime.hour}:${_selectedDateTime.minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(fontSize: 16, color: Colors.blue),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),


            // 川の名前 / River name
            Row(
              children: [
                Text(S.current.riverPostScreen, style: TextStyle(fontSize: 16)),
                const SizedBox(width: 10),
                // ★add - 設定画面で設定した川リストをドロップダウンに反映
                DropdownButton<String>(
                  value: _riverList.contains(_riverName) ? _riverName : null, //★add
                  items: _riverList //★add
                      .map(
                        (String value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    ),
                  )
                      .toList(),
                  onChanged: (value) {
                    if (!mounted) return;
                    setState(() {
                      _riverName = value ?? '';
                    });
                  },
                  hint: Text(S.current.riverSelectorPostScreen),
                ),
              ],
            ),
            const SizedBox(height: 16),


            // ★add
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Type', style: TextStyle(fontSize: 16)),
                Row(
                  children: [
                    Radio<String>(
                      value: 'river',
                      groupValue: _selectedPostType,
                      onChanged: isPostingNow
                          ? null
                          : (value) {
                        setState(() {
                          _selectedPostType = value!;
                        });
                      },
                    ),
                    const Text('river'),
                  ],
                ),
                Row(
                  children: [
                    Radio<String>(
                      value: 'road',
                      groupValue: _selectedPostType,
                      onChanged: isPostingNow
                          ? null
                          : (value) {
                        setState(() {
                          _selectedPostType = value!;
                        });
                      },
                    ),
                    const Text('road'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),


            // 画像選択 / Image selection
            Stack(
              children: [
                if (_imageFile == null)
                  Row(
                    children: [
                      Text(S.current.imageSelectorPostScreen, style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 10),
                      IconButton(
                        icon: const Icon(Icons.image),
                        onPressed: isPostingNow ? null : _pickImage,
                      ),
                    ],
                  )
                else
                  Stack(
                    children: [
                      Image.file(_imageFile!, height: 200),
                      Positioned(
                        bottom: 5,
                        right: 5,
                        child: IconButton(
                          icon: const Icon(Icons.image, color: Colors.white),
                          onPressed: isPostingNow ? null : _pickImage,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 16),


            // コメント入力 / Input comment
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(S.current.commentSelectorPostScreen, style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                TextField(
                  enabled: !isPostingNow,
                  controller: _commentController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: S.current.writecommentSelectorPostScreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),


            // 投稿ボタン / Button to post
            ElevatedButton(
              onPressed: isPostingNow ? null : _post,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: isPostingNow
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
                  : Text(S.current.postPostScreen),
            ),
          ],
        ),
      ),
    );
  }
}