import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/models/post.dart';
import '../../data/services/local_storage.dart';
import '../../main.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final TextEditingController _captionController = TextEditingController();
  final LocalStorageService _localStorageService = LocalStorageService();
  File? _selectedImage;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _savePost() async {
    if (_selectedImage == null || _captionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an image and enter a caption'),
        ),
      );
      return;
    }

    final newPost = Post(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      imageUrl: '',
      localImage: _selectedImage,
      username: 'You',
      caption: _captionController.text,
      timestamp: DateTime.now(),
    );

    await _localStorageService.savePost(newPost);
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'New Post',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: _selectedImage == null
                          ? const Center(child: Text('Tap to select image'))
                          : Image.file(_selectedImage!, fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    controller: _captionController,
                    decoration: const InputDecoration(labelText: 'Add a caption...'),
                  ),
                  const SizedBox(height: 20),
                  _buildOptionRow(
                    icon: Icons.person_outline_rounded,
                    text: 'Tag People'),
                  const SizedBox(height: 20),
                  _buildOptionRow(
                    icon: Icons.location_on_outlined,
                    text: 'Add Location'),
                  const SizedBox(height: 20),
                  _buildOptionRow(
                    icon: Icons.music_note,
                    text: 'Add Music'),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _savePost,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Share'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionRow({required IconData icon, required String text}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.grey[700]),
            const SizedBox(width: 8),
            Text(text, style: const TextStyle(color: Colors.grey)),
          ],
        ),
        const Icon(Icons.arrow_forward_ios, color: Colors.grey),
      ],
    );
  }
}