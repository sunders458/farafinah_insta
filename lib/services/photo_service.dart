import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:farafinah_insta/models/photo.dart';
import 'package:farafinah_insta/config/api_config.dart';

class PhotoService {
  // Singleton pattern
  static final PhotoService _instance = PhotoService._internal();

  factory PhotoService() {
    return _instance;
  }

  PhotoService._internal();

  // Get photos from Unsplash API
  Future<List<Photo>> getPhotos({int page = 1, int perPage = 10}) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/photos?page=$page&per_page=$perPage'),
        headers: {
          'Authorization': 'Client-ID ${ApiConfig.accessKey}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Photo.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load photos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching photos: $e');
    }
  }
}
