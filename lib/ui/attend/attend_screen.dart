import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import 'package:absensi/ui/attend/camera.dart';
import 'package:absensi/ui/home_screen.dart';

class AttendScreen extends StatefulWidget {
  final XFile? image;
  const AttendScreen({super.key, this.image});

  @override
  // ignore: no_logic_in_create_state
  State<AttendScreen> createState() => _AttendScreenState(this.image);
}

class _AttendScreenState extends State<AttendScreen> {
  _AttendScreenState(this.image);
  String strDate = "",
      strTime = "",
      strDateTime = "",
      strStatus = "Attend",
      strAddress = "";
  double dLat = 0, dLong = 0;
  int dateHours = 0, dateMinutes = 0;
  bool isLoading = false;
  XFile? image;
  final controllerName = TextEditingController();
  final CollectionReference dataCollection =
      FirebaseFirestore.instance.collection('attendance');

  @override
  void initState() {
    super.initState();
    handleLocationPermission();
    getGeoLocationPosition();
    setDateTime();
    setStatusAbsen();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Attendance Menu",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Card(
          color: Colors.white,
          margin: const EdgeInsets.fromLTRB(17, 15, 17, 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 50,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  color: Colors.black,
                ),
                child: const Row(
                  children: [
                    SizedBox(width: 12),
                    Icon(Icons.face_retouching_natural_outlined,
                        color: Colors.white),
                    SizedBox(width: 12),
                    Text(
                      "Please make a selfie photo!",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(10, 20, 0, 20),
                child: Text(
                  "Capture Photo",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CameraScreen()),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                  width: size.width,
                  height: 150,
                  child: DottedBorder(
                    radius: const Radius.circular(10),
                    borderType: BorderType.RRect,
                    color: Colors.black,
                    strokeWidth: 1,
                    dashPattern: const [5, 5],
                    child: SizedBox.expand(
                      child: FittedBox(
                        child: image != null
                            ? Image.file(File(image!.path), fit: BoxFit.cover)
                            : const Icon(
                                Icons.camera_enhance_outlined,
                                color: Colors.black,
                              ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.text,
                  controller: controllerName,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    labelText: "Your Name",
                    hintText: "Please enter your name",
                    hintStyle:
                        const TextStyle(fontSize: 14, color: Colors.grey),
                    labelStyle:
                        const TextStyle(fontSize: 14, color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Text(
                  "Your Location",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(10),
                      child: SizedBox(
                        height: 120,
                        child: TextField(
                          enabled: false,
                          maxLines: 5,
                          decoration: InputDecoration(
                            alignLabelWithHint: true,
                            disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.black)),
                            hintText: strAddress.isNotEmpty
                                ? strAddress
                                : 'Your Location',
                            hintStyle: const TextStyle(
                                fontSize: 14, color: Colors.grey),
                            fillColor: Colors.transparent,
                            filled: true,
                          ),
                        ),
                      ),
                    ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.all(30),
                child: Material(
                  elevation: 3,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: size.width,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: Material(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black,
                      child: InkWell(
                        splashColor: Colors.blue,
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          if (image == null || controllerName.text.isEmpty) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Row(
                                children: [
                                  Icon(Icons.abc_outlined, color: Colors.white),
                                  SizedBox(width: 10),
                                  Text(
                                    "Please complete the form",
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                              backgroundColor: Colors.blueGrey,
                              shape: StadiumBorder(),
                              behavior: SnackBarBehavior.floating,
                            ));
                          } else {
                            submitAbsen(strAddress,
                                controllerName.text.toString(), strStatus);
                          }
                        },
                        child: const Center(
                          child: Text(
                            "Report Now",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> handleLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.location_off,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Text(
              "Please enable location service",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: Colors.blueGrey,
        shape: StadiumBorder(),
        behavior: SnackBarBehavior.floating,
      ));
      return false;
    }


    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.location_off,
                color: Colors.white,
              ),
              SizedBox(width: 10),
              Text(
                "Location permissions are denied. Please enable location service",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          backgroundColor: Colors.blueGrey,
          shape: StadiumBorder(),
          behavior: SnackBarBehavior.floating,
        ));
        return false;
      }
    }


    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.location_off,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Text(
              "Location permissions are denied forever. We cannot access location service",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: Colors.blueGrey,
        shape: StadiumBorder(),
        behavior: SnackBarBehavior.floating,
      ));
      return false;
    }
    return true;
  }

  Future<void> getGeoLocationPosition() async {
    // ignore: deprecated_member_use
    Position position = await Geolocator.getCurrentPosition(
        // ignore: deprecated_member_use
        desiredAccuracy: LocationAccuracy.low);
    setState(() {
      isLoading = false;
      getAddressFromLongLat(position);
    });
  }

  Future<void> getAddressFromLongLat(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    setState(() {
      dLat = position.latitude;
      dLong = position.longitude;
      strAddress =
          '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    });
  }

  void setDateTime() async {
    var dateNow = DateTime.now();
    var dateFormat = DateFormat('dd MM yyyy');
    var dateTime = DateFormat('HH:mm:ss');
    var dateHour = DateFormat('HH');
    var dateMinute = DateFormat('mm');

    setState(() {
      strDate = dateFormat.format(dateNow);
      strTime = dateTime.format(dateNow);
      strDateTime = "$strDate | $strTime";

      dateHours = int.parse(dateHour.format(dateNow));
      dateMinutes = int.parse(dateMinute.format(dateNow));
    });
  }

  void setStatusAbsen() {
    if (dateHours < 8 || (dateHours == 8 && dateMinutes <= 30)) {
      strStatus = "Attend";
    } else if ((dateHours > 8 && dateHours < 18) ||
        (dateHours == 8 && dateMinutes >= 31)) {
      strStatus = "Late";
    } else {
      strStatus = "Absent";
    }
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
        content: Row(
      children: [
        const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey),
        ),
        Container(
          margin: const EdgeInsets.only(left: 10),
          child: const Text("Checking the Data..."),
        )
      ],
    ));
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  Future<void> submitAbsen(String address, String name, String status) async {
    showLoaderDialog(context);
    dataCollection.add({
      'address': address,
      'name': name,
      'status': status,
      'dateTime': strDateTime
    }).then((result) {
      setState(() {
        // Navigator.pop(context).pop();
        try {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: Colors.white,
                  ),
                  Text("Yeay! Your Attendance successfully record")
                ],
              ),
              backgroundColor: Colors.orangeAccent,
              shape: StadiumBorder(),
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: Colors.white,
                ),
                Expanded(
                    child: Text(
                  "Ups, $e",
                  style: const TextStyle(color: Colors.white),
                ))
              ],
            ),
            backgroundColor: Colors.orangeAccent,
            shape: StadiumBorder(),
            behavior: SnackBarBehavior.floating,
          ));
        }
      });
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.white,
            ),
            Expanded(
                child: Text(
              "Ups, $error",
              style: const TextStyle(color: Colors.white),
            ))
          ],
        ),
        backgroundColor: Colors.orangeAccent,
        shape: StadiumBorder(),
        behavior: SnackBarBehavior.floating,
      ));
      Navigator.of(context).pop();
    });
  }
}

//get realtime location
  // Future<void> getGeoLocationPosition() async {
  //   Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
  //   setState(() {
  //     isLoading = false;
  //     getAddressFromLongLat(position);
  //   });
  // }

  // //get address by lat long
  // Future<void> getAddressFromLongLat(Position position) async {
  //   List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
  //   print(placemarks);
  //   Placemark place = placemarks[0];
  //   setState(() {
  //     dLat = double.parse('${position.latitude}');
  //     dLat = double.parse('${position.longitude}');
  //     strAddress =
  //     "${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}";
  //   });
  // }

  // //permission location
  // Future<bool> handleLocationPermission() async {
  //   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //       content: Row(
  //         children: [
  //           Icon(
  //             Icons.location_off,
  //             color: Colors.white,
  //           ),
  //           SizedBox(width: 10),
  //           Text("Location services are disabled. Please enable the services.",
  //               style: TextStyle(color: Colors.white),
  //           )
  //         ],
  //       ),
  //       backgroundColor: Colors.redAccent,
  //       shape: StadiumBorder(),
  //       behavior: SnackBarBehavior.floating,
  //     ));
  //     return false;
  //   }

  //   LocationPermission permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         content: Row(
  //           children: [
  //             Icon(
  //               Icons.location_off,
  //               color: Colors.white,
  //             ),
  //             SizedBox(width: 10),
  //             Text("Location permission denied.",
  //                 style: TextStyle(color: Colors.white),
  //             )
  //           ],
  //         ),
  //         backgroundColor: Colors.redAccent,
  //         shape: StadiumBorder(),
  //         behavior: SnackBarBehavior.floating,
  //       ));
  //       return false;
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //       content: Row(
  //         children: [
  //           Icon(
  //             Icons.location_off,
  //             color: Colors.white,
  //           ),
  //           SizedBox(width: 10),
  //           Text("Location permission denied forever, we cannot access.",
  //               style: TextStyle(color: Colors.white),
  //           )
  //         ],
  //       ),
  //       backgroundColor: Colors.redAccent,
  //       shape: StadiumBorder(),
  //       behavior: SnackBarBehavior.floating,
  //     ));
  //     return false;
  //   }
  //   return true;
  // }

  // //show progress dialog
  // showLoaderDialog(BuildContext context) {
  //   AlertDialog alert = AlertDialog(
  //     content: Row(
  //       children: [
  //         const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.pinkAccent)),
  //         Container(
  //             margin: const EdgeInsets.only(left: 20),
  //             child: const Text("sedang memeriksa data..."),
  //         ),
  //       ],
  //     ),
  //   );
  //   showDialog(
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (BuildContext context) {
  //       return alert;
  //     },
  //   );
  // }

  // //check format date time
  // void setDateTime() async {
  //   var dateNow = DateTime.now();
  //   var dateFormat = DateFormat('dd MMMM yyyy');
  //   var dateTime = DateFormat('HH:mm:ss');
  //   var dateHour = DateFormat('HH');
  //   var dateMinute = DateFormat('mm');

  //   setState(() {
  //     strDate = dateFormat.format(dateNow);
  //     strTime = dateTime.format(dateNow);
  //     strDateTime = "$strDate | $strTime";

  //     dateHours = int.parse(dateHour.format(dateNow));
  //     dateMinutes = int.parse(dateMinute.format(dateNow));
  //   });
  // }

  // //check status absent
  // void setStatusAbsen() {
  //   if (dateHours < 8 || (dateHours == 8 && dateMinutes <= 30)) {
  //     strStatus = "Absen Masuk";
  //   }
  //   else if ((dateHours > 8 && dateHours < 18) || (dateHours == 8 && dateMinutes >= 31)) {
  //     strStatus = "Absen Telat";
  //   }
  //   else {
  //     strStatus = "Absen Keluar";
  //   }
  // }

  // //submit data absent to firebase
  // Future<void> submitAbsen(String address, String name, String status) async {
  //     showLoaderDialog(context);
  //     dataCollection.add({'address': address, 'name': name,
  //       'status': status, 'datetime': strDateTime}).then((result) {
  //       setState(() {
  //         Navigator.of(context).pop();
  //         try {
  //           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //             content: Row(
  //               children: [
  //                 Icon(
  //                   Icons.check_circle_outline,
  //                   color: Colors.white,
  //                 ),
  //                 SizedBox(width: 10),
  //                 Text("Yeay! Absen berhasil!", style: TextStyle(color: Colors.white))
  //               ],
  //             ),
  //             backgroundColor: Colors.green,
  //             shape: StadiumBorder(),
  //             behavior: SnackBarBehavior.floating,
  //           ));
  //           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
  //         }
  //         catch (e) {
  //           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //             content: Row(
  //               children: [
  //                 const Icon(
  //                   Icons.info_outline,
  //                   color: Colors.white,
  //                 ),
  //                 const SizedBox(width: 10),
  //                 Expanded(
  //                   child: Text("Ups, $e", style: const TextStyle(color: Colors.white)),
  //                 ),
  //               ],
  //             ),
  //             backgroundColor: Colors.redAccent,
  //             shape: const StadiumBorder(),
  //             behavior: SnackBarBehavior.floating,
  //           ));
  //         }
  //       });
  //     }).catchError((error) {
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         content: Row(
  //           children: [
  //             const Icon(
  //               Icons.error_outline,
  //               color: Colors.white,
  //             ),
  //             const SizedBox(width: 10),
  //             Expanded(
  //                 child: Text("Ups, $error", style: const TextStyle(color: Colors.white))
  //             )
  //           ],
  //         ),
  //         backgroundColor: Colors.redAccent,
  //         shape: const StadiumBorder(),
  //         behavior: SnackBarBehavior.floating,
  //       ));
  //       Navigator.of(context).pop();
  //     });
  // }
