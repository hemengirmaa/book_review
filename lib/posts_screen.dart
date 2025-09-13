import 'dart:io';
import 'package:flutter/material.dart';
import 'models.dart';
import 'mock_firebase_service.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final MockFirebaseService _firebaseService = MockFirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0x00000000),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F4F7),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Posts',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFF2DE), Color(0xFFFFFFFF)],
          ),
        ),
        child: StreamBuilder<List<Post>>(
          stream: _firebaseService.getPostsStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFED8B2E)),
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading posts',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      snapshot.error.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            final posts = snapshot.data ?? [];

            if (posts.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.post_add_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No posts yet',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Be the first to share a book!',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black38,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return _buildPostCard(post);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildPostCard(Post post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6E6E6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  post.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                
                // Description
                Text(
                  post.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                
                // Book Details
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF2DE),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFF1B64A), width: 1),
                  ),
                  child: Column(
                    children: [
                      _buildBookDetailRow('Author', post.author),
                      const SizedBox(height: 4),
                      _buildBookDetailRow('Publisher', post.publisher),
                      const SizedBox(height: 4),
                      _buildBookDetailRow('Category', post.category),
                      const SizedBox(height: 4),
                      _buildBookDetailRow('Type', post.type),
                      if (post.year != null) ...[
                        const SizedBox(height: 4),
                        _buildBookDetailRow('Year', post.year.toString()),
                      ],
                      if (post.pages != null) ...[
                        const SizedBox(height: 4),
                        _buildBookDetailRow('Pages', post.pages.toString()),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Image (if available)
          if (post.imageUrl != null)
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              child: _buildPostImage(post.imageUrl!),
            ),
          
          // Post Footer
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    // Like Button
                    GestureDetector(
                      onTap: () => _toggleLike(post),
                      child: Row(
                        children: [
                          Icon(
                            post.likedBy.contains('current_user_id') 
                                ? Icons.favorite 
                                : Icons.favorite_border,
                            color: post.likedBy.contains('current_user_id') 
                                ? Colors.red 
                                : Colors.grey[600],
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            post.likes.toString(),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    
                    const Spacer(),
                    
                    // Edit/Delete Options (only for post owner)
                    if (_firebaseService.canUserEditPost(post.id, 'current_user_id'))
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => _editPost(post),
                            child: Icon(
                              Icons.edit,
                              color: Colors.grey[600],
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () => _deletePost(post),
                            child: Icon(
                              Icons.delete,
                              color: Colors.red[400],
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    // Date
                    Text(
                      _formatDate(post.createdAt),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                    const Spacer(),
                    
                    // Category Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFED8B2E).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFED8B2E).withOpacity(0.3)),
                      ),
                      child: Text(
                        post.category,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFED8B2E),
                        ),
                      ),
                    ),
                  ],
                ),
                
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            '$label:',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  Future<void> _toggleLike(Post post) async {
    try {
      await _firebaseService.toggleLike(post.id, 'current_user_id');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildPostImage(String imageUrl) {
    // Check if it's a local file path
    if (imageUrl.startsWith('file://')) {
      final filePath = imageUrl.substring(7); // Remove 'file://' prefix
      final file = File(filePath);
      
      return Image.file(
        file,
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          height: 200,
          color: Colors.grey[200],
          child: const Center(
            child: Icon(
              Icons.image_not_supported,
              size: 48,
              color: Colors.grey,
            ),
          ),
        ),
      );
    } else {
      // Network image
      return Image.network(
        imageUrl,
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          height: 200,
          color: Colors.grey[200],
          child: const Center(
            child: Icon(
              Icons.image_not_supported,
              size: 48,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }
  }


  void _editPost(Post post) {
    // Navigate to edit post screen (you can implement this later)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Edit functionality coming soon!'),
        backgroundColor: Color(0xFFED8B2E),
      ),
    );
  }

  void _deletePost(Post post) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Post'),
        content: const Text('Are you sure you want to delete this post?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await _firebaseService.deletePost(post.id);
              if (success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Post deleted successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

}
