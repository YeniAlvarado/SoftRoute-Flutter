import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FeedbackCliente {
  String date;
  String description;
  int typeOfComplaintId;
  int shipmentId;

  FeedbackCliente({
    required this.date,
    required this.description,
    required this.typeOfComplaintId,
    required this.shipmentId,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'description': description,
      'typeOfComplaintId': typeOfComplaintId,
      'shipmentId': shipmentId,
    };
  }
}

