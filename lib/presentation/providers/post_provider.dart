import 'package:flutter/material.dart';
import '../../data/models/post.dart';
import '../../data/services/cat_api.dart';
import '../../data/services/local_storage.dart';

class PostProvider with ChangeNotifier {
  final CatApiService _catApiService = CatApiService();
  final LocalStorageService _localStorageService = LocalStorageService();

  List<Post> _catPosts = [];
  List<Post> _localPosts = [];
  bool _isLoading = false;

  List<Post> get catPosts => _catPosts;
  List<Post> get localPosts => _localPosts;
  bool get isLoading => _isLoading;

  Future<void> fetchCatPosts() async {
    _isLoading = true;
    notifyListeners();
    try {
      _catPosts = await _catApiService.fetchCatPosts();
    } catch (e) {
      _catPosts = [];
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadLocalPosts() async {
    _localPosts = await _localStorageService.getLocalPosts();
    notifyListeners();
  }

  Future<void> addLocalPost(Post post) async {
    await _localStorageService.savePost(post);
    _localPosts.add(post);
    notifyListeners();
  }

  Future<void> clearLocalPosts() async {
    await _localStorageService.clearPosts();
    _localPosts.clear();
    notifyListeners();
  }
}