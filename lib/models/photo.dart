class Photo {
  final String id;
  final String url;
  final String description;
  final String username;
  final String profileImageUrl;
  bool isLiked;

  Photo({
    required this.id,
    required this.url,
    required this.description,
    required this.username,
    required this.profileImageUrl,
    this.isLiked = false,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    try {
      final id = json['id'] ?? '';
      final url = json['urls']?['regular'] ?? '';
      final description = json['description'] ?? json['alt_description'] ?? 'No description';
      final username = json['user']?['username'] ?? 'Unknown';
      final profileImageUrl = json['user']?['profile_image']?['medium'] ?? '';
      
      return Photo(
        id: id,
        url: url,
        description: description,
        username: username,
        profileImageUrl: profileImageUrl,
      );
    } catch (e) {
      // Retourner une photo avec des valeurs par défaut
      return Photo(
        id: json['id'] ?? 'error-id',
        url: 'https://via.placeholder.com/400x400?text=Error',
        description: 'Erreur lors du chargement',
        username: 'error',
        profileImageUrl: 'https://via.placeholder.com/50x50?text=Error',
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'description': description,
      'username': username,
      'profileImageUrl': profileImageUrl,
      'isLiked': isLiked,
    };
  }
}