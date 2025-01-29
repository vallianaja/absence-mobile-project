import 'dart:io';
import 'dart:math';

import 'package:absensi/ui/attend/camera.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import '../home.dart';

class AttendScreen extends StatefulWidget {
  final XFile? image;

  const AttendScreen({super.key, this.image});

  @override
  State<AttendScreen> createState() => _AttendScreenState(this.image);
}

class _AttendScreenState extends State<AttendScreen> {
  String strDate = "",
      strTime = "",
      strDateTime = "",
      strStatus = "Attend",
      strAddress = "";
  int dateHours = 0, dateMinutes = 0;
  double dLat = 0, dLong = 0;
  bool isLoading = false;
  XFile? image;
  final controllerName = TextEditingController();
  final CollectionReference dataCollection = FirebaseFirestore.instance.collection('attendance');

  _AttendScreenState(XFile? image);

  @override
  void initState() {
    handleLocationPermission();
    setDateTime();
    setStatusAbsen();
    super.initState();
  }

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
          "Attendance Menu",
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 50,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  color: Colors.blueAccent,
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
                    color: Colors.blueAccent,
                    strokeWidth: 1,
                    dashPattern: const [5, 5],
                    child: SizedBox.expand(
                      child: FittedBox(
                        child: image != null
                            ? Image.file(
                                File(image!.path),
                                fit: BoxFit.cover,
                              )
                            : const Icon(
                                Icons.camera_enhance_outlined,
                                color: Colors.blueAccent,
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
                  controller: controllerName,
                  keyboardType: TextInputType.text,
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
                      borderSide: const BorderSide(color: Colors.blueAccent),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.blueAccent),
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
              Padding(
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
                        borderSide: const BorderSide(color: Colors.blueAccent),
                      ),
                      hintText: 'Your Location',
                      hintStyle:
                          const TextStyle(fontSize: 14, color: Colors.grey),
                      fillColor: Colors.transparent,
                      filled: true,
                    ),
                  ),
                ),
              ),
              isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                      color: Colors.blueAccent,
                    ))
                  : Padding(
                      padding: const EdgeInsets.all(10),
                      child: SizedBox(
                        height: 120,
                        child: TextField(
                          enabled: false,
                          maxLines: 3,
                          decoration: InputDecoration(
                            alignLabelWithHint: true,
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: Colors.blueAccent),
                            ),
                            hintText: strAddress.isEmpty
                                ? strAddress
                                : 'Your Location',
                            hintStyle:
                                TextStyle(fontSize: 14, color: Colors.grey),
                            fillColor: Colors.transparent,
                            filled: true,
                          ),
                        ),
                      )),
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
                      color: Colors.blueAccent,
                      child: InkWell(
                        splashColor: Colors.blue,
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          if (image == null||controllerName.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Row(
                                  children: [
                                    Icon(Icons.abc_outlined, color: Colors.white),
                                    Expanded(child: Text("Please Complete the form", style: TextStyle(color: Colors.white))),
                                  ],
                                ),
                                  backgroundColor: Colors.blueGrey,
                                  shape: StadiumBorder(),
                                  behavior: SnackBarBehavior.floating,
                                ));

                          }else {
                            submitAddress(strAddress, controllerName.text.toString(), strStatus);
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.location_off, color: Colors.white),
              SizedBox(
                width: 10,
              ),
              Text(
                'please enable location service',
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
          backgroundColor: Colors.blueGrey,
          shape: StadiumBorder(),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.location_off, color: Colors.white),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'location permission are denied, please enable location service',
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
            backgroundColor: Colors.blueGrey,
            shape: StadiumBorder(),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.location_off, color: Colors.white),
              SizedBox(
                width: 10,
              ),
              Text(
                'location permission are denied forever, We cannot access your location',
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
          backgroundColor: Colors.blueGrey,
          shape: StadiumBorder(),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    return true;
  }

  Future<void> getGeoLocationPosition() async {
    // ignore:deprecated_member_use
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      isLoading = false;
      getAddressFormLonglat(position);
    });
  }

  Future<void> getAddressFormLonglat(Position position) async {
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
    var dateFormat = DateFormat('dd-mm-yyyy');
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
    } else if ((dateHours > 8 && dateMinutes <= 18) ||
        (dateHours > 8 && dateMinutes >= 31)) {
      strStatus = "Late";
    } else {
      strStatus = "Absent";
    }
    ;
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

  Future<void> submitAddress(String address, String name, String status) async {
    showLoaderDialog(context);
    dataCollection.add({
      'address': address,
      'name': name,
      'status': status,
      'dateTime': strDateTime
    }).then((result) {
      setState(() {
        Navigator.of(context).pop();
        try {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                Text(
                  'Your attendance has been recorded',
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
            backgroundColor: Colors.orangeAccent,
            shape: StadiumBorder(),
            behavior: SnackBarBehavior.floating,
          ));
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomeScreen()));
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar( SnackBar(
              content: Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.white),
              Expanded(child: Text("Ups, $e", style: const TextStyle(color: Colors.white))),
            ],
          ),
            backgroundColor: Colors.orangeAccent,
            shape: const StadiumBorder(),
            behavior: SnackBarBehavior.floating,
          )
          );
        }
      });
    }).catchError((error){
      ScaffoldMessenger.of(context).showSnackBar( const SnackBar(
        content: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.white),
            Expanded(child: Text("Ups, $e", style: TextStyle(color: Colors.white))),
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
