import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../models/TypeOfComplaint.dart';
import '../../models/FeedbackCliente.dart';


class AddCommentView extends StatefulWidget {
  const AddCommentView({super.key});

  @override
  State<AddCommentView> createState() => _AddCommentViewState();
}

class _AddCommentViewState extends State<AddCommentView> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _typeOfComplaintIdController = TextEditingController();
  final TextEditingController _shipmentIdController = TextEditingController();
  Future<void> addComment() async { try {
    final feedbackCliente = FeedbackCliente(
      date: DateTime.now().toString(),
      description: _descriptionController.text,
      typeOfComplaintId: int.parse(selectedItem?.id.toString() ?? ''),
      shipmentId: int.parse(_shipmentIdController.text),
    );
    print(feedbackCliente.typeOfComplaintId);
    print(feedbackCliente.shipmentId);
    print(feedbackCliente.description);
    print(feedbackCliente.date);

    final url = Uri.parse('http://20.150.216.134:7070/api/v1/feedback');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(feedbackCliente),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Comentario enviado con éxito');
    } else {
      print('Error al enviar el comentario');
    }
}catch (error) {
    print('Error en la solicitud POST: $error');

  }
  }
  //DATOS QUE IRAN EN EL DROPDOWN
  List<TypeOfComplaint> items = [];
  TypeOfComplaint? selectedItem;

  Future<List<TypeOfComplaint>> fetchData() async {
    final url = 'http://20.150.216.134:7070/api/v1/typeofcomplaint';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((item) => TypeOfComplaint.fromJson(item)).toList();
    } else {
      throw Exception('Error al obtener los datos de la API');
    }
  }


  @override
  void initState() {
    super.initState();
    fetchData().then((data) {
      setState(() {
        items = data;
        selectedItem = data.isNotEmpty ? data[0] : null;
      });
    }).catchError((error) {
      print('Error: $error');
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 20,),
          Align(
            alignment: Alignment.centerLeft,
            child: const Text("Add Comment",style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold
            ),),
          ),
          const SizedBox(height: 20),
          RatingBar.builder(
            initialRating: 0,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemSize: 30,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color:Color(0xffC8A1FF),
            ),
            onRatingUpdate: (rating) {
              print(rating);
            },
          ),
          Row(
            children: [
              Expanded(
                  child:Text(
                    "Select the type of complaint",style: TextStyle(fontSize: 15),),
              ),
              SizedBox(
                width: 100,
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(width:1,color:Color(0xffC8A1FF))
                    ),
                  ),
                  value: selectedItem?.name,
                  items: items.map((item) => DropdownMenuItem<String>(
                    value: item.name,
                    child: Text(item.name, style: TextStyle(fontSize: 15)),
                  )).toList(),
                  onChanged:(value){
                    setState(() {
                      selectedItem = items.firstWhere((item) => item.name == value);
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20,),

          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(
              filled: true,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(width:1,color:Color(0xFFC8A1FF))
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 35),
              hintText: " Add feedback",
              hintStyle: const TextStyle(
                  color:Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 20,),
          TextField(
            controller: _shipmentIdController,
            decoration: InputDecoration(
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(width: 1, color: Color(0xFFC8A1FF)),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 15),
              hintText: 'Enter ShipmentId',
              hintStyle: TextStyle(color: Colors.black),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: 150,
              height: 40,
              child: ElevatedButton(
                onPressed: addComment,
                child: const Text("Send"),
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xffC8A1FF),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    ),
    );
  }
}
