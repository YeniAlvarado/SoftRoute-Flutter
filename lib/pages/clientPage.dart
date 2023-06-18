import 'dart:convert';
import 'package:flutter/material.dart';
import '../main.dart';
import 'package:http/http.dart' as http;
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import '../widgets/appBar.dart';
import '../widgets/trackingCard.dart';

class ClientPage extends StatefulWidget {

  const ClientPage({Key? key}) : super(key: key);

  @override
  State<ClientPage> createState() => _ClientPageState();
}

class _ClientPageState extends State<ClientPage> {
  final items=[
    Icon(Icons.home, color: Colors.white),
    Icon(Icons.comment, color: Colors.white),
  ];

  int index=0;

  late String codeSended;
  final code=TextEditingController();

  @override
  void initState() {
    super.initState();
    codeSended = '';
  }
  void updateSearchQuery(String query) {
    setState(() {
      codeSended = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: CustomAppBar(username:"Client"),
          bottomNavigationBar: CurvedNavigationBar(
            height: 60,
            backgroundColor: Colors.transparent,
            color: Colors.deepPurple,
            items: items,
            index: index,
            onTap: (index){
              setState(() {
                this.index=index;
              });
            },
            animationDuration: Duration(milliseconds: 300),
          ),
          body:Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                  controller: code,
                  style: const TextStyle(color:Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xffC8A1FF),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none
                    ),
                    hintText: "Enter tracking number",
                    hintStyle: const TextStyle(
                        color:Colors.white
                    ),
                    prefixIcon: IconButton(
                      icon:Icon(Icons.search),
                      color:Colors.white,
                      onPressed: (){
                        codeSended=code.text;
                        updateSearchQuery(code.text);
                        print("Boton presionado!");
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Text("Tracking"),
                TrackingCard(searchQuery: codeSended),
              ],
            ),
          )
      ),
    );
  }
}