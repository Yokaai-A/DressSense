import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dresssense/Screen/main_screen.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late List<CameraDescription> _cameras;
  CameraController? _controller;
  bool _isCameraReady = false;
  int _selectedCameraIndex = 0;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    _startCamera(_selectedCameraIndex);
  }

  Future<void> _startCamera(int cameraIndex) async {
    final camera = _cameras[cameraIndex];
    _controller = CameraController(camera, ResolutionPreset.medium);
    await _controller!.initialize();

    setState(() {
      _isCameraReady = true;
    });
  }

  void _toggleCamera() async {
    setState(() {
      _isCameraReady = false;
    });

    _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras.length;
    await _startCamera(_selectedCameraIndex);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isCameraReady
          ? Stack(
        children: [
          // Camera preview
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller!.value.previewSize!.height,
                height: _controller!.value.previewSize!.width,
                child: CameraPreview(_controller!),
              ),
            ),
          ),

          // Tombol ambil gambar tetap di atas
          Positioned(
            bottom: 30,
            left: MediaQuery.of(context).size.width / 2 - 30,
            child: GestureDetector(
              onTap: _takePictureAndPreview,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 2),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(Icons.camera_alt, color: Colors.black),
              ),
            ),
          ),

          // Tombol back
          Positioned(
            top: 40,
            left: 20,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Row(
                children: [
                  const Icon(Icons.arrow_back_ios_new_outlined,
                      color: Colors.white),
                  const SizedBox(width: 5),
                  Text(
                    'Back',
                    style: GoogleFonts.kalnia(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Tombol ganti kamera
          Positioned(
            bottom: 30,
            right: 30,
            child: GestureDetector(
              onTap: _toggleCamera,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 2),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(Icons.flip_camera_android,
                    color: Colors.black),
              ),
            ),
          ),
        ],
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Future<void> _takePictureAndPreview() async {
    if (!_controller!.value.isInitialized || _controller!.value.isTakingPicture) return;

    final directory = await getTemporaryDirectory();
    final path = p.join(directory.path, '${DateTime.now().millisecondsSinceEpoch}.png');

    try {
      final XFile file = await _controller!.takePicture();
      await file.saveTo(path);

      if (!mounted) return;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.file(File(path), fit: BoxFit.cover),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () {
                      Navigator.of(context).pop();
                      File(path).delete();
                    },
                    child: const Icon(Icons.close, color: Colors.white),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () async {
                      Navigator.of(context).pop(); // Tutup dialog preview

                      final color = await detectColor(File(path));

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainScreen(
                            initialIndex: 1,
                            newImagePath: path,
                            newImageColor: color, // Kirim warna ke wardrobe
                          ),
                        ),
                            (route) => false,
                      );
                    },
                    child: const Icon(Icons.check, color: Colors.white),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    } catch (e) {
      debugPrint('Error taking picture: $e');
    }
  }

  Future<String?> detectColor(File imageFile) async {
    final uri = Uri.parse('http://192.168.100.110:5050/detect-color');

    final request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

    try {
      debugPrint('📤 Sending image to color detector...');

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      debugPrint('📥 Received response: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint('🎨 Detected color: ${data['color']}');
        return data['color'];
      } else {
        debugPrint('❌ Failed to detect color. Status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('🚨 Error detecting color: $e');
    }

    return null;
  }

}
