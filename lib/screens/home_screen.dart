import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../app_state.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets/primary_button.dart';
import '../widgets/section_header.dart';
import '../widgets/rating_stars.dart';
import 'reviews_screen.dart';
import 'owner_screen.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onBookTap;
  final VoidCallback onServicesTap;

  const HomeScreen({
    super.key,
    required this.onBookTap,
    required this.onServicesTap,
  });

  Future<void> _launchPhone(BuildContext context, String phone) async {
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    final uri = Uri.parse('tel:$digits');
    if (!await launchUrl(uri)) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to place the call right now.')),
      );
    }
  }

  Future<void> _launchMaps(BuildContext context, String address) async {
    final query = Uri.encodeComponent(address);
    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to open maps right now.')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final app = AppStateScope.of(context);
    final business = app.business;
    final services = app.services.take(3).toList();
    final staff = app.staff;
    final reviews = app.reviews.take(2).toList();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.surface, AppColors.ink],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.accent.withOpacity(0.25)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onLongPress: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const OwnerScreen()),
                      );
                    },
                    child: Text(
                      business.name,
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    business.tagline,
                    style: const TextStyle(
                      color: AppColors.sandMuted,
                      fontSize: 16,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    business.address,
                    style: const TextStyle(color: AppColors.sandMuted),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    business.hours,
                    style: const TextStyle(color: AppColors.sandMuted),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: PrimaryButton(
                          label: 'Book Appointment',
                          onPressed: onBookTap,
                          expanded: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SectionHeader(title: 'Quick Actions'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                children: [
                  _ActionChip(
                    icon: Icons.call,
                    label: 'Call',
                    sublabel: business.phone,
                    onTap: () => _launchPhone(context, business.phone),
                  ),
                  const SizedBox(width: 12),
                  _ActionChip(
                    icon: Icons.map,
                    label: 'Directions',
                    sublabel: 'Open Maps',
                    onTap: () => _launchMaps(context, business.address),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SectionHeader(
              title: 'Popular Services',
              actionText: 'See all',
              onAction: onServicesTap,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: services
                    .map((service) => _ServiceTile(service: service))
                    .toList(),
              ),
            ),
            const SectionHeader(title: 'Meet the Team'),
            SizedBox(
              height: 150,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemBuilder: (context, index) {
                  final member = staff[index];
                  return _StaffCard(member: member);
                },
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemCount: staff.length,
              ),
            ),
            SectionHeader(
              title: 'Latest Reviews',
              actionText: 'View all',
              onAction: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ReviewsScreen()),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: reviews
                    .map((review) => _ReviewPreview(review: review))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sublabel;
  final VoidCallback? onTap;

  const _ActionChip({
    required this.icon,
    required this.label,
    required this.sublabel,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.accent.withOpacity(0.2)),
        ),
          child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.accent.withOpacity(0.15),
              child: Icon(icon, color: AppColors.accent),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(
                    sublabel,
                    style: const TextStyle(fontSize: 12, color: AppColors.sandMuted),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
          ),
        ),
      ),
    );
  }
}

class _ServiceTile extends StatelessWidget {
  final Service service;

  const _ServiceTile({required this.service});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1A16),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.content_cut, color: AppColors.accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(service.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(
                  service.description,
                  style: const TextStyle(color: AppColors.sandMuted, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '\$${service.price.toStringAsFixed(0)}',
            style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.accent),
          ),
        ],
      ),
    );
  }
}

class _StaffCard extends StatelessWidget {
  final StaffMember member;

  const _StaffCard({required this.member});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1A16),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.accent.withOpacity(0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.accent.withOpacity(0.2),
            child: Text(
              member.name.substring(0, 1),
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            member.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            member.specialty,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppColors.sandMuted, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _ReviewPreview extends StatelessWidget {
  final Review review;

  const _ReviewPreview({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
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
                child: Text(review.author, style: const TextStyle(fontWeight: FontWeight.w600)),
              ),
              RatingStars(rating: review.rating, size: 14),
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
  }
}
