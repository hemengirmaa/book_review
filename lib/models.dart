class Book {
  final String id;
  String title;
  String author;
  String? coverUrl;
  String? coverAsset;
  String category;
  String type; // Novel, Biography, Textbook, etc.
  String? publisher;
  String? isbn;
  int? year;
  int? pages;
  String? language;
  String? description;

  Book({
    required this.id,
    required this.title,
    required this.author,
    this.coverUrl,
    this.coverAsset,
    required this.category,
    required this.type,
    this.publisher,
    this.isbn,
    this.year,
    this.pages,
    this.language,
    this.description,
  });
}

class UserProfile {
  final String id;
  String handle;
  String? avatarUrl;
  String? avatarAsset;

  UserProfile({
    required this.id,
    required this.handle,
    this.avatarUrl,
    this.avatarAsset,
  });
}

class Review {
  final String id;
  final String bookId;
  final String userId;
  String title;
  String body;
  double rating; // 0..5
  int likes;

  Review({
    required this.id,
    required this.bookId,
    required this.userId,
    required this.title,
    required this.body,
    required this.rating,
    this.likes = 0,
  });
}


class Post {
  final String id;
  final String userId;
  String title;
  String description;
  String? imageUrl;
  String? imagePath; // Local path for image before upload
  String author;
  String publisher;
  String? isbn;
  int? year;
  int? pages;
  String? language;
  String category;
  String type;
  DateTime createdAt;
  DateTime updatedAt;
  int likes;
  List<String> likedBy; // List of user IDs who liked this post

  Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    this.imageUrl,
    this.imagePath,
    required this.author,
    required this.publisher,
    this.isbn,
    this.year,
    this.pages,
    this.language,
    required this.category,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    this.likes = 0,
    this.likedBy = const [],
  });

  // Convert Post to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'author': author,
      'publisher': publisher,
      'isbn': isbn,
      'year': year,
      'pages': pages,
      'language': language,
      'category': category,
      'type': type,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'likes': likes,
      'likedBy': likedBy,
    };
  }

  // Create Post from Map (from Firestore)
  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'],
      author: map['author'] ?? '',
      publisher: map['publisher'] ?? '',
      isbn: map['isbn'],
      year: map['year'],
      pages: map['pages'],
      language: map['language'],
      category: map['category'] ?? '',
      type: map['type'] ?? '',
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(map['updatedAt'] ?? DateTime.now().toIso8601String()),
      likes: map['likes'] ?? 0,
      likedBy: List<String>.from(map['likedBy'] ?? []),
    );
  }
}


