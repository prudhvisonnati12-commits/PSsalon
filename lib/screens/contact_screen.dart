import 'package:flutter/material.dart';
import '../app_state.dart';
import '../theme.dart';
import '../widgets/section_header.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final business = AppStateScope.of(context).business;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          const SectionHeader(title: 'Contact & Hours'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                _InfoCard(
                  title: 'Address',
                  value: business.address,
                  icon: Icons.location_on,
                ),
                const SizedBox(height: 12),
                _InfoCard(
                  title: 'Phone',
                  value: business.phone,
                  icon: Icons.call,
                ),
                const SizedBox(height: 12),
                _InfoCard(
                  title: 'Hours',
                  value: business.hours,
                  icon: Icons.schedule,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Policies', style: TextStyle(fontWeight: FontWeight.w600)),
                      SizedBox(height: 8),
                      Text(
                        'Late arrivals are accepted when possible. Cancellations are free and rescheduling is available.',
                        style: TextStyle(color: AppColors.sandMuted, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _InfoCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1A16),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accent.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.accent.withOpacity(0.15),
            child: Icon(icon, color: AppColors.accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(color: AppColors.sandMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
