import 'package:flutter/material.dart';
import 'package:farafinah_insta/models/photo.dart';
import 'package:farafinah_insta/services/photo_service.dart';
import 'package:farafinah_insta/services/like_service.dart';

class PhotoProvider extends ChangeNotifier {
  final PhotoService _photoService = PhotoService();
  final LikeService _likeService = LikeService();
  
  // State
  List<Photo> _photos = [];
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';
  bool _hasNextPage = true;
  int _currentPage = 1;
  bool _isLoadingMore = false;

  // Getters
  List<Photo> get photos => _photos;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  bool get hasNextPage => _hasNextPage;
  bool get isLoadingMore => _isLoadingMore;

  // Fetch initial photos
  Future<void> fetchPhotos() async {
    if (_isLoading) return;
    
    _isLoading = true;
    _hasError = false;
    _errorMessage = '';
    _currentPage = 1;
    notifyListeners();

    try {
      // Get photos from API
      final photos = await _photoService.getPhotos(page: _currentPage);
      
      // Initialize like status for each photo
      final likedPhotoIds = await _likeService.getLikedPhotoIds();
      
      for (var photo in photos) {
        photo.isLiked = likedPhotoIds.contains(photo.id);
      }
      
      _photos = photos;
      _hasNextPage = photos.isNotEmpty;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _hasError = true;
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load more photos (pagination)
  Future<void> loadMorePhotos() async {
    if (_isLoadingMore || !_hasNextPage) return;
    
    _isLoadingMore = true;
    notifyListeners();

    try {
      final nextPage = _currentPage + 1;
      final newPhotos = await _photoService.getPhotos(page: nextPage);
      
      // Initialize like status for each new photo
      final likedPhotoIds = await _likeService.getLikedPhotoIds();
      for (var photo in newPhotos) {
        photo.isLiked = likedPhotoIds.contains(photo.id);
      }
      
      // If we got no new photos, there's no next page
      if (newPhotos.isEmpty) {
        _hasNextPage = false;
      } else {
        _photos.addAll(newPhotos);
        _currentPage = nextPage;
      }
      
      _isLoadingMore = false;
      notifyListeners();
    } catch (e) {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  // Toggle like for a photo
  Future<void> toggleLike(String photoId) async {
    // Find photo in list
    final index = _photos.indexWhere((photo) => photo.id == photoId);
    if (index == -1) return;
    
    // Toggle like in the service
    final isNowLiked = await _likeService.toggleLike(photoId);
    
    // Update photo state
    _photos[index].isLiked = isNowLiked;
    notifyListeners();
  }

  // Reset state for logout
  void reset() {
    _photos = [];
    _isLoading = false;
    _hasError = false;
    _errorMessage = '';
    _hasNextPage = true;
    _currentPage = 1;
    _isLoadingMore = false;
    notifyListeners();
  }
}