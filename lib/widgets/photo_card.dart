import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:farafinah_insta/models/photo.dart';
import 'package:farafinah_insta/utils/constants.dart';

class PhotoCard extends StatelessWidget {
  final Photo photo;
  final VoidCallback onToggleLike;
  
  const PhotoCard({
    super.key,
    required this.photo,
    required this.onToggleLike,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User info header
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Row(
              children: [
                // User profile image
                CircleAvatar(
                  radius: 16,
                  backgroundImage: CachedNetworkImageProvider(
                    photo.profileImageUrl,
                  ),
                ),
                const SizedBox(width: 8),
                // Username
                Text(
                  photo.username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          // Photo
          SizedBox(
            width: double.infinity,
            child: CachedNetworkImage(
              imageUrl: photo.url,
              fit: BoxFit.cover,
              placeholder: (context, url) => AspectRatio(
                aspectRatio: 1,
                child: Container(
                  color: AppColors.grey.withOpacity(0.2),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                      strokeWidth: 2,
                    ),
                  ),
                ),
              ),
              errorWidget: (context, url, error) {
                return AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    color: AppColors.grey.withOpacity(0.2),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: AppColors.red,
                            size: 48,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Erreur: $error',
                            style: const TextStyle(color: AppColors.red),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Actions
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Like button
                Row(
                  children: [
                    GestureDetector(
                      onTap: onToggleLike,
                      child: Icon(
                        photo.isLiked 
                          ? Icons.favorite 
                          : Icons.favorite_border,
                        color: photo.isLiked 
                          ? AppColors.red 
                          : AppColors.black,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Icon(
                      Icons.chat_bubble_outline,
                      size: 24,
                    ),
                    const SizedBox(width: 16),
                    const Icon(
                      Icons.send,
                      size: 24,
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.bookmark_border,
                      size: 24,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                
                // Caption
                if (photo.description.isNotEmpty)
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: photo.username,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                            fontSize: 14,
                          ),
                        ),
                        TextSpan(
                          text: ' ${photo.description}',
                          style: const TextStyle(
                            color: AppColors.black,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}