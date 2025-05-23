// lib/models/post_model.dart

// 必要なパッケージのインポート / Import required packages
import 'package:flutter/material.dart';

// Postデータモデルの定義 / Define Post data model
class Post {
  final String id;            // 一意のID / Unique ID
  final DateTime dateTime;    // 作成日時 / Date & time of creation
  final String riverName;     // 川の名前 / River name
  final String imagePath;     // 画像パス / Path to the image
  final String comment;       // コメント / User comment
  final double latitude;      // 緯度 / Latitude
  final double longitude;     // 経度 / Longitude
  // ★add
  final String postType;

  // コンストラクタ / Constructor
  Post({
    required this.id,
    required this.dateTime,
    required this.riverName,
    required this.imagePath,
    required this.comment,
    required this.latitude,
    required this.longitude,
    // ★add
    required this.postType,
  });
}

// Post用のプロバイダ / Provider for Post
class PostProvider with ChangeNotifier {
  // Postを格納するリスト / List to store Posts
  final List<Post> _posts = [];

  // Postリストの参照を提供 / Provide access to the Posts list
  List<Post> get posts => _posts;

  // 新しいPostを追加し、リスナーに通知 / Add a new Post and notify listeners
  void addPost(Post newPost) {
    _posts.add(newPost);
    notifyListeners(); // 変更を通知 / Notify about changes
  }
}
