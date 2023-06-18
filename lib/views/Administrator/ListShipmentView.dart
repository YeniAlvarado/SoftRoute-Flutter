import 'dart:convert';
import 'package:example_souf_route/models/Shipment.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListShipmentView extends StatefulWidget {
  const ListShipmentView({Key? key}) : super(key: key);

  @override
  State<ListShipmentView> createState() => _ListShipmentViewState();
}

class _ListShipmentViewState extends State<ListShipmentView> {
  String url = "http://20.150.216.134:7070/api/v1/shipments";
  List<Shipment> shipments = [];

  Future<void> fetchShipments() async {
    final response = await http
        .get(Uri.parse('http://20.150.216.134:7070/api/v1/shipments'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        shipments = data
            .map((json) => Shipment(
                description: json['description'],
                quantity: json['quantity'],
                freight: json['freight'],
                weight: json['weight'],
                date: json['date'],
                destinyId: json['destinyId'],
                consigneesId: json['consigneesId'],
                senderId: json['senderId'],
                typeOfPackageId: json['typeOfPackageId'],
                documentId: json['documentId']))
            .toList();
      });
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    this.fetchShipments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: shipments == null ? 0 : shipments?.length,
          itemBuilder: (context, index) {
            return Card(
              color: Color(0xFFFFFFFF),
              child: ListTile(
                title: Text(shipments[index].description),
                subtitle: Text(shipments[index].date),
              ),
            );
          }),
    );
  }
}
