import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:path/path.dart' as p;

class WardrobeScreen extends StatefulWidget {
  final String? imagePath;
  final String? imageColor;

  const WardrobeScreen({super.key, this.imagePath, this.imageColor});

  @override
  State<WardrobeScreen> createState() => _WardrobeScreenState();
}

class _WardrobeScreenState extends State<WardrobeScreen> {
  String selectedCategory = "All";
  List<String> wardrobeImages = [];
  Map<String, String> imageColorMap = {};
  bool _isLoading = true;

  final List<String> categories = const [
    "All", "Tops", "Bottoms", "Outerwear", "Shoes"
  ];

  final Map<String, List<String>> categoryClothes = {
    "All": [],
    "Tops": [],
    "Bottoms": [],
    "Outerwear": [],
    "Shoes": [],
  };

  @override
  void initState() {
    super.initState();
    print("Menyimpan warna untuk: ${widget.imagePath}");
    print("Warna: ${widget.imageColor}");

    if (widget.imagePath != null && widget.imageColor != null) {
      final filename = p.basename(widget.imagePath!);
      imageColorMap[filename] = widget.imageColor!;
      print("Simpan warna ${widget.imageColor} untuk $filename");
    }

    _loadImages();
  }

  Future<void> _loadImages() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final wardrobeDir = Directory('${directory.path}/wardrobe');

      if (!await wardrobeDir.exists()) {
        await wardrobeDir.create();
      }

      final files = await wardrobeDir.list().toList();
      final savedImages = files
          .where((file) => file.path.endsWith('.png') || file.path.endsWith('.jpg'))
          .map((file) => file.path)
          .toList();

      final prefs = await SharedPreferences.getInstance();
      final stored = prefs.getString('imageColorMap');
      if (stored != null) {
        imageColorMap = Map<String, String>.from(jsonDecode(stored));
        print("📂 Loaded imageColorMap: $imageColorMap");
      }

      if (widget.imagePath != null) {
        final newPath = '${wardrobeDir.path}/${p.basename(widget.imagePath!)}';
        final newFile = File(newPath);

        if (!savedImages.contains(newPath)) {
          savedImages.add(newPath);
        }

        if (!await newFile.exists()) {
          await File(widget.imagePath!).copy(newPath);
          print("Gambar disalin ke: $newPath");
        }

        final filename = p.basename(newPath);
        if (widget.imageColor != null) {
          imageColorMap[filename] = widget.imageColor!;
          await prefs.setString('imageColorMap', jsonEncode(imageColorMap));
          print("Simpan warna ${widget.imageColor} untuk $filename");
        }
      }

      if (widget.imagePath != null && widget.imageColor != null) {
        final filename = p.basename(widget.imagePath!);
        if (!imageColorMap.containsKey(filename)) {
          imageColorMap[filename] = widget.imageColor!;
          print("Tambahan warna untuk file lama: $filename");

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('imageColorMap', jsonEncode(imageColorMap));
        }
      }



      setState(() {
        wardrobeImages = savedImages.toSet().toList();
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error in _loadImages: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }


  Future<void> _deleteImage(String imagePath) async {
    try {
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
        setState(() {
          wardrobeImages.remove(imagePath);
        });
      }
    } catch (e) {
      debugPrint('Error deleting image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "WARDROBE",
                    style: GoogleFonts.kalnia(
                      fontSize: 35,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: Image.asset('assets/icons/profile.png', width: 50),
                  ),
                ],
              ),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: categories.map((cat) {
                    final isSelected = cat == selectedCategory;
                    return Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCategory = cat;
                          });
                        },
                        child: Text(
                          cat,
                          style: GoogleFonts.kalnia(
                            fontSize: 18,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            decoration: isSelected ? TextDecoration.underline : TextDecoration.none,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),

              Expanded(
                child: selectedCategory == "All"
                    ? GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  padding: const EdgeInsets.only(bottom: 0),
                  children: [
                    ...wardrobeImages.map((image) => _buildImageItem(image, false)),
                    ...categoryClothes["All"]!.map((image) => _buildImageItem(image, true)),
                  ],
                )
                    : Center(
                  child: Text(
                    "No items in this category",
                    style: GoogleFonts.kalnia(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageItem(String imagePath, bool isAsset) {
    return GestureDetector(
      onTap: () => _showImageDialog(imagePath, isAsset),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(20),
        ),
        clipBehavior: Clip.hardEdge,
        child: isAsset
            ? Image.asset(imagePath, fit: BoxFit.cover)
            : FutureBuilder(
          future: File(imagePath).exists(),
          builder: (context, snapshot) {
            if (snapshot.data == true) {
              return Image.file(File(imagePath), fit: BoxFit.cover);
            }
            return const Center(child: Icon(Icons.broken_image));
          },
        ),
      ),
    );
  }

  void _showImageDialog(String imagePath, bool isAsset) {
    print("Cek warna untuk path: $imagePath");
    print("Isi imageColorMap: $imageColorMap");

    final filename = p.basename(imagePath);
    final color = imageColorMap[filename] ?? "unknown";
    print("🧪 Memeriksa warna untuk: $filename");
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.75),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: isAsset
                    ? Image.asset(imagePath, fit: BoxFit.cover)
                    : Image.file(File(imagePath), fit: BoxFit.cover),
              ),
              const SizedBox(height: 10),
              if (!isAsset)
                Text(
                  '#color: ${imageColorMap[p.basename(imagePath)] ?? "unknown"}',
                  style: GoogleFonts.kalnia(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              if (!isAsset)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(color: Colors.black),
                      ),
                      minimumSize: const Size(120, 45),
                    ),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await _deleteImage(imagePath);
                    },
                    child: Text(
                      'DELETE',
                      style: GoogleFonts.kalnia(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}