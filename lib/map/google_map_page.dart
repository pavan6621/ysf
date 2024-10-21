import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:ysf/const/constdata.dart';

class GoogleMapPage extends StatefulWidget {
  @override
  _GoogleMapPageState createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  GoogleMapController? mapController;
  LatLng? _selectedLocation;
  Location _location = Location();
  bool _serviceEnabled = false;
  PermissionStatus? _permissionGranted;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    // If permissions are granted, get the current location
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    try {
      var currentLocation = await _location.getLocation();
      mapController?.animateCamera(CameraUpdate.newLatLngZoom(
        LatLng(currentLocation.latitude!, currentLocation.longitude!), 14.0));
    } catch (e) {
      print('Could not get location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: myColor, title: Text('Select Location')),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(17.385044, 78.486671), // Default position (Hyderabad)
          zoom: 12.0,
        ),
        onTap: (LatLng latLng) {
          setState(() {
            _selectedLocation = latLng;
          });
        },
        myLocationEnabled: true, 
        myLocationButtonEnabled: true, 
        markers: _selectedLocation != null
            ? {
                Marker(
                  markerId: MarkerId('selected-location'),
                  position: _selectedLocation!,
                  infoWindow: InfoWindow(title: 'Selected Location'),
                ),
              }
            : {},
      ),
      floatingActionButton: _selectedLocation != null
          ? FloatingActionButton(
              onPressed: () {
                Navigator.pop(context, _selectedLocation);
              },
              child: Icon(Icons.check),
            )
          : null,
    );
  }
}
