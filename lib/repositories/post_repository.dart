import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/post.dart';
import '../services/api_client.dart';

class PostRepository extends ChangeNotifier {
  final ApiClient api = ApiClient();

  List<Post> posts = [];
  bool loading = false;
  String? error;

  /// ======================
  /// FETCH POSTS
  /// ======================
  Future<void> fetchPosts() async {
    loading = true;
    notifyListeners();

    try {
      final data = await api.getPosts();
      posts = data.map<Post>((e) => Post.fromJson(e)).toList();

      await _saveCache();
      error = null;
    } catch (e) {
      await loadCache();
      error = "Erreur réseau (cache affiché)";
    }

    loading = false;
    notifyListeners();
  }

  /// ======================
  /// ADD POST
  /// ======================
  Future<void> addPost(Post post) async {
    final newPost = Post(
      id: posts.isEmpty ? 1 : posts.last.id! + 1,
      title: post.title,
      body: post.body,
    );

    posts.add(newPost);

    await _saveCache();
    notifyListeners();
  }

  /// ======================
  /// UPDATE POST
  /// ======================
  Future<void> updatePost(Post updatedPost) async {
    final index =
        posts.indexWhere((p) => p.id == updatedPost.id);

    if (index != -1) {
      posts[index] = updatedPost;

      await _saveCache();
      notifyListeners();
    }
  }

  /// ======================
  /// DELETE POST
  /// ======================
  Future<void> deletePost(int id) async {
    posts.removeWhere((p) => p.id == id);

    await _saveCache();
    notifyListeners();
  }

  /// ======================
  /// CACHE SAVE
  /// ======================
  Future<void> _saveCache() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString(
      "cache",
      jsonEncode(posts.map((e) => e.toJson()).toList()),
    );
  }

  /// ======================
  /// LOAD CACHE
  /// ======================
  Future<void> loadCache() async {
    final prefs = await SharedPreferences.getInstance();
    final cache = prefs.getString("cache");

    if (cache != null) {
      final data = jsonDecode(cache);
      posts =
          data.map<Post>((e) => Post.fromJson(e)).toList();
      notifyListeners();
    }
  }
}