import 'package:flutter/material.dart';
import 'models.dart';
import 'book_details_screen.dart';

const String kFallbackCover =
    'https://images.unsplash.com/photo-1524995997946-a1c2e315a42f?auto=format&fit=crop&w=500&q=60';

class CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  const CategoryChip({super.key, required this.label, this.selected = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFFE9D6) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFE6E6E6)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? const Color(0xFFED8B2E) : const Color(0xFF454545),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class BookCoverCard extends StatelessWidget {
  final Book book;
  final VoidCallback? onReviewAdded;
  const BookCoverCard({super.key, required this.book, this.onReviewAdded});

  @override
  Widget build(BuildContext context) {
    
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookDetailsScreen(
              book: book,
              onReviewAdded: onReviewAdded,
            ),
          ),
        );
      },
      child: SizedBox(
        width: 140,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: 3/4,
                child: book.coverUrl != null
                    ? Image.network(
                        book.coverUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Image.network(
                          kFallbackCover,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Image.network(
                        kFallbackCover,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              book.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 2),
            Text(
              book.author,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 2),
          ],
        ),
      ),
    );
  }
}

class StarRating extends StatelessWidget {
  final double rating;
  const StarRating({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final icon = i + 1 <= rating
            ? Icons.star
            : (i + 0.5 < rating ? Icons.star_half : Icons.star_border);
        return Icon(icon, color: const Color(0xFFFFC107), size: 18);
      }),
    );
  }
}

class ReviewCard extends StatefulWidget {
  final Review review;
  final Book book;
  final UserProfile user;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  const ReviewCard({
    super.key,
    required this.review,
    required this.book,
    required this.user,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: widget.user.avatarUrl != null
                    ? NetworkImage(widget.user.avatarUrl!)
                    : null,
                child: widget.user.avatarUrl == null
                    ? const Icon(Icons.person, size: 18)
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.review.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                    Text(widget.user.handle, style: const TextStyle(color: Colors.black54)),
                  ],
                ),
              ),
              if (widget.onEdit != null || widget.onDelete != null)
                PopupMenuButton<String>(
                  onSelected: (v) {
                    if (v == 'edit' && widget.onEdit != null) widget.onEdit!();
                    if (v == 'delete' && widget.onDelete != null) widget.onDelete!();
                  },
                  itemBuilder: (c) => [
                    const PopupMenuItem(value: 'edit', child: Text('Edit')),
                    const PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  widget.book.coverUrl ?? kFallbackCover,
                  width: 60,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Image.network(
                    kFallbackCover,
                    width: 60,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              StarRating(rating: widget.review.rating),
            ],
          ),
          const SizedBox(height: 12),
          
          // Review Text with Expand/Collapse
          if (widget.review.body.isNotEmpty) ...[
            Text(
              widget.review.body,
              style: const TextStyle(
                fontSize: 14,
                height: 1.4,
                color: Colors.black87,
              ),
              maxLines: isExpanded ? null : 3,
              overflow: isExpanded ? null : TextOverflow.ellipsis,
            ),
            if (widget.review.body.length > 100) ...[
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => setState(() => isExpanded = !isExpanded),
                child: Text(
                  isExpanded ? 'Show less' : 'Show more',
                  style: TextStyle(
                    color: const Color(0xFFED8B2E),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 12),
          ],
          
          Row(
            children: [
              Icon(Icons.favorite, color: Colors.red.shade400, size: 18),
              const SizedBox(width: 6),
              Text('${widget.review.likes}'),
            ],
          )
        ],
      ),
    );
  }
}

class HorizontalReviewCard extends StatefulWidget {
  final Review review;
  final Book book;
  final UserProfile user;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onViewFullReview;
  const HorizontalReviewCard({
    super.key,
    required this.review,
    required this.book,
    required this.user,
    this.onEdit,
    this.onDelete,
    this.onViewFullReview,
  });

  @override
  State<HorizontalReviewCard> createState() => _HorizontalReviewCardState();
}

class _HorizontalReviewCardState extends State<HorizontalReviewCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with user info and menu
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: widget.user.avatarUrl != null
                    ? NetworkImage(widget.user.avatarUrl!)
                    : null,
                child: widget.user.avatarUrl == null
                    ? const Icon(Icons.person, size: 16)
                    : null,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.review.title,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      widget.user.handle,
                      style: const TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ],
                ),
              ),
              if (widget.onEdit != null || widget.onDelete != null)
                PopupMenuButton<String>(
                  iconSize: 18,
                  onSelected: (v) {
                    if (v == 'edit' && widget.onEdit != null) widget.onEdit!();
                    if (v == 'delete' && widget.onDelete != null) widget.onDelete!();
                  },
                  itemBuilder: (c) => [
                    const PopupMenuItem(value: 'edit', child: Text('Edit')),
                    const PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Book cover and rating
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  widget.book.coverUrl ?? kFallbackCover,
                  width: 40,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Image.network(
                    kFallbackCover,
                    width: 40,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.book.title,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    StarRating(rating: widget.review.rating),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Review text with expand/collapse
          if (widget.review.body.isNotEmpty) ...[
            Text(
              widget.review.body,
              style: const TextStyle(
                fontSize: 12,
                height: 1.3,
                color: Colors.black87,
              ),
              maxLines: isExpanded ? null : 2,
              overflow: isExpanded ? null : TextOverflow.ellipsis,
            ),
            if (widget.review.body.length > 80) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => setState(() => isExpanded = !isExpanded),
                    child: Text(
                      isExpanded ? 'Show less' : 'Show more',
                      style: const TextStyle(
                        color: Color(0xFFED8B2E),
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: widget.onViewFullReview,
                    child: Text(
                      'View full review',
                      style: const TextStyle(
                        color: Color(0xFFED8B2E),
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 8),
          ],
          
          // Likes
          Row(
            children: [
              Icon(Icons.favorite, color: Colors.red.shade400, size: 14),
              const SizedBox(width: 4),
              Text(
                '${widget.review.likes}',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          )
        ],
      ),
    );
  }
}


