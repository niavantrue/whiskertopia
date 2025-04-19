import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';
import '../../core/constants.dart';

class CatApiService {
  Future<List<Post>> fetchCatPosts({int limit = catApiFetchLimit}) async {
    final response = await http.get(Uri.parse('$catApiBaseUrl?limit=$limit&api_key=$catApiKey'));
    
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Post.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load cat posts');
    }
  }
}