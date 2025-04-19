import 'package:flutter/material.dart';
import '../../data/services/local_storage.dart';
import '../../data/models/post.dart';
import '../widgets/profile_header.dart';
import '../widgets/post_card.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final LocalStorageService _localStorageService = LocalStorageService();
  late Future<List<Post>> _localPosts;
  int _followers = 120;
  int _following = 80;
  String _bio = "Sharing pictures of cats i found anywhere!";
  int? _selectedPostIndex;
  bool _showFullView = false;
  List<Post> _posts = [];

  @override
  void initState() {
    super.initState();
    _localPosts = _localStorageService.getLocalPosts().then((posts) {
      _posts = posts; // Initialize _posts when data is loaded
      return posts;
    });
  }

  Future<void> _loadLocalPosts() async {
    final posts = await _localStorageService.getLocalPosts();
    setState(() {
      _posts = posts;
      _localPosts = Future.value(posts);
    });
  }

  Future<void> _clearPosts() async {
    await _localStorageService.clearPosts();
    _loadLocalPosts();
  }

  void _openPostView(int index) {
    setState(() {
      _selectedPostIndex = index;
      _showFullView = true;
    });
  }

  void _closePostView() {
    setState(() {
      _showFullView = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showFullView) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _closePostView,
          ),
        ),
        body: _posts.isEmpty
            ? const Center(child: Text('No posts to display'))
            : PageView.builder(
                controller: PageController(initialPage: _selectedPostIndex ?? 0),
                itemCount: _posts.length,
                itemBuilder: (context, index) {
                  return PostCard(post: _posts[index]);
                },
              ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'niavantrue',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _clearPosts,
          ),
        ],
      ),
      body: Column(
        children: [
          FutureBuilder<List<Post>>(
            future: _localPosts,
            builder: (context, snapshot) {
              int postCount = snapshot.hasData ? snapshot.data!.length : 0;
              return ProfileHeader(
                username: 'vantrue',
                profileImage: 'assets/images/default_avatar.png',
                followers: _followers,
                following: _following,
                postCount: postCount,
                bio: _bio,
              );
            },
          ),
          Expanded(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  const TabBar(
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.black,
                    tabs: [
                      Tab(icon: Icon(Icons.grid_on)),
                      Tab(icon: Icon(Icons.person_pin_rounded)),
                    ],
                  ),
                  Expanded(
                    child: FutureBuilder<List<Post>>(
                      future: _localPosts,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return const Center(child: Text('Failed to load posts'));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text('No posts yet'));
                        }

                        final posts = snapshot.data!;
                        return GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 1,
                            mainAxisSpacing: 1,
                          ),
                          itemCount: posts.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () => _openPostView(index),
                              child: posts[index].localImage != null
                                  ? Image.file(posts[index].localImage!, fit: BoxFit.cover)
                                  : Image.network(posts[index].imageUrl, fit: BoxFit.cover),
                            );
                          },
                        );
                      },
                    ),
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