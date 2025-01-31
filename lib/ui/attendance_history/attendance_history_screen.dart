import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AttendanceHistoryScreen extends StatefulWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  State<AttendanceHistoryScreen> createState() =>
      _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
  final CollectionReference dataCollection =
      FirebaseFirestore.instance.collection('attendance');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Attendance History",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
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
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 5,
                          margin: const EdgeInsets.fromLTRB(17, 15, 17, 10),
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                            child: Row(
                              children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Center(
                                    child: Text(
                                      (data.isNotEmpty &&
                                              data[index]['name'] != null)
                                          ? data[index]['name'][0].toUpperCase()
                                          : '-',
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Flexible(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            const Expanded(
                                                flex: 2,
                                                child: Text(
                                                  'name',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14),
                                                )),
                                            const Expanded(
                                                flex: 1,
                                                child: Text(
                                                  ':',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14),
                                                )),
                                            Expanded(
                                                child: Text(
                                                  data[index]['name'],
                                                  style: const TextStyle(
                                                      color: Colors.black, fontSize: 14),
                                                ))
                                          ],
                                        ),
                                        const SizedBox(height: 4,),
                                        Row(
                                          children: [
                                            const Expanded(
                                                flex: 2,
                                                child: Text(
                                                  'address',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14),
                                                )),
                                            const Expanded(
                                                flex: 1,
                                                child: Text(
                                                  ':',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14),
                                                )),
                                            Expanded(
                                                child: Text(
                                                  data[index]['address'],
                                                  style: const TextStyle(
                                                      color: Colors.black, fontSize: 14),
                                                ))
                                          ],
                                        ),
                                        const SizedBox(height: 4,),
                                        Row(
                                          children: [
                                            const Expanded(
                                                flex: 2,
                                                child: Text(
                                                  'status',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14),
                                                )),
                                            const Expanded(
                                                flex: 1,
                                                child: Text(
                                                  ':',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14),
                                                )),
                                            Expanded(
                                                child: Text(
                                                  data[index]['status'],
                                                  style: const TextStyle(
                                                      color: Colors.black, fontSize: 14),
                                                ))
                                          ],
                                        ),
                                        const SizedBox(height: 4,),
                                        Row(
                                          children: [
                                            const Expanded(
                                                flex: 2,
                                                child: Text(
                                                  'dateTime',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14),
                                                )),
                                            const Expanded(
                                                flex: 1,
                                                child: Text(
                                                  ':',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14),
                                                )),
                                            Expanded(
                                                child: Text(
                                                  data[index]['dateTime'],
                                                  style: const TextStyle(
                                                      color: Colors.black, fontSize: 11),
                                                ))
                                          ],
                                        ),
                                      ],
                                    ))
                              ],
                            ),
                          ),
                        );
                      })
                  : const Center(
                      child: Text(
                        "Ups, data not found!",
                        style: TextStyle(fontSize: 20),
                      ),
                    );
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              );
            }
          }),
    );
  }
}
