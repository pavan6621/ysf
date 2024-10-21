import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart';
import 'package:ysf/const/constdata.dart';

class MapDirections extends StatefulWidget {
  final double latitude;
  final double longitude;

  const MapDirections({required this.latitude, required this.longitude});

  @override
  MapDirectionsState createState() => MapDirectionsState();
}

class MapDirectionsState extends State<MapDirections> {
  late GoogleMapController mapController;
  Set<Polyline> _polylines = {};
  LatLng? _currentLocation;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    Location location = Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      _getUserLocation();
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      _getUserLocation();
    }

    LocationData currentLocation = await location.getLocation();
    setState(() {
      _currentLocation = LatLng(currentLocation.latitude!, currentLocation.longitude!);
      _createRoute(_currentLocation!, LatLng(widget.latitude, widget.longitude));
    });
  }

  Future<void> _createRoute(LatLng origin, LatLng destination) async {
    List<PointLatLng> routePoints = await _getRouteCoordinates(origin, destination);
    _polylines.add(Polyline(
      polylineId: PolylineId('route'),
      points: routePoints.map((point) => LatLng(point.latitude, point.longitude)).toList(),
      color: Colors.blue,
      width: 5,
    ));

    setState(() {});
  }

  Future<List<PointLatLng>> _getRouteCoordinates(LatLng origin, LatLng destination) async {
    String apiKey = 'YOUR_GOOGLE_MAPS_API_KEY'; 
    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var points = data['routes'][0]['overview_polyline']['points'];
      return PolylinePoints().decodePolyline(points);
    } else {
      throw Exception('Failed to load directions');
    }
  }

  void _moveCameraToLocations(LatLng currentLocation, LatLng destinationLocation) {
   
    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(
        currentLocation.latitude < destinationLocation.latitude
            ? currentLocation.latitude
            : destinationLocation.latitude,
        currentLocation.longitude < destinationLocation.longitude
            ? currentLocation.longitude
            : destinationLocation.longitude,
      ),
      northeast: LatLng(
        currentLocation.latitude > destinationLocation.latitude
            ? currentLocation.latitude
            : destinationLocation.latitude,
        currentLocation.longitude > destinationLocation.longitude
            ? currentLocation.longitude
            : destinationLocation.longitude,
      ),
    );

    mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50)); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: myColor, title: Text('Route from Current Location')),
      body: _currentLocation == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentLocation!,
                zoom: 14,
              ),
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
                _moveCameraToLocations(_currentLocation!, LatLng(widget.latitude, widget.longitude));
              },
              markers: {
                Marker(
                  markerId: MarkerId('destination'),
                  position: LatLng(widget.latitude, widget.longitude),
                  infoWindow: InfoWindow(
                    title: 'Donor', 
                    snippet: 'Destination',
                  ),
                ),
              },
              polylines: _polylines,
              myLocationEnabled: true, 
            ),
    );
  }
}
