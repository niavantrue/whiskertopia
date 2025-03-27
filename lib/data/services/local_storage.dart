import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/post.dart';

class LocalStorageService {
  static const String _keyPosts = 'local_posts';

  Future<void> savePost(Post post) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> posts = prefs.getStringList(_keyPosts) ?? [];
    posts.add(jsonEncode(post.toMap()));
    await prefs.setStringList(_keyPosts, posts);
  }

  Future<List<Post>> getLocalPosts() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> posts = prefs.getStringList(_keyPosts) ?? [];
    return posts.map((post) => Post.fromMap(jsonDecode(post))).toList();
  }

  Future<void> clearPosts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyPosts);
  }
}
