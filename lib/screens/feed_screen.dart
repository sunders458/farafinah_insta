import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:farafinah_insta/providers/auth_provider.dart';
import 'package:farafinah_insta/providers/photo_provider.dart';
import 'package:farafinah_insta/utils/constants.dart';
import 'package:farafinah_insta/widgets/photo_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Load photos when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PhotoProvider>(context, listen: false).fetchPhotos();
    });

    // Add scroll listener for pagination
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  // Pagination logic - load more photos when user reaches end of list
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 500) {
      final photoProvider = Provider.of<PhotoProvider>(context, listen: false);
      if (!photoProvider.isLoadingMore && photoProvider.hasNextPage) {
        photoProvider.loadMorePhotos();
      }
    }
  }

  // Refresh feed
  Future<void> _refreshFeed() async {
    await Provider.of<PhotoProvider>(context, listen: false).fetchPhotos();
  }

  // Log out
  void _logout() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Déconnexion'),
          content: const Text('Voulez-vous vraiment vous déconnecter ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext)
                  .pop(), // <- Important : utiliser dialogContext
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop(); // Ferme la boîte de dialogue

                // Attendre que la boîte soit complètement fermée
                await Future.delayed(const Duration(milliseconds: 100));

                // Utiliser context original SEULEMENT si monté
                if (!mounted) return;

                final authProvider =
                    Provider.of<AuthProvider>(context, listen: false);
                await authProvider.logout();

                if (!mounted) return;
                Navigator.of(context).pushReplacementNamed(Routes.login);
              },
              child: const Text('Déconnecter'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Image.asset(
          AppAssets.logoPath,
          height: 40,
          fit: BoxFit.contain,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Déconnexion',
            onPressed: _logout,
            color: AppColors.black,
          ),
        ],
      ),
      // drawer: Drawer(
      //   child: ListView(
      //     padding: EdgeInsets.zero,
      //     children: [
      //       DrawerHeader(
      //         decoration: const BoxDecoration(
      //           color: AppColors.primary,
      //         ),
      //         child: Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           mainAxisAlignment: MainAxisAlignment.end,
      //           children: [
      //             const CircleAvatar(
      //               radius: 30,
      //               backgroundColor: AppColors.white,
      //               child: Icon(
      //                 Icons.person,
      //                 size: 40,
      //                 color: AppColors.darkGrey,
      //               ),
      //             ),
      //             const SizedBox(height: 10),
      //             Consumer<AuthProvider>(
      //               builder: (context, authProvider, _) {
      //                 return Text(
      //                   authProvider.currentUser?.username ?? 'Utilisateur',
      //                   style: const TextStyle(
      //                     color: AppColors.white,
      //                     fontSize: 18,
      //                     fontWeight: FontWeight.bold,
      //                   ),
      //                 );
      //               },
      //             ),
      //           ],
      //         ),
      //       ),
      //       ListTile(
      //         leading: const Icon(Icons.home),
      //         title: const Text('Accueil'),
      //         onTap: () {
      //           Navigator.pop(context);
      //         },
      //       ),
      //       ListTile(
      //         leading: const Icon(Icons.favorite),
      //         title: const Text('Mes likes'),
      //         onTap: () {
      //           // Fermer le drawer
      //           Navigator.pop(context);
      //           // Afficher un message
      //           ScaffoldMessenger.of(context).showSnackBar(
      //             const SnackBar(
      //               content: Text('Fonctionnalité en cours de développement'),
      //               duration: Duration(seconds: 2),
      //             ),
      //           );
      //         },
      //       ),
      //       const Divider(),
      //       ListTile(
      //         leading: const Icon(Icons.logout, color: AppColors.red),
      //         title: const Text(
      //           'Déconnexion',
      //           style: TextStyle(color: AppColors.red),
      //         ),
      //         onTap: () {
      //           Navigator.pop(context);
      //           _logout();
      //         },
      //       ),
      //     ],
      //   ),
      // ),
      body: Consumer<PhotoProvider>(
        builder: (context, photoProvider, child) {
          // Show error if any
          if (photoProvider.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: AppColors.red,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Une erreur s\'est produite',
                    style: TextStyles.subtitle,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _refreshFeed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                    ),
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          }

          // Show loading indicator for initial load
          if (photoProvider.isLoading) {
            return ListView.builder(
              padding: const EdgeInsets.only(top: 8),
              itemCount: 5,
              itemBuilder: (context, index) => _buildShimmerItem(),
            );
          }

          // Show feed with pull-to-refresh
          return RefreshIndicator(
            onRefresh: _refreshFeed,
            color: AppColors.primary,
            child: ListView.builder(
              controller: _scrollController,
              itemCount: photoProvider.photos.length +
                  (photoProvider.isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                // Show loading indicator at the bottom when loading more
                if (index == photoProvider.photos.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  );
                }

                // Show photo card
                final photo = photoProvider.photos[index];
                return PhotoCard(
                  photo: photo,
                  onToggleLike: () => photoProvider.toggleLike(photo.id),
                );
              },
            ),
          );
        },
      ),
    );
  }

  // Shimmer loading effect for photos
  Widget _buildShimmerItem() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Shimmer.fromColors(
        baseColor: AppColors.grey.withOpacity(0.3),
        highlightColor: AppColors.grey.withOpacity(0.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User info shimmer
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: Row(
                children: [
                  const CircleAvatar(radius: 16),
                  const SizedBox(width: 8),
                  Container(
                    width: 100,
                    height: 14,
                    color: AppColors.white,
                  ),
                ],
              ),
            ),

            // Image shimmer
            Container(
              width: double.infinity,
              height: 300,
              color: AppColors.white,
            ),

            // Actions shimmer
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 150,
                    height: 14,
                    color: AppColors.white,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: double.infinity,
                    height: 12,
                    color: AppColors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
