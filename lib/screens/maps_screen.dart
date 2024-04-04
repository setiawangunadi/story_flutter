import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapsScreen extends StatefulWidget {
  final String? imagePath;
  final String? description;
  final Function(bool, LatLng, geo.Placemark?, String?, String?) onSaveLocation;

  const MapsScreen({
    super.key,
    required this.onSaveLocation,
    this.imagePath,
    this.description,
  });

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  late GoogleMapController mapController;

  geo.Placemark? placemark;

  LatLng location = const LatLng(-6.8957473, 107.6337669);
  final Set<Marker> markers = {};

  MapType selectedMapType = MapType.normal;

  @override
  void initState() {
    final marker = Marker(
      markerId: const MarkerId("dicoding"),
      position: location,
      onTap: () {
        mapController.animateCamera(
          CameraUpdate.newLatLngZoom(location, 18),
        );
      },
    );
    markers.add(marker);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Location"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              zoom: 18,
              target: location,
            ),
            markers: markers,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            onMapCreated: (controller) async {
              final info = await geo.placemarkFromCoordinates(
                  location.latitude, location.longitude);
              final place = info[0];
              final street = place.street!;
              final address =
                  '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
              setState(() {
                placemark = place;
              });
              defineMarker(location, street, address);
              setState(() {
                mapController = controller;
              });
            },
            onLongPress: (LatLng latLng) {
              onLongPressGoogleMap(latLng);
            },
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: Column(
              children: [
                FloatingActionButton.small(
                  heroTag: "zoom-in",
                  onPressed: () {
                    mapController.animateCamera(
                      CameraUpdate.zoomIn(),
                    );
                  },
                  child: const Icon(Icons.add),
                ),
                FloatingActionButton.small(
                  heroTag: "zoom-out",
                  onPressed: () {
                    mapController.animateCamera(
                      CameraUpdate.zoomOut(),
                    );
                  },
                  child: const Icon(Icons.remove),
                ),
              ],
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: Column(
              children: [
                FloatingActionButton(
                  child: const Icon(Icons.my_location),
                  onPressed: () {
                    onMyLocationButtonPress();
                  },
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  tooltip: "Save Location",
                  child: const Icon(
                    Icons.save,
                    size: 32,
                  ),
                  onPressed: () => widget.onSaveLocation(
                    false,
                    location,
                    placemark,
                    widget.imagePath,
                    widget.description,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void onMyLocationButtonPress() async {
    final Location location = Location();
    late bool serviceEnabled;
    late PermissionStatus permissionGranted;
    late LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        print("Location services is not available");
        return;
      }
    }
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        print("Location permission is denied");
        return;
      }
    }

    locationData = await location.getLocation();
    final latLng = LatLng(locationData.latitude!, locationData.longitude!);

    final info =
        await geo.placemarkFromCoordinates(latLng.latitude, latLng.longitude);

    final place = info[0];
    final street = place.street;
    final address =
        '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    setState(() {
      placemark = place;
    });

    defineMarker(latLng, street ?? "", address);

    mapController.animateCamera(
      CameraUpdate.newLatLng(latLng),
    );
  }

  void onLongPressGoogleMap(LatLng latLng) async {
    final info =
        await geo.placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    final place = info[0];
    final street = place.street;
    final address =
        '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    setState(() {
      placemark = place;
      location = latLng;
    });
    defineMarker(latLng, street ?? "", address);

    mapController.animateCamera(
      CameraUpdate.newLatLng(latLng),
    );
  }

  void defineMarker(LatLng latLng, String street, String address) {
    final marker = Marker(
      markerId: const MarkerId("source"),
      position: latLng,
      infoWindow: InfoWindow(
        title: street,
        snippet: address,
      ),
    );
    setState(() {
      markers.clear();
      markers.add(marker);
    });
  }
}
