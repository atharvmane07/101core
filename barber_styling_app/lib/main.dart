import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;
  runApp(MyApp(camera: firstCamera));
}

class MyApp extends StatefulWidget {
  final CameraDescription camera;

  const MyApp({required this.camera});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  File? _image;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      final image = await _controller.takePicture();
      final savedImage = await saveImageToFile(image.path);
      setState(() {
        _image = savedImage;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<File?> pickImageFromGallery() async {
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      final savedImage = await saveImageToFile(pickedImage.path);
      return savedImage;
    }
    return null;
  }

  Future<File> saveImageToFile(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final newPath = '${directory.path}/$fileName.jpg';

    final rawImage = File(imagePath).readAsBytesSync();
    final image = img.decodeImage(rawImage)!;
    final savedImage = File(newPath)..writeAsBytesSync(img.encodeJpg(image));
    return savedImage;
  }

  Widget buildCameraPreview() {
    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: CameraPreview(_controller),
    );
  }

  Widget buildCapturedImage() {
    return Image.file(_image!);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Virtual Stylist'),
        ),
        body: Column(
          children: [
            Expanded(child: _image == null ? buildCameraPreview() : buildCapturedImage()),
            Container(
              color: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: _takePicture,
                    icon: Icon(Icons.camera_alt),
                    color: Colors.white,
                  ),
                  IconButton(
                    onPressed: () async {
                      final image = await pickImageFromGallery();
                      setState(() {
                        _image = image;
                      });
                    },
                    icon: Icon(Icons.photo_library),
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
