import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../home.dart';

class AbsenScreen extends StatefulWidget {
  const AbsenScreen({super.key});

  @override
  State<AbsenScreen> createState() => _AbsenScreenState();
}

class _AbsenScreenState extends State<AbsenScreen> {
  final CollectionReference dataCollection =
      FirebaseFirestore.instance.collection('absen');
  final controllerName = TextEditingController();
  final toController = TextEditingController();
  final fromController = TextEditingController();
  String dropValueCategory = "Please Choose:";
  var categoriesList = <String>[
    "Please choose:",
    "Sick",
    "Permission",
    "Other"
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Request permission menu",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
          child: Card(
        color: Colors.white,
        margin: const EdgeInsets.fromLTRB(10, 10, 10, 30),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 5,
        child: Column(
          children: [
            Container(
              height: 50,
              decoration: const BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
              ),
              child: const Row(
                children: [
                  SizedBox(
                    width: 12,
                  ),
                  Icon(Icons.maps_home_work_outlined),
                  SizedBox(
                    width: 12,
                  ),
                  Text(
                    'please fill the form below',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
              child: TextField(
                controller: controllerName,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    labelText: 'Your name',
                    labelStyle:
                        const TextStyle(color: Colors.black, fontSize: 14),
                    hintText: 'Enter your name',
                    hintStyle:
                        const TextStyle(color: Colors.grey, fontSize: 14),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.blueAccent)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.blue))),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'Description',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blueAccent, width: 1.0)),
                child: DropdownButton(
                  dropdownColor: Colors.white,
                  value: dropValueCategory,
                  items: categoriesList.map((value) {
                    return DropdownMenuItem(
                        child: Text(
                      value.toString(),
                      style: const TextStyle(color: Colors.black, fontSize: 14),
                    ));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      dropValueCategory = value.toString();
                    });
                  },
                  icon: const Icon(Icons.arrow_drop_down_circle_outlined),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                  underline: Container(
                    color: Colors.transparent,
                    height: 2,
                  ),
                  isExpanded: true,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Row(
                children: [
                  Expanded(
                      child: Row(children: [
                    const Text(
                      'From:',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                    Expanded(
                        child: TextField(
                      onTap: () async {
                        DateTime? pickDate = await showDatePicker(
                            builder: (BuildContext context, Widget? child) {
                              return Theme(
                                  data: Theme.of(context).copyWith(
                                      colorScheme: const ColorScheme.light(
                                          onPrimary: Colors.white,
                                          onSurface: Colors.white,
                                          primary: Colors.blueAccent),
                                      datePickerTheme:
                                          const DatePickerThemeData(
                                              headerBackgroundColor:
                                                  Colors.blueAccent,
                                              backgroundColor: Colors.white)),
                                  child: child!);
                            },
                            context: context,
                            firstDate: DateTime(1900),
                            lastDate: DateTime(9999));
                        if (pickDate != null) {
                          fromController.text =
                              DateFormat('dd/mm/yyyy').format(pickDate);
                        }
                      },
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                      controller: fromController,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(8),
                          hintText: 'Starting From...',
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 16)),
                    ))
                  ])),
                  Expanded(
                      child: Row(
                    children: [
                      const Text(
                        "Until",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      Expanded(
                          child: TextField(
                        onTap: () async {
                          DateTime? pickDate = await showDatePicker(
                              builder: (BuildContext context, Widget? child) {
                                return Theme(
                                    data: Theme.of(context).copyWith(
                                        colorScheme: const ColorScheme.light(
                                            onPrimary: Colors.white,
                                            onSurface: Colors.white,
                                            primary: Colors.blueAccent),
                                        datePickerTheme:
                                            const DatePickerThemeData(
                                                headerBackgroundColor:
                                                    Colors.blueAccent,
                                                backgroundColor: Colors.white)),
                                    child: child!);
                              },
                              context: context,
                              firstDate: DateTime(1900),
                              lastDate: DateTime(9999));
                          if (pickDate != null) {
                            toController.text =
                                DateFormat('dd/mm/yyyy').format(pickDate);
                          }
                        },
                        style:
                            const TextStyle(color: Colors.black, fontSize: 16),
                        controller: toController,
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(8),
                            hintText: 'Ending From...',
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 16)),
                      ))
                    ],
                  ))
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(30),
              child: Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 50,
                  width: size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white),
                  child: Material(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.blueAccent,
                    child: InkWell(
                      splashColor: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        if (controllerName.text.isEmpty ||
                            dropValueCategory == 'Please Choose:' ||
                            fromController.text.isEmpty ||
                            toController.text.isEmpty) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                                  content: Row(
                                    children: [
                                      Icon(
                                        Icons.info_outline,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        "Please fill the form",
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ],
                                  ),
                                  backgroundColor: Colors.blueAccent,
                                  shape: StadiumBorder(),
                                  behavior: SnackBarBehavior.floating));
                        }else{
                          submitAbsen(controllerName.text.toString(), dropValueCategory, fromController.text, toController.text);
                        }
                      },
                      child: const Center(
                        child: Text("Make a request",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }

  Future<void> submitAbsen(
      String name, String reason, String from, String until) async {
    showLoaderDialog(context);
    dataCollection.add({
      'address':'-',
      'name': name,
      'reason': reason,
      'dateTime':'$from-$until'
    }).then((result) {
      Navigator.of(context).pop;
      try {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              Expanded(
                  child: Text("Data berhasil disimpan",
                      style: TextStyle(color: Colors.white))),
            ],
          ),
          backgroundColor: Colors.blueGrey,
          shape: StadiumBorder(),
          behavior: SnackBarBehavior.floating,
        ));
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline_rounded, color: Colors.white),
              Expanded(
                  child: Text("Ups! $e ",
                      style: const TextStyle(color: Colors.white))),
            ],
          ),
          backgroundColor: Colors.blueGrey,
          shape: const StadiumBorder(),
          behavior: SnackBarBehavior.floating,
        ));
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      }
    });
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.blueGrey),
          ),
          Container(
            margin: const EdgeInsets.only(left: 10),
            child: const Text("Loading the data..."),
          )
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
