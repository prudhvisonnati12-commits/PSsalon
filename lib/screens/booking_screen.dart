import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../app_state.dart';
import '../data.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets/primary_button.dart';
import '../widgets/section_header.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  Service? selectedService;
  StaffMember? selectedStaff;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    notesController.dispose();
    dateController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: bookingWindowDays)),
      initialDate: selectedDate ?? now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context)
                .colorScheme
                .copyWith(primary: AppColors.accent),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        selectedTime = null;
        dateController.text = _formatDate(picked);
      });
    }
  }

  List<TimeOfDay> _generateSlots(DateTime date) {
    final slots = <TimeOfDay>[];
    var cursor = DateTime(date.year, date.month, date.day, bookingOpenHour);
    final end = DateTime(date.year, date.month, date.day, bookingCloseHour);
    while (cursor.isBefore(end)) {
      slots.add(TimeOfDay.fromDateTime(cursor));
      cursor = cursor.add(const Duration(minutes: bookingSlotMinutes));
    }
    return slots;
  }

  bool _isSlotAvailable({
    required DateTime slotStart,
    required Service service,
    required StaffMember staff,
    required List<Appointment> appointments,
  }) {
    for (final appointment in appointments) {
      if (appointment.staffName != staff.name) continue;
      final appointmentStart = appointment.startTime;
      final appointmentEnd = appointmentStart.add(
        Duration(minutes: appointment.durationMinutes),
      );
      final slotEnd = slotStart.add(
        Duration(minutes: service.durationMinutes),
      );
      final overlaps = slotStart.isBefore(appointmentEnd) &&
          slotEnd.isAfter(appointmentStart);
      if (overlaps) return false;
    }
    return true;
  }

  Future<void> _confirmBooking(BuildContext context, AppState app) async {
    if (selectedService == null || selectedStaff == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a service and staff member.')),
      );
      return;
    }
    if (selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date and time slot.')),
      );
      return;
    }
    if (nameController.text.trim().isEmpty || phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add your name and phone number.')),
      );
      return;
    }

    final service = selectedService!;
    final staffMember = selectedStaff!;
    final pickedDate = selectedDate!;
    final pickedTime = selectedTime!;

    final slotStart = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    final appointment = Appointment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      serviceName: service.name,
      staffName: staffMember.name,
      startTime: slotStart,
      durationMinutes: service.durationMinutes,
      customerName: nameController.text.trim(),
      customerPhone: phoneController.text.trim(),
      notes: notesController.text.trim(),
    );

    try {
      await FirebaseFirestore.instance.collection('bookings').add({
        'serviceName': service.name,
        'staffName': staffMember.name,
        'startTime': Timestamp.fromDate(slotStart),
        'durationMinutes': service.durationMinutes,
        'customerName': nameController.text.trim(),
        'customerPhone': phoneController.text.trim(),
        'notes': notesController.text.trim(),
        'status': 'confirmed',
        'createdAt': FieldValue.serverTimestamp(),
        'source': 'app',
      });
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not save booking. Please try again.')),
        );
      }
      return;
    }

    app.addAppointment(appointment);

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Appointment Requested'),
          content: Text(
            '''Service: ${service.name}
Staff: ${staffMember.name}
Date: ${_formatDate(pickedDate)}
Time: ${_formatTime(pickedTime)}

We will confirm your appointment shortly. Payment is in person.''',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Done'),
            ),
          ],
        );
      },
    );

    setState(() {
      selectedService = null;
      selectedStaff = null;
      selectedDate = null;
      selectedTime = null;
      dateController.clear();
      nameController.clear();
      phoneController.clear();
      notesController.clear();
    });
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Select date';
    return '${date.month}/${date.day}/${date.year}';
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return 'Select time';
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final suffix = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $suffix';
  }

  String _formatDateTime(DateTime dateTime) {
    final time = TimeOfDay.fromDateTime(dateTime);
    return '${dateTime.month}/${dateTime.day} ${_formatTime(time)}';
  }

  @override
  Widget build(BuildContext context) {
    final app = AppStateScope.of(context);
    final selectedServiceLocal = selectedService;
    final selectedStaffLocal = selectedStaff;

    final slots = (selectedDate != null)
        ? _generateSlots(selectedDate!)
        : <TimeOfDay>[];

    final availableSlots = (selectedDate != null &&
            selectedServiceLocal != null &&
            selectedStaffLocal != null)
        ? slots.where((slot) {
            final slotStart = DateTime(
              selectedDate!.year,
              selectedDate!.month,
              selectedDate!.day,
              slot.hour,
              slot.minute,
            );
            if (slotStart.isBefore(DateTime.now())) return false;
            return _isSlotAvailable(
              slotStart: slotStart,
              service: selectedServiceLocal,
              staff: selectedStaffLocal,
              appointments: app.appointments,
            );
          }).toList()
        : <TimeOfDay>[];

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'Book an Appointment'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<Service>(
                    isExpanded: true,
                    value: selectedService,
                    items: app.services
                        .map(
                          (service) => DropdownMenuItem(
                            value: service,
                            child: Text('${service.name} (\$${service.price.toStringAsFixed(0)})', overflow: TextOverflow.ellipsis),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => setState(() => selectedService = value),
                    decoration: const InputDecoration(labelText: 'Service'),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<StaffMember>(
                    isExpanded: true,
                    value: selectedStaff,
                    items: app.staff
                        .map(
                          (member) => DropdownMenuItem(
                            value: member,
                            child: Text(member.name, overflow: TextOverflow.ellipsis),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => setState(() => selectedStaff = value),
                    decoration: const InputDecoration(labelText: 'Staff member'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: dateController,
                    readOnly: true,
                    onTap: () => _pickDate(context),
                    decoration: const InputDecoration(
                      labelText: 'Date',
                      hintText: 'Select date',
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Select a Time',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  if (selectedDate == null ||
                      selectedServiceLocal == null ||
                      selectedStaffLocal == null)
                    const Text(
                      'Choose a service, staff member, and date to see available times.',
                      style: TextStyle(color: AppColors.sandMuted, fontSize: 12),
                    )
                  else if (availableSlots.isEmpty)
                    const Text(
                      'No open slots for this date. Please choose another day.',
                      style: TextStyle(color: AppColors.sandMuted, fontSize: 12),
                    )
                  else
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: availableSlots.map((slot) {
                        final isSelected = selectedTime == slot;
                        return ChoiceChip(
                          label: Text(_formatTime(slot)),
                          selected: isSelected,
                          onSelected: (_) => setState(() => selectedTime = slot),
                          selectedColor: AppColors.accent.withOpacity(0.2),
                          backgroundColor: AppColors.surface,
                          labelStyle: TextStyle(
                            color: isSelected ? AppColors.accent : AppColors.sandMuted,
                          ),
                          shape: StadiumBorder(
                            side: BorderSide(color: AppColors.accent.withOpacity(0.3)),
                          ),
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Your name'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(labelText: 'Phone number'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: notesController,
                    maxLines: 3,
                    decoration: const InputDecoration(labelText: 'Notes (optional)'),
                  ),
                  const SizedBox(height: 20),
                  PrimaryButton(
                    label: 'Confirm Appointment',
                    onPressed: () => _confirmBooking(context, app),
                    expanded: true,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Policies',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Late arrivals are accepted when possible. Cancellations are free, and rescheduling is available.',
                          style: TextStyle(color: AppColors.sandMuted, fontSize: 12),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Payment is handled in person at the salon.',
                          style: TextStyle(color: AppColors.sandMuted, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Upcoming Appointments',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  if (app.appointments.isEmpty)
                    const Text(
                      'No upcoming appointments yet.',
                      style: TextStyle(color: AppColors.sandMuted, fontSize: 12),
                    )
                  else
                    Column(
                      children: app.appointments.map((appointment) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1C1A16),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.accent.withOpacity(0.1)),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${appointment.serviceName} with ${appointment.staffName}',
                                      style: const TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _formatDateTime(appointment.startTime),
                                      style: const TextStyle(color: AppColors.sandMuted, fontSize: 12),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      appointment.customerName,
                                      style: const TextStyle(color: AppColors.sandMuted, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              TextButton(
                                onPressed: () => app.removeAppointment(appointment.id),
                                child: const Text('Cancel'),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
