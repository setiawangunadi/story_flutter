import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:story_app/blocs/add_story/add_story_bloc.dart';
import 'package:story_app/shared/widget/custom_toast.dart';

class AddStoryScreen extends StatefulWidget {
  final Function(bool, String?, String?) onTappedLocation;
  final Function(LatLng, geo.Placemark?) onSaveLocation;
  final LatLng? locationSelected;
  final String? street;
  final String? path;
  final String? desc;

  const AddStoryScreen({
    super.key,
    required this.onTappedLocation,
    this.locationSelected,
    this.street,
    this.path,
    this.desc,
    required this.onSaveLocation,
  });

  @override
  State<AddStoryScreen> createState() => _AddStoryScreenState();
}

class _AddStoryScreenState extends State<AddStoryScreen> {
  late GoogleMapController mapController;

  geo.Placemark? placemark;

  LatLng location = const LatLng(-6.8957473, 107.6337669);
  final Set<Marker> markers = {};

  MapType selectedMapType = MapType.normal;
  final TextEditingController ctrlDesc = TextEditingController();
  final TextEditingController ctrlLocation = TextEditingController();
  final dicodingOffice = const LatLng(-6.8957473, 107.6337669);

  late AddStoryBloc addStoryBloc;
  XFile? file;
  String? imagePath;

  @override
  void initState() {
    addStoryBloc = BlocProvider.of<AddStoryBloc>(context);
    addStoryBloc.add(DoInitialData(widget.path, widget.desc));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddStoryBloc, AddStoryState>(
      listener: (context, state) {
        if (state is OnSuccessInitialData) {
          setState(() {
            imagePath = state.path;
            ctrlDesc.text = state.desc ?? "";
          });
        }
        if (state is OnSuccessAddStory) {
          setState(() {
            imagePath = null;
          });
          ctrlDesc.clear();
          ctrlLocation.clear();

          AppToast.show(context, state.data.message ?? "", Colors.green);
        }
        if (state is OnFailedAddStory) {
          AppToast.show(context, state.message, Colors.red);
        }
        if (state is GetFileImageGallery) {
          setState(() {
            file = state.value;
            imagePath = state.value.path;
          });
        }
        if (state is GetFileImageCamera) {
          setState(() {
            file = state.value;
            imagePath = state.value.path;
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("New Story"),
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                imagePath == null
                    ? Image.network(
                        "https://static.thenounproject.com/png/1077596-200.png",
                        width: 200,
                        height: 200,
                      )
                    : showImage(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => _onCameraView(),
                      child: const Text("Camera"),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () => _onGalleryView(),
                      child: const Text("Gallery"),
                    )
                  ],
                ),
                Card(
                  color: Colors.white,
                  margin: const EdgeInsets.all(16.0),
                  shape: const Border.fromBorderSide(
                    BorderSide(color: Colors.black),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: TextFormField(
                      controller: ctrlDesc,
                      maxLines: 8,
                      decoration: const InputDecoration.collapsed(
                        hintText: "Description",
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  // onTap: () =>
                  //     widget.onTappedLocation(true, imagePath, ctrlDesc.text),
                  onTap: () => showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8.0),
                            topLeft: Radius.circular(8.0),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        "Select Location",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(Icons.close),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
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
                                      final info =
                                          await geo.placemarkFromCoordinates(
                                              location.latitude,
                                              location.longitude);
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
                                          onPressed: () {
                                            Navigator.pop(context);
                                            ctrlLocation.text = placemark?.street ?? "";
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      controller: ctrlLocation,
                      decoration: const InputDecoration(
                        hintText: "Select Your Location",
                        fillColor: Colors.grey,
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        suffixIcon: Icon(
                          Icons.location_on_outlined,
                          color: Colors.black,
                        ),
                      ),
                      enabled: false,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => _onUpload(),
                    child: state is OnLoadingAddStory
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(color: Colors.white),
                              SizedBox(width: 16),
                              Text("Loading")
                            ],
                          )
                        : const Text("Upload"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _onUpload() async {
    final fileName = file?.name ?? "";
    final bytes = await file?.readAsBytes() ?? "";

    addStoryBloc.add(
      DoAddStory(
        description: ctrlDesc.text,
        bytes: bytes,
        filename: fileName,
        filePath: file?.path ?? "",
        lat: widget.locationSelected?.latitude,
        lon: widget.locationSelected?.longitude,
      ),
    );
  }

  _onGalleryView() async {
    final isMacOS = defaultTargetPlatform == TargetPlatform.macOS;
    final isLinux = defaultTargetPlatform == TargetPlatform.linux;
    if (isMacOS || isLinux) return;

    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile?.path != null) {
      addStoryBloc.add(SetImageFileGallery(value: pickedFile!));
    }

    if (pickedFile != null) {}
  }

  _onCameraView() async {
    final isAndroid = defaultTargetPlatform == TargetPlatform.android;
    final isIOS = defaultTargetPlatform == TargetPlatform.iOS;
    final isNotMobile = !(isAndroid || isIOS);
    if (isNotMobile) return;

    final ImagePicker picker = ImagePicker();

    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.camera);

    if (pickedFile?.path != null) {
      addStoryBloc.add(SetImageFileCamera(value: pickedFile!));
    }
  }

  Widget showImage() {
    return kIsWeb
        ? Image.network(
            imagePath.toString(),
            fit: BoxFit.contain,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 3,
          )
        : Image.file(
            File(imagePath.toString()),
            fit: BoxFit.contain,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 3,
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
    widget.onSaveLocation(location, placemark);

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
    widget.onSaveLocation(location, placemark);
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
