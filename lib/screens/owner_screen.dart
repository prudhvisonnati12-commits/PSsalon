import 'package:flutter/material.dart';
import '../app_state.dart';
import '../models.dart';
import '../theme.dart';

class OwnerScreen extends StatelessWidget {
  const OwnerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppStateScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Owner Mode'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Owner Mode',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Switch(
                  value: app.ownerMode,
                  onChanged: app.setOwnerMode,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _SectionTitle(
            title: 'Services',
            action: 'Add',
            onAction: () => _showServiceDialog(context),
          ),
          const SizedBox(height: 8),
          ...app.services.map((service) {
            return _EditableTile(
              title: service.name,
              subtitle: '\$${service.price.toStringAsFixed(0)} • ${service.durationMinutes} min',
              onEdit: () => _showServiceDialog(context, service: service),
              onDelete: () => app.removeService(service.id),
            );
          }).toList(),
          const SizedBox(height: 20),
          _SectionTitle(
            title: 'Staff',
            action: 'Add',
            onAction: () => _showStaffDialog(context),
          ),
          const SizedBox(height: 8),
          ...app.staff.map((member) {
            return _EditableTile(
              title: member.name,
              subtitle: member.specialty,
              onEdit: () => _showStaffDialog(context, member: member),
              onDelete: () => app.removeStaff(member.id),
            );
          }).toList(),
          const SizedBox(height: 20),
          const Text(
            'Owner Mode updates are stored in memory for now. We can connect this to Firebase when you are ready to manage data from anywhere.',
            style: TextStyle(color: AppColors.sandMuted, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Future<void> _showServiceDialog(BuildContext context, {Service? service}) async {
    final app = AppStateScope.of(context);
    final nameController = TextEditingController(text: service?.name ?? '');
    final priceController = TextEditingController(text: service?.price.toStringAsFixed(0) ?? '');
    final durationController = TextEditingController(text: service?.durationMinutes.toString() ?? '30');
    final descriptionController = TextEditingController(text: service?.description ?? '');

    final result = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(service == null ? 'Add Service' : 'Edit Service'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
                const SizedBox(height: 10),
                TextField(controller: priceController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Price')),
                const SizedBox(height: 10),
                TextField(controller: durationController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Duration (min)')),
                const SizedBox(height: 10),
                TextField(controller: descriptionController, decoration: const InputDecoration(labelText: 'Description')),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
            TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Save')),
          ],
        );
      },
    );

    if (result == true) {
      final updated = Service(
        id: service?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: nameController.text.trim(),
        price: double.tryParse(priceController.text) ?? 0,
        durationMinutes: int.tryParse(durationController.text) ?? 30,
        description: descriptionController.text.trim(),
      );
      if (service == null) {
        app.addService(updated);
      } else {
        app.updateService(updated);
      }
    }
  }

  Future<void> _showStaffDialog(BuildContext context, {StaffMember? member}) async {
    final app = AppStateScope.of(context);
    final nameController = TextEditingController(text: member?.name ?? '');
    final specialtyController = TextEditingController(text: member?.specialty ?? '');

    final result = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(member == null ? 'Add Staff' : 'Edit Staff'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
              const SizedBox(height: 10),
              TextField(controller: specialtyController, decoration: const InputDecoration(labelText: 'Specialty')),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
            TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Save')),
          ],
        );
      },
    );

    if (result == true) {
      final updated = StaffMember(
        id: member?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: nameController.text.trim(),
        specialty: specialtyController.text.trim(),
      );
      if (member == null) {
        app.addStaff(updated);
      } else {
        app.updateStaff(updated);
      }
    }
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String action;
  final VoidCallback onAction;

  const _SectionTitle({
    required this.title,
    required this.action,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        TextButton(onPressed: onAction, child: Text(action)),
      ],
    );
  }
}

class _EditableTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _EditableTile({
    required this.title,
    required this.subtitle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1A16),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: AppColors.sandMuted, fontSize: 12)),
              ],
            ),
          ),
          IconButton(onPressed: onEdit, icon: const Icon(Icons.edit, size: 20)),
          IconButton(onPressed: onDelete, icon: const Icon(Icons.delete_outline, size: 20)),
        ],
      ),
    );
  }
}
