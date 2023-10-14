import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class MapPage extends StatefulWidget {
  final double destinationLat;
  final double destinationLng;

  MapPage({required this.destinationLat, required this.destinationLng});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  PolylinePoints polylinePoints = PolylinePoints();
  Set<Polyline> polylines = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Directions'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(0.0, 0.0),
          zoom: 15,
        ),
        onMapCreated: (controller) {
          mapController = controller;
          getDirections();
        },
        markers: {
          Marker(
            markerId: MarkerId("destination"),
            position: LatLng(widget.destinationLat, widget.destinationLng),
          ),
        },
        polylines: polylines,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }

  void getDirections() async {
    LatLng currentLocation = LatLng(0.0, 0.0);

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyDRocukxzwoWdBHQFJy9rNqGBMCHI80-m0',
      PointLatLng(currentLocation.latitude, currentLocation.longitude),
      PointLatLng(widget.destinationLat, widget.destinationLng),
    );

    if (result.status == 'OK') {
      List<PointLatLng> routePoints = result.points;

      List<LatLng> convertedRoutePoints = routePoints
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();

      Polyline polyline = Polyline(
        polylineId: PolylineId("poly"),
        color: Colors.blue,
        points: convertedRoutePoints,
        width: 3,
      );

      setState(() {
        polylines.add(polyline);
      });

      mapController.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(convertedRoutePoints.first.latitude,
                convertedRoutePoints.first.longitude),
            northeast: LatLng(convertedRoutePoints.last.latitude,
                convertedRoutePoints.last.longitude),
          ),
          50.0,
        ),
      );
    } else {
      print('Failed to get directions: ${result.errorMessage}');
    }
  }
}
