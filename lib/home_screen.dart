import 'package:flutter/material.dart';
import 'models.dart';
import 'store.dart';
import 'widgets.dart';
import 'book_details_screen.dart';
import 'create_post_screen.dart';
import 'posts_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final store = InMemoryStore();
  String selectedCategory = 'All';
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  int _currentIndex = 2; // Home tab is selected by default

  @override
  void initState() {
    super.initState();
    store.seed();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Book> get filteredBooks {
    List<Book> books = store.books;
    
    // Filter by category first (skip if "All" is selected)
    if (selectedCategory != 'All') {
      books = books.where((book) => book.category == selectedCategory).toList();
    }
    
    // Then filter by search query if provided
    if (searchQuery.isNotEmpty) {
      books = books.where((book) {
        return book.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
               book.author.toLowerCase().contains(searchQuery.toLowerCase()) ||
               book.type.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }
    
    return books;
  }

  void _navigateToCreatePost() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreatePostScreen(),
      ),
    );
    
    // Refresh the screen if a post was created successfully
    if (result == true) {
      setState(() {});
    }
  }

  void _openReviewForm({Review? review}) async {
    final titleController = TextEditingController(text: review?.title ?? '');
    final bodyController = TextEditingController(text: review?.body ?? '');
    double tempRating = review?.rating ?? 4.0;
    String bookId = review?.bookId ?? store.books.first.id;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: StatefulBuilder(
            builder: (context, setModal) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(review == null ? 'Add Review' : 'Edit Review',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: bookId,
                    items: store.books
                        .map((b) => DropdownMenuItem(value: b.id, child: Text(b.title)))
                        .toList(),
                    onChanged: (v) => setModal(() => bookId = v ?? bookId),
                  ),
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  TextField(
                    controller: bodyController,
                    decoration: const InputDecoration(labelText: 'Body'),
                    minLines: 2,
                    maxLines: 4,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text('Rating:'),
                      const SizedBox(width: 8),
                      Slider(
                        value: tempRating,
                        min: 0,
                        max: 5,
                        divisions: 10,
                        label: tempRating.toStringAsFixed(1),
                        onChanged: (v) => setModal(() => tempRating = v),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (review == null) {
                          store.addReview(Review(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            bookId: bookId,
                            userId: store.users.first.id,
                            title: titleController.text.isEmpty ? 'Untitled' : titleController.text,
                            body: bodyController.text,
                            rating: tempRating,
                          ));
                        } else {
                          store.updateReview(Review(
                            id: review.id,
                            bookId: bookId,
                            userId: review.userId,
                            title: titleController.text,
                            body: bodyController.text,
                            rating: tempRating,
                            likes: review.likes,
                          ));
                        }
                        Navigator.pop(context);
                        setState(() {});
                      },
                      child: Text(review == null ? 'Save' : 'Update'),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = const ['All', 'Fiction', 'Nonfiction', 'Young Adult', 'Graphics'];

    return Scaffold(
      backgroundColor: const Color(0x00000000),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F4F7),
        elevation: 0,
        centerTitle: true,
        title: const Text('Home', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800)),
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
        child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFF1B64A), width: 1.2),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value.trim();
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: 'Search a book...',
                        hintStyle: TextStyle(color: Colors.black38),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                      style: const TextStyle(fontSize: 16),
                      textInputAction: TextInputAction.search,
                    ),
                  ),
                  if (searchQuery.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        setState(() {
                          searchQuery = '';
                        });
                      },
                      child: const Icon(Icons.clear, color: Colors.black45, size: 20),
                    ),
                  const SizedBox(width: 8),
                  const Icon(Icons.search, color: Colors.black45),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text('Best Sellers', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, i) {
                  final label = categories[i];
                  return CategoryChip(
                    label: label,
                    selected: label == selectedCategory,
                    onTap: () {
                      setState(() {
                        selectedCategory = label;
                        // Clear search when changing category
                        searchQuery = '';
                        _searchController.clear();
                      });
                    },
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemCount: categories.length,
              ),
            ),
            const SizedBox(height: 16),
            filteredBooks.isEmpty
                ? Container(
                    height: 270,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE6E6E6)),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            searchQuery.isEmpty 
                                ? 'No books in this category'
                                : 'No books found for "$searchQuery"',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          if (searchQuery.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            const Text(
                              'Try a different search term',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black38,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  )
                : SizedBox(
              height: 270,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, i) => Align(
                  alignment: Alignment.topLeft,
                        child: BookCoverCard(
                          book: filteredBooks[i],
                          onReviewAdded: () {
                            // Refresh the home page when a review is added
                            setState(() {});
                          },
                        ),
                ),
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemCount: filteredBooks.length,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Expanded(
                  child: Text('Recent Reviews',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
                ),
                TextButton(onPressed: () {}, child: const Text('More')),
              ],
            ),
            const SizedBox(height: 8),
            store.getReviews().isEmpty
                ? Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE6E6E6)),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.rate_review_outlined,
                              size: 40,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'No reviews yet',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Be the first to share!',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.black38,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton.icon(
                              onPressed: () => _openReviewForm(),
                              icon: const Icon(Icons.edit, size: 14),
                              label: const Text('Write Review'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFED8B2E),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : SizedBox(
                    height: 200,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (_, i) {
                        final r = store.getReviews()[i];
              final book = store.books.firstWhere((b) => b.id == r.bookId);
              final user = store.users.firstWhere((u) => u.id == r.userId);
                        return SizedBox(
                          width: 280,
                          child: HorizontalReviewCard(
                            review: r,
                            book: book,
                            user: user,
                            onEdit: () => _openReviewForm(review: r),
                            onDelete: () {
                              store.deleteReview(r.id);
                              setState(() {});
                            },
                            onViewFullReview: () {
                              // Navigate to book details page and scroll to reviews tab
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookDetailsScreen(
                                    book: book,
                                    onReviewAdded: () {
                                      setState(() {});
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemCount: store.getReviews().length,
                    ),
                  ),
            const SizedBox(height: 12),
            const Text('BookList Selection',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, i) {
                  final b = store.books[i % store.books.length];
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          b.coverUrl ?? '',
                          width: 220,
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Image.network(
                            'https://images.unsplash.com/photo-1524995997946-a1c2e315a42f?auto=format&fit=crop&w=600&q=60',
                            width: 220,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 8,
                        bottom: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.55),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${b.title} — ${b.author}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                          ),
                        ),
                      )
                    ],
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemCount: store.books.length,
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFED8B2E),
        onPressed: () => _navigateToCreatePost(),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, -2))
        ]),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          selectedItemColor: const Color(0xFFED8B2E),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.group_outlined), label: 'Friends'),
            BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Posts'),
            BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.menu_book_outlined), label: 'Library'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            
            if (index == 1) { // Posts tab
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PostsScreen(),
                ),
              ).then((_) {
                // Reset to home tab when returning
                setState(() {
                  _currentIndex = 2;
                });
              });
            }
          },
        ),
      ),
    );
  }
}


