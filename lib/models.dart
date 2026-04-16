import 'package:flutter/material.dart';

@immutable
class BusinessInfo {
  final String name;
  final String tagline;
  final String address;
  final String phone;
  final String hours;

  const BusinessInfo({
    required this.name,
    required this.tagline,
    required this.address,
    required this.phone,
    required this.hours,
  });
}

@immutable
class Service {
  final String id;
  final String name;
  final double price;
  final int durationMinutes;
  final String description;

  const Service({
    required this.id,
    required this.name,
    required this.price,
    required this.durationMinutes,
    required this.description,
  });

  Service copyWith({
    String? name,
    double? price,
    int? durationMinutes,
    String? description,
  }) {
    return Service(
      id: id,
      name: name ?? this.name,
      price: price ?? this.price,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      description: description ?? this.description,
    );
  }
}

@immutable
class StaffMember {
  final String id;
  final String name;
  final String specialty;

  const StaffMember({
    required this.id,
    required this.name,
    required this.specialty,
  });

  StaffMember copyWith({
    String? name,
    String? specialty,
  }) {
    return StaffMember(
      id: id,
      name: name ?? this.name,
      specialty: specialty ?? this.specialty,
    );
  }
}

@immutable
class Review {
  final String id;
  final String author;
  final String source;
  final int rating;
  final String text;

  const Review({
    required this.id,
    required this.author,
    required this.source,
    required this.rating,
    required this.text,
  });
}

@immutable
class GalleryItem {
  final String id;
  final String title;
  final String subtitle;
  final String? imagePath;

  const GalleryItem({
    required this.id,
    required this.title,
    required this.subtitle,
    this.imagePath,
  });
}

@immutable
class Appointment {
  final String id;
  final String serviceName;
  final String staffName;
  final DateTime startTime;
  final int durationMinutes;
  final String customerName;
  final String customerPhone;
  final String notes;

  const Appointment({
    required this.id,
    required this.serviceName,
    required this.staffName,
    required this.startTime,
    required this.durationMinutes,
    required this.customerName,
    required this.customerPhone,
    required this.notes,
  });
}
