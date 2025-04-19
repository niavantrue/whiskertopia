import 'package:flutter/material.dart';
import 'package:whiskertopia/data/services/cat_api.dart';
import '../widgets/post_card.dart';
import '../../data/models/post.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final CatApiService _catApiService = CatApiService();
  List<Post> _allPosts = [];
  int _currentIndex = 0;
  bool _showViewer = false;
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  int _postLimit = 20;

  @override
  void initState() {
    super.initState();
    _loadPosts();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadPosts() async {
    final posts = await _catApiService.fetchCatPosts(limit: _postLimit);
    setState(() {
      _allPosts = posts;
    });
  }

  Future<void> _loadMorePosts() async {
    if (_isLoadingMore) return;
    
    setState(() {
      _isLoadingMore = true;
    });

    _postLimit += 20;
    final newPosts = await _catApiService.fetchCatPosts(limit: _postLimit);
    
    setState(() {
      _allPosts = newPosts;
      _isLoadingMore = false;
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == 
        _scrollController.position.maxScrollExtent) {
      _loadMorePosts();
    }
  }

  void _openViewer(int index) {
    setState(() {
      _currentIndex = index;
      _showViewer = true;
    });
  }

  void _closeViewer() {
    setState(() {
      _showViewer = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showViewer) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: _closeViewer,
          ),
        ),
        body: PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: _allPosts.length,
          controller: PageController(initialPage: _currentIndex),
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          itemBuilder: (context, index) {
            return PostCard(post: _allPosts[index]);
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Cats', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: GridView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 1,
          crossAxisSpacing: 1,
        ),
        itemCount: _allPosts.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _openViewer(index),
            child: Image.network(
              _allPosts[index].imageUrl,
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}