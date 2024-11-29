// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cse/style/appbar.dart';
import 'package:cse/style/background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Tracking extends StatefulWidget {
  const Tracking({super.key});

  @override
  State<Tracking> createState() => _TrackingState();
}

class _TrackingState extends State<Tracking> {
  Set<Marker> markers = {};
  GoogleMapController? mapController;
  Position? position;
  late Stream<List<DocumentSnapshot>> reportStream;
  late DocumentSnapshot<Object?> assignreport;
  @override
  void initState() {
    super.initState();
    _uploadData();
  }

  _uploadData() {
    reportStream = FirebaseFirestore.instance
        .collection('AssignReport')
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StyleAppBar(title: 'Tracking'),
      body: BackgroundColor(
        child: StreamBuilder<List<DocumentSnapshot>>(
          stream: reportStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Show a loading indicator while waiting for data
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              // Handle error state
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            // Check if the snapshot has data and if the required properties are not empty
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              final assignReport = snapshot.data![0];

              double latitude = assignReport['latitude'];
              double longitude = assignReport['longitude'];
              String name = assignReport['driverName'];

              return Center(
                child: SizedBox(
                  height: 550.h,
                  child: GoogleMap(
                    onMapCreated: (controller) {
                      setState(
                        () {
                          mapController = controller;
                          // Check if the latitude, longitude, and name are not empty
                          if (latitude != null &&
                              longitude != null &&
                              name != null &&
                              name.isNotEmpty) {
                            // Add marker only if the properties are not empty
                            markers.add(
                              Marker(
                                markerId: const MarkerId('location'),
                                position: LatLng(latitude, longitude),
                                infoWindow: InfoWindow(
                                  title: name,
                                  snippet: 'I\'m on the way',
                                ),
                              ),
                            );
                          }
                        },
                      );
                    },
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        latitude,
                        longitude,
                      ),
                      zoom: 17,
                    ),
                    markers: markers,
                  ),
                ),
              );
            } else {
              // If the snapshot doesn't have data or the required properties are empty, return an empty map
              return Column(
                children: [
                  Center(
                    child: SizedBox(
                      height: 400.h,
                      child: const GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(31.788938,
                              35.928986), // Set initial position to somewhere neutral
                          zoom: 10, // Set zoom level to see the whole world
                        ),
                        markers: {}, // No markers added
                      ),
                    ),
                  ),
                  AlertDialog(
                    title: const Text('Worng'),
                    content: const Text('There is no car to tracking'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
