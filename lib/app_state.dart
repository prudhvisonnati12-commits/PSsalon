import 'package:flutter/material.dart';
import 'data.dart';
import 'models.dart';

class AppState extends ChangeNotifier {
  BusinessInfo business;
  List<Service> services;
  List<StaffMember> staff;
  List<Review> reviews;
  List<GalleryItem> gallery;
  List<Appointment> appointments;
  bool ownerMode;

  AppState({
    required this.business,
    required this.services,
    required this.staff,
    required this.reviews,
    required this.gallery,
    required this.appointments,
    this.ownerMode = false,
  });

  void toggleOwnerMode() {
    ownerMode = !ownerMode;
    notifyListeners();
  }

  void setOwnerMode(bool enabled) {
    ownerMode = enabled;
    notifyListeners();
  }

  void addService(Service service) {
    services = [...services, service];
    notifyListeners();
  }

  void updateService(Service updated) {
    services = [
      for (final service in services)
        if (service.id == updated.id) updated else service,
    ];
    notifyListeners();
  }

  void removeService(String id) {
    services = services.where((service) => service.id != id).toList();
    notifyListeners();
  }

  void addStaff(StaffMember member) {
    staff = [...staff, member];
    notifyListeners();
  }

  void updateStaff(StaffMember updated) {
    staff = [
      for (final member in staff)
        if (member.id == updated.id) updated else member,
    ];
    notifyListeners();
  }

  void removeStaff(String id) {
    staff = staff.where((member) => member.id != id).toList();
    notifyListeners();
  }

  void addAppointment(Appointment appointment) {
    appointments = [...appointments, appointment];
    notifyListeners();
  }

  void removeAppointment(String id) {
    appointments = appointments.where((appointment) => appointment.id != id).toList();
    notifyListeners();
  }

}

class AppStateScope extends InheritedNotifier<AppState> {
  const AppStateScope({
    super.key,
    required AppState notifier,
    required super.child,
  }) : super(notifier: notifier);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppStateScope>();
    assert(scope != null, 'AppStateScope not found in widget tree');
    return scope!.notifier!;
  }
}

AppState seedAppState() {
  return AppState(
    business: businessInfo,
    services: List<Service>.from(seedServices),
    staff: List<StaffMember>.from(seedStaff),
    reviews: List<Review>.from(seedReviews),
    gallery: List<GalleryItem>.from(seedGallery),
    appointments: <Appointment>[],
  );
}
