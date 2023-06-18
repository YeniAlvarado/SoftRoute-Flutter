import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Feedback {
  final String date;
  final String description;
  final String typeOfComplaintId;
  final String shipmentId;

  Feedback({
    required this.date,
    required this.description,
    required this.typeOfComplaintId,
    required this.shipmentId
  });

}
