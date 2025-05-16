import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LikeService {
  // Keys for SharedPreferences
  static const String _likedPhotosKey = 'liked_photos';
  
  // Singleton pattern
  static final LikeService _instance = LikeService._internal();
  
  factory LikeService() {
    return _instance;
  }
  
  LikeService._internal();

  // Get all liked photo IDs
  Future<Set<String>> getLikedPhotoIds() async {
    final prefs = await SharedPreferences.getInstance();
    final String? likedPhotosJson = prefs.getString(_likedPhotosKey);
    
    if (likedPhotosJson == null) {
      return {};
    }
    
    final List<dynamic> likedPhotosList = json.decode(likedPhotosJson);
    return likedPhotosList.map((id) => id.toString()).toSet();
  }

  // Toggle like state for a photo
  Future<bool> toggleLike(String photoId) async {
    final likedPhotos = await getLikedPhotoIds();
    
    // If photo was already liked, unlike it, otherwise like it
    final bool isNowLiked = !likedPhotos.contains(photoId);
    
    if (isNowLiked) {
      likedPhotos.add(photoId);
    } else {
      likedPhotos.remove(photoId);
    }
    
    // Save updated liked photos
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_likedPhotosKey, json.encode(likedPhotos.toList()));
    
    return isNowLiked;
  }

  // Check if a photo is liked
  Future<bool> isPhotoLiked(String photoId) async {
    final likedPhotos = await getLikedPhotoIds();
    return likedPhotos.contains(photoId);
  }
}