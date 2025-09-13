import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'models.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Uuid _uuid = const Uuid();

  // Initialize Firebase
  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp();
    } catch (e) {
      print('Firebase initialization failed: $e');
      // Continue without Firebase for now
    }
  }

  // Upload image to Firebase Storage
  Future<String?> uploadImage(File imageFile) async {
    try {
      final String fileName = '${_uuid.v4()}.jpg';
      final Reference ref = _storage.ref().child('post_images/$fileName');
      
      final UploadTask uploadTask = ref.putFile(imageFile);
      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  // Create a new post
  Future<String?> createPost(Post post) async {
    try {
      // Upload image if provided
      String? imageUrl;
      if (post.imagePath != null) {
        final imageFile = File(post.imagePath!);
        imageUrl = await uploadImage(imageFile);
      }

      // Create post with image URL
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

      // Save to Firestore
      await _firestore.collection('posts').doc(post.id).set(postWithImage.toMap());
      
      return post.id;
    } catch (e) {
      print('Error creating post: $e');
      return null;
    }
  }

  // Get all posts
  Future<List<Post>> getPosts() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('posts')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Post.fromMap(data);
      }).toList();
    } catch (e) {
      print('Error getting posts: $e');
      return [];
    }
  }

  // Get posts by user
  Future<List<Post>> getPostsByUser(String userId) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('posts')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Post.fromMap(data);
      }).toList();
    } catch (e) {
      print('Error getting user posts: $e');
      return [];
    }
  }

  // Update post
  Future<bool> updatePost(Post post) async {
    try {
      await _firestore.collection('posts').doc(post.id).update(post.toMap());
      return true;
    } catch (e) {
      print('Error updating post: $e');
      return false;
    }
  }

  // Delete post
  Future<bool> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
      return true;
    } catch (e) {
      print('Error deleting post: $e');
      return false;
    }
  }

  // Like/Unlike post
  Future<bool> toggleLike(String postId, String userId) async {
    try {
      final DocumentReference postRef = _firestore.collection('posts').doc(postId);
      
      return await _firestore.runTransaction((transaction) async {
        final DocumentSnapshot snapshot = await transaction.get(postRef);
        
        if (!snapshot.exists) {
          return false;
        }

        final data = snapshot.data() as Map<String, dynamic>;
        final List<String> likedBy = List<String>.from(data['likedBy'] ?? []);
        
        if (likedBy.contains(userId)) {
          // Unlike
          likedBy.remove(userId);
        } else {
          // Like
          likedBy.add(userId);
        }

        transaction.update(postRef, {
          'likedBy': likedBy,
          'likes': likedBy.length,
          'updatedAt': DateTime.now().toIso8601String(),
        });

        return true;
      });
    } catch (e) {
      print('Error toggling like: $e');
      return false;
    }
  }

  // Stream posts for real-time updates
  Stream<List<Post>> getPostsStream() {
    return _firestore
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Post.fromMap(data);
      }).toList();
    });
  }
}
