import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'src/locations.dart' as locations;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  //

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
// Creates an empty map for the markers
  final Map<String, Marker> _markers = {};

  Future<void> _onMapCreated(GoogleMapController controller) async {
    // Await getGoogleOffices async fromJson method in the locations library
    final googleOffices = await locations.getGoogleOffices();
    // Removes all entries from the map
    setState(() {
      _markers.clear();
      // For each office instance in the returned offices list object
      for (final office in googleOffices.offices) {
        // Creates a set of marker configurations
        final marker = Marker(
          // Sets marker id for each office name
          markerId: MarkerId(office.name),
          // Posititions the latitude and longitude for each office instance
          position: LatLng(office.lat, office.lng),
          // Displays an informaiton window with the office name and address
          infoWindow: InfoWindow(
            title: office.name,
            snippet: office.address,
          ),
        );
        // Empty map now becomes Marker() with office.name as optional param
        _markers[office.name] = marker;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Google Office Locations'),
          backgroundColor: Colors.black,
        ),
        // Creates a widget displaying data from Google Maps services
        body: GoogleMap(
          onMapCreated: _onMapCreated, // Retrieves the GoogleMapController
          initialCameraPosition: const CameraPosition(
            target: LatLng(0, 0),
            zoom: 2,
          ),
          markers: _markers.values.toSet(),
        ),
      ),
    );
  }
}
