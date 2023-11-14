import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:story_app/blocs/add_story/add_story_bloc.dart';

class AddStoryScreen extends StatefulWidget {

  const AddStoryScreen({super.key});

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddStoryBloc, AddStoryState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("New Story"),
            // leading: const Icon(Icons.arrow_back),
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(children: [
              imagePath == null
                  ? Image.network(
                      "https://bpsdm.dephub.go.id/v2/public/file_app/struktur_image/default.png",
                      width: 200,
                      height: 200,
                    )
                  : showImage(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () => _onCameraView(),
                      child: const Text("Camera")),
                  const SizedBox(width: 16),
                  ElevatedButton(
                      onPressed: () => _onGalleryView(),
                      child: const Text("Gallery"))
                ],
              ),
              Card(
                  color: Colors.white,
                  margin: const EdgeInsets.all(16.0),
                  shape: const Border.fromBorderSide(
                      BorderSide(color: Colors.black)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: TextFormField(
                      controller: ctrlDesc,
                      maxLines: 8, //or null
                      decoration: const InputDecoration.collapsed(
                          hintText: "Description"),
                    ),
                  )),
              Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton(
                      onPressed: () => _onUpload(),
                      child: const Text("Upload")))
            ]),
          ),
        );
      },
    );
  }

  _onUpload() async {
    final fileName = file?.name ?? "";
    final bytes = await file?.readAsBytes() ?? "";

    // addStoryBloc.add(
    //   AddStory(
    //     description: ctrlDesc.text,
    //     bytes: bytes,
    //     filename: fileName,
    //     filePath: file?.path ?? "",
    //   ),
    // );
  }

  _onGalleryView() async {
    final isMacOS = defaultTargetPlatform == TargetPlatform.macOS;
    final isLinux = defaultTargetPlatform == TargetPlatform.linux;
    if (isMacOS || isLinux) return;

    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile?.path != null) {
      File file = File(pickedFile?.path ?? "");
      // addStoryBloc.add(SetImageFileGallery(value: pickedFile!));
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
      File file = File(pickedFile?.path ?? "");
      // addStoryBloc.add(SetImageFileCamera(value: pickedFile!));
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
