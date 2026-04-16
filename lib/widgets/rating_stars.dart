import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  final int rating;
  final double size;

  const RatingStars({
    super.key,
    required this.rating,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) {
        final filled = index < rating;
        return Icon(
          filled ? Icons.star : Icons.star_border,
          size: size,
          color: filled ? Theme.of(context).colorScheme.primary : Colors.grey,
        );
      }),
    );
  }
}
