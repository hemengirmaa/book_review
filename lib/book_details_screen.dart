import 'package:flutter/material.dart';
import 'models.dart';
import 'store.dart';
import 'widgets.dart';

class BookDetailsScreen extends StatefulWidget {
  final Book book;
  final VoidCallback? onReviewAdded;
  
  const BookDetailsScreen({super.key, required this.book, this.onReviewAdded});

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedStatus = 'Finished';
  String librarySection = '';
  String readDate = '14/07/25';
  int timesRead = 1;
  final store = InMemoryStore();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0x00000000),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F4F7),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Book Info',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: ElevatedButton.icon(
              onPressed: () {
                // Handle buy action
              },
              icon: const Icon(Icons.shopping_cart, size: 18),
              label: const Text('BUY'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFED8B2E),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
          ),
        ],
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
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Book Title
              Text(
                widget.book.title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              
              // Book Cover and Details
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Book Cover
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      widget.book.coverUrl ?? kFallbackCover,
                      width: 120,
                      height: 160,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Image.network(
                        kFallbackCover,
                        width: 120,
                        height: 160,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Publication Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow('AUTHOR', widget.book.author),
                        const SizedBox(height: 8),
                        _buildDetailRow('PUBLISHER', widget.book.publisher ?? 'N/A'),
                        const SizedBox(height: 8),
                        _buildDetailRow('ISBN', widget.book.isbn ?? 'N/A'),
                        const SizedBox(height: 8),
                        _buildDetailRow('YEAR', widget.book.year?.toString() ?? 'N/A'),
                        const SizedBox(height: 8),
                        _buildDetailRow('PAGES', widget.book.pages?.toString() ?? 'N/A', isHighlighted: true),
                        const SizedBox(height: 8),
                        _buildDetailRow('LANG', widget.book.language ?? 'N/A'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      'Finished',
                      const Color(0xFFED8B2E),
                      selectedStatus == 'Finished',
                      () => setState(() => selectedStatus = 'Finished'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildActionButton(
                      'Wishlist',
                      const Color(0xFF9C27B0),
                      selectedStatus == 'Wishlist',
                      () => setState(() => selectedStatus = 'Wishlist'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildActionButton(
                      'Reading',
                      const Color(0xFF4CAF50),
                      selectedStatus == 'Reading',
                      () => setState(() => selectedStatus = 'Reading'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Library Tracking Fields
              _buildLibraryField('LIBRARY SECTION', librarySection, (value) => setState(() => librarySection = value)),
              const SizedBox(height: 16),
              _buildLibraryField('READ DATE', readDate, (value) => setState(() => readDate = value)),
              const SizedBox(height: 16),
              _buildLibraryField('TIMES READ', timesRead.toString(), (value) => setState(() => timesRead = int.tryParse(value) ?? 1)),
              const SizedBox(height: 24),
              
              // Tabs
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE6E6E6)),
                ),
                child: Column(
                  children: [
                    TabBar(
                      controller: _tabController,
                      indicatorColor: const Color(0xFFED8B2E),
                      labelColor: const Color(0xFFED8B2E),
                      unselectedLabelColor: Colors.black54,
                      labelStyle: const TextStyle(fontWeight: FontWeight.w600),
                      tabs: const [
                        Tab(text: 'DESCRIPTION'),
                        Tab(text: 'REVIEWS'),
                      ],
                    ),
                    SizedBox(
                      height: 200,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          // Description Tab
                          SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                widget.book.description ?? 'No description available.',
                                style: const TextStyle(
                                  fontSize: 14,
                                  height: 1.5,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                          // Reviews Tab
                          SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: _buildReviewsTab(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFED8B2E),
        onPressed: () => _openReviewForm(),
        child: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }

  void _openReviewForm({Review? review}) async {
    final titleController = TextEditingController(text: review?.title ?? '');
    final bodyController = TextEditingController(text: review?.body ?? '');
    double tempRating = review?.rating ?? 4.0;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: StatefulBuilder(
            builder: (context, setModal) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  // Header
                  Row(
                    children: [
                      Text(
                        review == null ? 'Write a Review' : 'Edit Review',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Book Info
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF2DE),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFF1B64A), width: 1),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            widget.book.coverUrl ?? kFallbackCover,
                            width: 50,
                            height: 70,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Image.network(
                              kFallbackCover,
                              width: 50,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.book.title,
                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.book.author,
                                style: const TextStyle(color: Colors.black54, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Rating Section
                  const Text(
                    'Your Rating',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      StarRating(rating: tempRating),
                      const SizedBox(width: 12),
                      Text(
                        tempRating.toStringAsFixed(1),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Slider(
                    value: tempRating,
                    min: 0,
                    max: 5,
                    divisions: 10,
                    activeColor: const Color(0xFFED8B2E),
                    onChanged: (v) => setModal(() => tempRating = v),
                  ),
                  const SizedBox(height: 16),
                  
                  // Title Field
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: 'Review Title',
                      labelStyle: const TextStyle(color: Colors.black54),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE6E6E6)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFED8B2E), width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Body Field
                  TextField(
                    controller: bodyController,
                    decoration: InputDecoration(
                      labelText: 'Your Review',
                      labelStyle: const TextStyle(color: Colors.black54),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE6E6E6)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFED8B2E), width: 2),
                      ),
                    ),
                    minLines: 3,
                    maxLines: 5,
                  ),
                  const SizedBox(height: 20),
                  
                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (titleController.text.isNotEmpty || bodyController.text.isNotEmpty) {
                          if (review == null) {
                            // Create new review
                            store.addReview(Review(
                              id: DateTime.now().millisecondsSinceEpoch.toString(),
                              bookId: widget.book.id,
                              userId: store.users.first.id,
                              title: titleController.text.isEmpty ? 'Untitled Review' : titleController.text,
                              body: bodyController.text,
                              rating: tempRating,
                            ));
                            // Notify parent that a review was added
                            if (widget.onReviewAdded != null) {
                              widget.onReviewAdded!();
                            }
                          } else {
                            // Update existing review
                            store.updateReview(Review(
                              id: review.id,
                              bookId: widget.book.id,
                              userId: review.userId,
                              title: titleController.text.isEmpty ? 'Untitled Review' : titleController.text,
                              body: bodyController.text,
                              rating: tempRating,
                              likes: review.likes,
                            ));
                            // Notify parent that a review was updated
                            if (widget.onReviewAdded != null) {
                              widget.onReviewAdded!();
                            }
                          }
                          Navigator.pop(context);
                          setState(() {}); // Refresh the reviews tab
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFED8B2E),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        review == null ? 'Submit Review' : 'Update Review',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _deleteReview(Review review) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Review'),
        content: const Text('Are you sure you want to delete this review?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              store.deleteReview(review.id);
              Navigator.pop(context);
              setState(() {}); // Refresh the reviews tab
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

  Widget _buildDetailRow(String label, String value, {bool isHighlighted = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isHighlighted ? const Color(0xFF2196F3) : Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(String text, Color color, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? color : color,
            width: 1.5,
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : color,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildLibraryField(String label, String value, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE6E6E6)),
          ),
          child: TextField(
            controller: TextEditingController(text: value),
            onChanged: onChanged,
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
            ),
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewsTab() {
    final bookReviews = store.getReviews().where((r) => r.bookId == widget.book.id).toList();
    
    if (bookReviews.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.rate_review_outlined,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 12),
            const Text(
              'No reviews yet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Be the first to share your thoughts!',
              style: TextStyle(
                fontSize: 12,
                color: Colors.black38,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _openReviewForm(),
              icon: const Icon(Icons.edit, size: 16),
              label: const Text('Write Review'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFED8B2E),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: bookReviews.length,
      itemBuilder: (context, index) {
        final review = bookReviews[index];
        final user = store.users.firstWhere((u) => u.id == review.userId);
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ReviewCard(
            review: review,
            book: widget.book,
            user: user,
            onEdit: () => _openReviewForm(review: review),
            onDelete: () => _deleteReview(review),
          ),
        );
      },
    );
  }
}
