import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class MapsPage extends StatefulWidget {
  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  late GoogleMapController mapController;
  double lat = 30.0444;
  double lng = 31.2357;
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
      setState(() {
        lat = position.latitude;
        lng = position.longitude;
      });
      // Update the camera position to the new location
      mapController.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(lat, lng),
          18,
        ),
      );

      // Update the marker's position
      setState(() {
        currentLocationMarker = Marker(
          markerId: MarkerId('currentLocation'),
          position: LatLng(lat, lng),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        );
      });

      print('Current Location: Lat $lat, Lng $lng');
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
        title: Text('Business Locations'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(lat, lng),
              zoom: 18,
            ),
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
            zoomControlsEnabled: false,
            // markers: {currentLocationMarker}, // Set the markers on the map
            onCameraMove: (CameraPosition newPosition) {
              // Update the lat and lng variables with the new location
              setState(() {
                lat = newPosition.target.latitude;
                lng = newPosition.target.longitude;
              });
            },
            onCameraMoveStarted: () {
              setState(() {
                isButtonLoading = true;
              });
            },
            onCameraIdle: () {
              setState(() {
                isButtonLoading = false;
              });
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
                      // Implement your logic to confirm the location
                      print('Location Confirmed: Lat $lat, Lng $lng');
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
