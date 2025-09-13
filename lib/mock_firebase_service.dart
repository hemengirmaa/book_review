import 'dart:io';
import 'package:uuid/uuid.dart';
import 'models.dart';

class MockFirebaseService {
  static final MockFirebaseService _instance = MockFirebaseService._internal();
  factory MockFirebaseService() => _instance;
  MockFirebaseService._internal();

  final List<Post> _posts = [];
  final Uuid _uuid = const Uuid();

  // Initialize Mock Service
  static Future<void> initialize() async {
    // Mock initialization - always succeeds
    print('Mock Firebase Service initialized');
    // Clear any existing posts to fix null reviews issue
    _instance.clearAllPosts();
  }

  // No sample posts - only user-created posts will be shown
  void _addSamplePosts() {
    // Clear any existing posts to ensure no sample posts remain
    _posts.clear();
  }

  // Clear all posts to fix null reviews issue
  void clearAllPosts() {
    _posts.clear();
  }

  // Mock image upload
  Future<String?> uploadImage(File imageFile) async {
    try {
      // Simulate upload delay
      await Future.delayed(const Duration(seconds: 1));
      // For mock purposes, we'll use the file path as a unique identifier
      // In a real app, this would be uploaded to Firebase Storage
      return 'file://${imageFile.path}';
    } catch (e) {
      print('Mock upload error: $e');
      return null;
    }
  }

  // Create a new post
  Future<String?> createPost(Post post) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Upload image if provided
      String? imageUrl;
      if (post.imagePath != null) {
        final imageFile = File(post.imagePath!);
        imageUrl = await uploadImage(imageFile);
      }

      // Create post with actual image URL
      final postWithImage = Post(
        id: post.id,
        userId: post.userId,
        title: post.title,
        description: post.description,
        imageUrl: imageUrl,
        author: post.author,
        publisher: post.publisher,
        isbn: post.isbn,
        year: post.year,
        pages: post.pages,
        language: post.language,
        category: post.category,
        type: post.type,
        createdAt: post.createdAt,
        updatedAt: post.updatedAt,
        likes: post.likes,
        likedBy: post.likedBy,
      );

      // Add to mock storage
      _posts.insert(0, postWithImage);
      
      return post.id;
    } catch (e) {
      print('Mock create post error: $e');
      return null;
    }
  }

  // Get all posts
  Future<List<Post>> getPosts() async {
    try {
      // Don't call _addSamplePosts() as it clears the posts
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));
      return List.from(_posts);
    } catch (e) {
      print('Mock get posts error: $e');
      return [];
    }
  }

  // Get posts by user
  Future<List<Post>> getPostsByUser(String userId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return _posts.where((post) => post.userId == userId).toList();
    } catch (e) {
      print('Mock get user posts error: $e');
      return [];
    }
  }

  // Update post
  Future<bool> updatePost(Post post) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final index = _posts.indexWhere((p) => p.id == post.id);
      if (index != -1) {
        _posts[index] = post;
        return true;
      }
      return false;
    } catch (e) {
      print('Mock update post error: $e');
      return false;
    }
  }

  // Delete post
  Future<bool> deletePost(String postId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      _posts.removeWhere((post) => post.id == postId);
      return true;
    } catch (e) {
      print('Mock delete post error: $e');
      return false;
    }
  }

  // Like/Unlike post
  Future<bool> toggleLike(String postId, String userId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final index = _posts.indexWhere((post) => post.id == postId);
      if (index != -1) {
        final post = _posts[index];
        final likedBy = List<String>.from(post.likedBy);
        
        if (likedBy.contains(userId)) {
          likedBy.remove(userId);
        } else {
          likedBy.add(userId);
        }

        _posts[index] = Post(
          id: post.id,
          userId: post.userId,
          title: post.title,
          description: post.description,
          imageUrl: post.imageUrl,
          author: post.author,
          publisher: post.publisher,
          isbn: post.isbn,
          year: post.year,
          pages: post.pages,
          language: post.language,
          category: post.category,
          type: post.type,
          createdAt: post.createdAt,
          updatedAt: DateTime.now(),
          likes: likedBy.length,
          likedBy: likedBy,
        );
        return true;
      }
      return false;
    } catch (e) {
      print('Mock toggle like error: $e');
      return false;
    }
  }

  // Stream posts for real-time updates (mock)
  Stream<List<Post>> getPostsStream() {
    // Don't call _addSamplePosts() here as it clears the posts
    return Stream.periodic(const Duration(seconds: 1), (_) => List.from(_posts));
  }


  // Check if user can edit/delete post (only post owner can)
  bool canUserEditPost(String postId, String userId) {
    final post = _posts.firstWhere((p) => p.id == postId, orElse: () => throw Exception('Post not found'));
    return post.userId == userId;
  }
}
