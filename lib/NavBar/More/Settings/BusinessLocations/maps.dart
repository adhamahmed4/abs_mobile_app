import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class MapsPage extends StatefulWidget {
  double? lat;
  double? lng;

  MapsPage({this.lat, this.lng});

  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  late GoogleMapController mapController;
  bool isButtonLoading = false;

  // Define a marker to represent the current location
  Marker currentLocationMarker = Marker(
    markerId: MarkerId('currentLocation'),
    position: LatLng(30.0444, 31.2357),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
  );

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      if (mounted) {
        setState(() {
          widget.lat = position.latitude;
          widget.lng = position.longitude;
        });
      }
      // Update the camera position to the new location
      mapController.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(widget.lat!, widget.lng!),
          18,
        ),
      );

      // Update the marker's position
      if (mounted) {
        setState(() {
          currentLocationMarker = Marker(
            markerId: MarkerId('currentLocation'),
            position: LatLng(widget.lat!, widget.lng!),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          );
        });
      }
    } catch (e) {
      print("Error getting current location: $e");
    }
  }

  Future<void> _checkLocationPermission() async {
    final status = await Permission.location.request();
    if (status == PermissionStatus.granted) {
      _getCurrentLocation();
    } else {
      print("Location permission denied.");
    }
  }

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Business Locations',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          shadowColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.black)),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(widget.lat!, widget.lng!),
              zoom: 18,
            ),
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
            zoomControlsEnabled: false,
            // markers: {currentLocationMarker}, // Set the markers on the map
            onCameraMove: (CameraPosition newPosition) {
              // Update the lat and lng variables with the new location
              if (mounted) {
                setState(() {
                  widget.lat = newPosition.target.latitude;
                  widget.lng = newPosition.target.longitude;
                });
              }
            },
            onCameraMoveStarted: () {
              if (mounted) {
                setState(() {
                  isButtonLoading = true;
                });
              }
            },
            onCameraIdle: () {
              if (mounted) {
                setState(() {
                  isButtonLoading = false;
                });
              }
            },
          ),
          Positioned(
            bottom: 85, // Adjust the top position as needed
            right: 16, // Adjust the right position as needed
            child: FloatingActionButton(
              onPressed: () {
                // Implement your logic to get the current location
                _getCurrentLocation();
              },
              child: Icon(Icons.location_searching),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: isButtonLoading
                  ? null // Disable the button when loading
                  : () {
                      Navigator.pop(context);
                    },
              child: isButtonLoading
                  ? SizedBox(
                      height: 20.0, // Adjust the height as needed
                      width: 20.0, // Adjust the width as needed
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0, // Adjust the strokeWidth as needed
                      ),
                    )
                  : Text('Confirm Location'),
            ),
          ),
          Center(
            child: GestureDetector(
              child: Icon(
                Icons.location_on, // You can use any icon you prefer
                size: 48.0, // Adjust the size as needed
                color: Colors.red, // Adjust the color as needed
              ),
            ),
          ),
        ],
      ),
    );
  }
}
