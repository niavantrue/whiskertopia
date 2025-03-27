import 'dart:io';

class Post {
  final String id;
  final String imageUrl;
  final File? localImage;
  final String username;
  final String caption;
  final DateTime timestamp;
  
  Post({
    required this.id,
    required this.imageUrl,
    this.localImage,
    required this.username,
    required this.caption,
    required this.timestamp,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] ?? '',
      imageUrl: json['url'] ?? '',
      username: "Cat Lover",
      caption: "Look at my cat! 🐱",
      timestamp: DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'localImage': localImage?.path,
      'username': username,
      'caption': caption,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      localImage: map['localImage'] != null ? File(map['localImage']) : null,
      username: map['username'] ?? '',
      caption: map['caption'] ?? '',
      timestamp: DateTime.parse(map['timestamp'] ?? DateTime.now().toIso8601String()),
    );
  }
}
