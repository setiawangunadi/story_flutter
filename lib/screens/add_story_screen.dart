import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:story_app/blocs/add_story/add_story_bloc.dart';
import 'package:story_app/shared/widget/custom_toast.dart';

class AddStoryScreen extends StatefulWidget {
  final Function(bool, String?, String?) onTappedLocation;
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
  });

  @override
  State<AddStoryScreen> createState() => _AddStoryScreenState();
}

class _AddStoryScreenState extends State<AddStoryScreen> {
  final TextEditingController ctrlDesc = TextEditingController();
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
          debugPrint("INITIAL STATE ACTION");
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
                  onTap: () =>
                      widget.onTappedLocation(true, imagePath, ctrlDesc.text),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      initialValue: widget.street ?? "",
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
        lat: widget.locationSelected?.latitude ?? 0.0,
        lon: widget.locationSelected?.longitude ?? 0.0,
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
}
