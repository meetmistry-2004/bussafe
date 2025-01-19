import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Location _locationController = Location();
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();
  static const LatLng _pGooglePlex = LatLng(37.4223, -122.0848);
  static const LatLng _pApplePark = LatLng(37.3346, -122.0090);
  LatLng? _currentP;

  @override
  void initState() {
    super.initState();
    getLocationUpdates();
  }

  @override
  void dispose() {
    _locationController.onLocationChanged
        .drain(); // Properly stop location stream.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Map"),
      ),
      body: _currentP == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                _mapController.complete(controller);
              },
              initialCameraPosition:
                  const CameraPosition(target: _pGooglePlex, zoom: 13),
              markers: {
                Marker(
                  markerId: const MarkerId("_currentLocation"),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueAzure),
                  position: _currentP!,
                ),
                Marker(
                  markerId: const MarkerId("_sourceLocation"),
                  icon: BitmapDescriptor.defaultMarker,
                  position: _pGooglePlex,
                ),
                Marker(
                  markerId: const MarkerId("_destinationLocation"),
                  icon: BitmapDescriptor.defaultMarker,
                  position: _pApplePark,
                ),
              },
            ),
    );
  }

  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition _newCameraPosition = CameraPosition(
      target: pos,
      zoom: 15,
    );
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(_newCameraPosition),
    );
  }

  Future<void> getLocationUpdates() async {
    try {
      // Check if location service is enabled
      bool _serviceEnabled = await _locationController.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await _locationController.requestService();
        if (!_serviceEnabled) {
          print("Location service not enabled.");
          return; // Return if service isn't enabled
        }
      }

      // Check for permission to access location
      PermissionStatus _permissionGranted =
          await _locationController.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await _locationController.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          print("Location permission denied.");
          return; // Return if permission isn't granted
        }
      }

      // Listen for location changes
      _locationController.onLocationChanged
          .listen((LocationData currentLocation) {
        if (currentLocation.latitude != null &&
            currentLocation.longitude != null) {
          setState(() {
            _currentP =
                LatLng(currentLocation.latitude!, currentLocation.longitude!);
          });
          _cameraToPosition(_currentP!); // Move camera to the current location
        }
      });
    } catch (e) {
      // Handle any errors during location updates
      print("Error getting location updates: $e");
    }
  }
}
