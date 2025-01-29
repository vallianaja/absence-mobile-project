import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AttendHistoryScreen extends StatefulWidget {
  const AttendHistoryScreen({super.key});

  @override
  State<AttendHistoryScreen> createState() => _AttendHistoryScreenState();
}

class _AttendHistoryScreenState extends State<AttendHistoryScreen> {
  final CollectionReference dataCollection =
  FirebaseFirestore.instance.collection('absen');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        title: const Text(
          'History Attendance',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: FutureBuilder<QuerySnapshot>(
          future: dataCollection.get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data!.docs;
              return data.isNotEmpty
                  ? ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                      elevation: 5,
                      margin: const EdgeInsets.all(10),
                      color: Colors.white,
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                color: Colors.primaries[Random().nextInt(
                                    Colors.primaries.length)],
                                borderRadius: BorderRadius.circular(50)
                            ),
                            child: Center(
                              child: Text((data.isNotEmpty&&data[index]['name']!=null)
                                  ?
                              data[index]['name'][0].toUpperCase():'-',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),),
                            ),

                          ),
                          const SizedBox(width: 10,),
                          Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      const Expanded(
                                          flex: 4,
                                          child: Text("name", style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                          ),)
                                      ),
                                      const Expanded(flex: 1,
                                          child: Text(':', style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14),)),
                                      Expanded(child: Text(data[index]['name'],
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 14
                                        ),))
                                    ],
                                  ),

                                  Row(
                                    children: [
                                      const Expanded(
                                          flex: 4,
                                          child: Text(
                                            "address", style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                          ),)
                                      ),
                                      const Expanded(flex: 1,
                                          child: Text(':', style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14),)),
                                      Expanded(child: Text(
                                        data[index]['address'],
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 14
                                        ),))
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Expanded(
                                          flex: 4,
                                          child: Text(
                                            "status", style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                          ),)
                                      ),
                                      const Expanded(flex: 1,
                                          child: Text(':', style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14),)),
                                      Expanded(child: Text(
                                        data[index]['status'],
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 14
                                        ),))
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Expanded(
                                          flex: 4,
                                          child: Text(
                                            "date/time", style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                          ),)
                                      ),
                                      const Expanded(flex: 1,
                                          child: Text(':', style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14),)),
                                      Expanded(child: Text(
                                        data[index]['dateTime'],
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 14
                                        ),))
                                    ],
                                  ),

                                ],

                              )
                          )

                        ],
                      ),
                    );
                  }) : const Center(
                child: Text(
                  "Ups, data not found", style: TextStyle(fontSize: 20),),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                ),
              );
            }
          }
      ),
    );
  }
}
