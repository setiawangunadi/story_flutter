import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:story_app/config/routers/page_manager.dart';

class MapsScreen extends StatefulWidget {
  final Function(bool, LatLng, String) onSavedLocation;

  const MapsScreen({super.key, required this.onSavedLocation});

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  late GoogleMapController mapController;

  final dicodingOffice = const LatLng(-6.8957473, 107.6337669);

  geo.Placemark? placemark;

  LatLng location = const LatLng(-6.8957473, 107.6337669);
  final Set<Marker> markers = {};

  MapType selectedMapType = MapType.normal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(8.0),
            topLeft: Radius.circular(8.0),
          ),
        ),
        child: Stack(
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
                    // onPressed: () => widget.onSavedLocation(
                    //     false, location, placemark?.street ?? ""),
                    onPressed: () {
                      widget.onSavedLocation(
                          false, location, placemark?.street ?? "");
                      context.read<PageManager>().returnData(
                        [
                          placemark?.street ?? "",
                          location,
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onMyLocationButtonPress() async {
    final Location locations = Location();
    late bool serviceEnabled;
    late PermissionStatus permissionGranted;
    late LocationData locationData;

    serviceEnabled = await locations.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await locations.requestService();
      if (!serviceEnabled) {
        print("Location services is not available");
        return;
      }
    }
    permissionGranted = await locations.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await locations.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        print("Location permission is denied");
        return;
      }
    }

    locationData = await locations.getLocation();
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
    // widget.onSaveLocation(location, placemark);
    // ctrlLocation.text = street ?? "";
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
