import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/services/cat_api.dart';
import '../../data/services/local_storage.dart';
import '../../data/models/post.dart';
import '../widgets/post_card.dart';
import '../widgets/stories.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CatApiService _catApiService = CatApiService();
  final LocalStorageService _localStorageService = LocalStorageService();
  Future<List<Post>>? _catPosts;
  List<Post> _localPosts = [];

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    try {
      final catPosts = _catApiService.fetchCatPosts();
      final localPosts = await _localStorageService.getLocalPosts();
      setState(() {
        _localPosts = localPosts;
        _catPosts = catPosts;
      });
    } catch (e) {
      setState(() {
        _catPosts = Future.value([]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Whiskertopia',
          style: GoogleFonts.grandHotel(
            textStyle: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold,),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {},
          ),
          IconButton(
            icon: ImageIcon(AssetImage('assets/icons/messenger.png')),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Stories(),
            FutureBuilder<List<Post>>(
              future: _catPosts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Failed to load posts'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No posts available'));
                }

                final posts = [..._localPosts, ...snapshot.data!];
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    return PostCard(post: posts[index]);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
