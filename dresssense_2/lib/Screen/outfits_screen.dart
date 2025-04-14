import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OutfitsScreen extends StatefulWidget {
  const OutfitsScreen({super.key});

  @override
  State<OutfitsScreen> createState() => _OutfitsScreenState();
}

class _OutfitsScreenState extends State<OutfitsScreen> {
  String selectedCategory = "All";

  final List<String> categories = const [
    "All", "Casual", "Bussiness", "Colorful", "Monochrome"
  ];

  final Map<String, List<String>> categoryClothes = {
    "All": [
      'assets/icons/baju-1.png',
      'assets/icons/baju-2.png',
      'assets/icons/baju-3.png',
      'assets/icons/baju-4.png',
      'assets/icons/baju-6.png',
      'assets/icons/baju-4.png',
      'assets/icons/baju-2.png',
      'assets/icons/baju-3.png',
      'assets/icons/baju-4.png',
      'assets/icons/baju-5.png',
      'assets/icons/baju-5.png',
      'assets/icons/baju-2.png',
      'assets/icons/baju-6.png',
      'assets/icons/baju-6.png',
      'assets/icons/baju-3.png',
      'assets/icons/baju-2.png',
      'assets/icons/baju-6.png',
      'assets/icons/baju-3.png',
      'assets/icons/baju-4.png',
    ],
    "Casual": [
      'assets/icons/baju-1.png',
      'assets/icons/baju-3.png',
      'assets/icons/baju-4.png',
      'assets/icons/baju-2.png',
      'assets/icons/baju-3.png',
      'assets/icons/baju-4.png',
      'assets/icons/baju-5.png',
      'assets/icons/baju-5.png',
      'assets/icons/baju-3.png',
    ],
    "Bussiness": [
      'assets/icons/baju-6.png',
      'assets/icons/baju-6.png',
      'assets/icons/baju-6.png',
      'assets/icons/baju-3.png',
      'assets/icons/baju-4.png',
      'assets/icons/baju-5.png',
      'assets/icons/baju-5.png',
    ],
    "Colorful": [
      'assets/icons/baju-5.png',
      'assets/icons/baju-4.png',
      'assets/icons/baju-6.png',
      'assets/icons/baju-6.png',
      'assets/icons/baju-3.png',
    ],
    "Monochrome": [
      'assets/icons/baju-2.png',
      'assets/icons/baju-6.png',
      'assets/icons/baju-6.png',
      'assets/icons/baju-3.png',
      'assets/icons/baju-2.png',
      'assets/icons/baju-6.png',
      'assets/icons/baju-3.png',
      'assets/icons/baju-4.png',
    ],
  };

  @override
  Widget build(BuildContext context) {
    final clothesToShow = categoryClothes[selectedCategory] ?? [];

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
                    "OUTFITS",
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

              // Categories
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
                            fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                            decoration: isSelected
                                ? TextDecoration.underline
                                : TextDecoration.none,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),

              // Clothes Grid
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  padding: const EdgeInsets.only(bottom: 0),
                  children: clothesToShow.map((image) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Image.asset(
                        image,
                        fit: BoxFit.cover,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
