import 'package:flutter/material.dart';
import '../app_state.dart';
import '../theme.dart';
import '../widgets/rating_stars.dart';
import '../widgets/section_header.dart';

class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reviews = AppStateScope.of(context).reviews;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reviews'),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          const SectionHeader(title: 'Customer Reviews'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: reviews.map((review) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C1A16),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              review.author,
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                          RatingStars(rating: review.rating, size: 16),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        review.text,
                        style: const TextStyle(color: AppColors.sandMuted, fontSize: 13),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        review.source,
                        style: const TextStyle(color: AppColors.accentMuted, fontSize: 12),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Reviews will sync from Google and the website once live API connections are configured.',
              style: const TextStyle(color: AppColors.sandMuted, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
