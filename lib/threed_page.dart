import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
// import 'package:flutter_scene/scene.dart';
import 'dart:math' as math;

import 'package:permission_handler/permission_handler.dart';

class ThreedPage extends StatefulWidget {
  const ThreedPage({super.key});

  @override
  State<ThreedPage> createState() => _ThreedPageState();
}

class _ThreedPageState extends State<ThreedPage> {
  String? _modelPath;
  final char1controller = Flutter3DController();
  final char2controller = Flutter3DController();

  final List<double> char1CameraOrbit = [-80, 90, 180];
  final List<double> char2CameraOrbit = [80, 90, 180];

  void rotateChar1({int value = 45}) {
    char1CameraOrbit[0] = char1CameraOrbit[0] - value;
    char1controller.setCameraOrbit(
        char1CameraOrbit[0], char1CameraOrbit[1], char1CameraOrbit[2]);
  }

  void rotateChar2({int value = 45}) {
    char2CameraOrbit[0] = char2CameraOrbit[0] - value;
    char2controller.setCameraOrbit(
        char2CameraOrbit[0], char2CameraOrbit[1], char2CameraOrbit[2]);
  }

  Future<void> _pick3DModel() async {
    try {
      // Open file picker to select a 3D model file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['glb', 'gltf'], // Allow only .glb and .gltf files
      );

      if (result != null) {
        // Get the file path
        // String filePath = result.files.single.path!;
        //
        // // Copy the file to a temporary directory
        // final tempDir = await getTemporaryDirectory();
        // final tempFilePath = '${tempDir.path}/character1.glb';
        // await File(filePath).copy(tempFilePath);
        //
        // // Update the state with the new model path
        // setState(() {
        //   _modelPath = tempFilePath;
        // });

        final selectedFile = File(result.files.single.path!);
        final appDir = await getApplicationDocumentsDirectory();
        final newFilePath =
            path.join(appDir.path, path.basename(selectedFile.path));
        final newFile = await selectedFile.copy(newFilePath);

        setState(() {
          _modelPath = newFile.path;
        });
        print("Copied file path: $newFilePath");
        final fileExists = File(newFilePath).existsSync();
        print("File exists: $fileExists");
      } else {
        // User canceled the picker
        print("No file selected.");
      }
    } catch (e) {
      print("Error picking file: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
              left: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "3D Character Chat",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Flutter3DViewer(
                    src: _modelPath ?? "assets/male3d.glb",
                    enableTouch: false,
                    controller: char1controller,
                    onLoad: (node) {
                      char1controller.setCameraOrbit(char1CameraOrbit[0],
                          char1CameraOrbit[1], char1CameraOrbit[2]);
                    },
                  ), /*ModelViewer(
                    src: _modelPath ?? "/data/user/0/com.hng.flutter_3d/cache/character1.glb",
                  ),*/
                ),
                Expanded(
                  child: Flutter3DViewer(
                    src: "assets/female3d.glb",
                    enableTouch: false,
                    controller: char2controller,
                    onLoad: (node) {
                      char2controller.setCameraOrbit(char2CameraOrbit[0],
                          char2CameraOrbit[1], char2CameraOrbit[2]);
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            onPressed: () {
                              _pick3DModel();
                            },
                            child: const Text("Pick a character",
                                style: TextStyle(color: Colors.white)),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                  ),
                                  onPressed: () {
                                    rotateChar1();
                                  },
                                  icon: Icon(
                                    Icons.rotate_90_degrees_ccw_rounded,
                                    color: Colors.white,
                                  )),
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                ),
                                onPressed: () {
                                  char1controller.playAnimation(
                                      animationName: "Jump");
                                },
                                child: const Text("Jump",
                                    style: TextStyle(color: Colors.white)),
                              ),
                              IconButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                  ),
                                  onPressed: () {
                                    rotateChar1(value: -45);
                                  },
                                  icon: Icon(
                                    Icons.rotate_90_degrees_cw_outlined,
                                    color: Colors.white,
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            onPressed: () {},
                            child: const Text("Pick a character",
                                style: TextStyle(color: Colors.white)),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                  ),
                                  onPressed: () {
                                    rotateChar2();
                                  },
                                  icon: Icon(
                                    Icons.rotate_90_degrees_ccw_rounded,
                                    color: Colors.white,
                                  )),
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                ),
                                onPressed: () {
                                  char1controller.playAnimation(
                                      animationName: "Jump");
                                },
                                child: const Text("Jump",
                                    style: TextStyle(color: Colors.white)),
                              ),
                              IconButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                  ),
                                  onPressed: () {
                                    rotateChar2(value: -45);
                                  },
                                  icon: Icon(
                                    Icons.rotate_90_degrees_cw_outlined,
                                    color: Colors.white,
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
