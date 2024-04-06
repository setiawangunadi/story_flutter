import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:story_app/blocs/detail_story/detail_story_bloc.dart';
import 'package:story_app/config/models/detail_story.dart';

class DetailStoryScreen extends StatefulWidget {
  final String id;

  const DetailStoryScreen({super.key, required this.id});

  @override
  State<DetailStoryScreen> createState() => _DetailStoryScreenState();
}

class _DetailStoryScreenState extends State<DetailStoryScreen> {
  late DetailStoryBloc detailStoryBloc;
  late GoogleMapController mapController;

  DetailStory? detailStory;

  geo.Placemark? placemark;

  final dicodingOffice = const LatLng(-6.8957473, 107.6337669);
  final Set<Marker> markers = {};

  MapType selectedMapType = MapType.normal;

  @override
  void initState() {
    detailStoryBloc = BlocProvider.of<DetailStoryBloc>(context);
    detailStoryBloc.add(GetDetailStory(id: widget.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DetailStoryBloc, DetailStoryState>(
      listener: (context, state) async {
        if (state is OnSuccessDetailStory) {
          debugPrint("THIS RESPONSE: ${state.data.story?.toJson()}");
          setState(() {
            detailStory = state.data;
          });
          if (state.data.story?.lat != null && state.data.story?.lon != null) {
            final info = await geo.placemarkFromCoordinates(
              state.data.story?.lat ?? 0,
              state.data.story?.lon ?? 0,
            );

            final place = info[0];
            final street = place.street;
            final address =
                '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
            setState(() {
              placemark = place;
            });
            final marker = Marker(
              markerId: MarkerId(place.street ?? ""),
              position: LatLng(
                state.data.story?.lat ?? 0,
                state.data.story?.lon ?? 0,
              ),
              infoWindow: InfoWindow(
                title: street,
                snippet: address,
              ),
              onTap: () {
                mapController.animateCamera(
                  CameraUpdate.newLatLngZoom(
                    LatLng(
                      state.data.story?.lat ?? 0,
                      state.data.story?.lon ?? 0,
                    ),
                    18,
                  ),
                );
              },
            );
            markers.add(marker);
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Detail Story"),
          ),
          body: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: ClipRect(
                          child: Image.network(
                            detailStory?.story?.photoUrl ?? "",
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.image_not_supported_outlined,
                                size: 64,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            detailStory?.story?.name ?? "",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 18),
                          ),
                          Text(
                            detailStory?.story?.description ?? "",
                          ),
                        ],
                      ),
                    ),
                    if (detailStory?.story?.lat != null &&
                        detailStory?.story?.lon != null)
                      Stack(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: GoogleMap(
                              mapType: selectedMapType,
                              markers: markers,
                              myLocationEnabled: true,
                              myLocationButtonEnabled: false,
                              zoomControlsEnabled: false,
                              mapToolbarEnabled: false,
                              initialCameraPosition: CameraPosition(
                                target: LatLng(
                                  detailStory?.story?.lat ?? 0,
                                  detailStory?.story?.lon ?? 0,
                                ),
                                zoom: 18,
                              ),
                              onMapCreated: (controller) {
                                setState(() {
                                  mapController = controller;
                                });
                              },
                            ),
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
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
