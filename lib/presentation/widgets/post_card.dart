import 'package:flutter/material.dart';
import '../../data/models/post.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const CircleAvatar(
                   backgroundColor: Color.fromARGB(255, 223, 222, 222),
                   child: Icon(Icons.person),
                ),
                const SizedBox(width: 8),
                Text(post.username, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          
          post.localImage != null
              ? Image.file(post.localImage!, fit: BoxFit.cover, width: double.infinity, height: 300)
              : Image.network(post.imageUrl, fit: BoxFit.cover, width: double.infinity, height: 300, errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 300,
                    color: Colors.grey[300],
                    child: const Center(child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey)),
                  );
                }),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.favorite_border),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.mode_comment_outlined),
                  onPressed: () {},
                ),
                IconButton(
                  icon: ImageIcon(AssetImage('assets/icons/send.png'), color: Colors.black),
                  onPressed: () {},
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.bookmark_border),
                  onPressed: () {},
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(post.username, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 5),
                Expanded(child: Text(post.caption, style: const TextStyle(fontSize: 14))),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '${post.timestamp.hour}:${post.timestamp.minute}, ${post.timestamp.day}/${post.timestamp.month}/${post.timestamp.year}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }
}
