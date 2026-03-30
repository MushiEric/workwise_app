import 'package:flutter/material.dart';

class LinkedDriver {
  final int? id;
  final String? name;
  final String? phone;
  final String? image;
  final bool? isOnDuty;

  const LinkedDriver({this.id, this.name, this.phone, this.image, this.isOnDuty});
}

class LinkedTrailer {
  final int? id;
  final String? registrationNumber;
  final String? type;
  final String? name;

  const LinkedTrailer({this.id, this.registrationNumber, this.type, this.name});
}

class LinkedTrip {
  final int? id;
  final String? tripNumber;
  final String? origin;
  final String? destination;
  final String? status;
  final String? statusName;
  final String? statusColor;
  final String? date;
  final String? etd;
  final String? route;

  const LinkedTrip({
    this.id,
    this.tripNumber,
    this.origin,
    this.destination,
    this.status,
    this.statusName,
    this.statusColor,
    this.date,
    this.etd,
    this.route,
  });
}
