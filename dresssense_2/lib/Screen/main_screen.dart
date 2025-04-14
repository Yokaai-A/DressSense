import 'package:flutter/material.dart';
import 'package:dresssense/Screen/home_screen.dart';
import 'package:dresssense/Screen/wardrobe_screen.dart';
import 'package:dresssense/Screen/outfits_screen.dart';
import 'package:dresssense/Screen/camera_screen.dart';
import 'package:dresssense/Screen/shop_screen.dart';



// Untuk Navbar
class MainScreen extends StatefulWidget {
  final int initialIndex;
  final String? newImagePath;
  final String? newImageColor;

  const MainScreen({
    super.key,
    this.initialIndex = 0,
    this.newImagePath,
    this.newImageColor,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _selectedIndex;
  String? _imagePathToPass;
  String? _imageColorToPass;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _imagePathToPass = widget.newImagePath;
    _imageColorToPass = widget.newImageColor;
  }

  final List<Widget> _screens = [
    HomeScreen(),
    WardrobeScreen(),
    OutfitsScreen(),
    ShopScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _buildScreens(),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  List<Widget> _buildScreens() {
    return [
      HomeScreen(),
      WardrobeScreen(
        imagePath: _imagePathToPass,
        imageColor: _imageColorToPass,
      ),
      const OutfitsScreen(),
      const ShopScreen(),
    ];
  }

  Widget _buildBottomNavBar() {
    return SizedBox(
      height: 120,
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
              border: Border.all(color: Colors.black, width: 1),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildNavItem("assets/icons/rumah.png", 0),
                  _buildNavItem("assets/icons/lemari.png", 1),
                  const SizedBox(width: 60),
                  _buildNavItem("assets/icons/baju.png", 2),
                  _buildNavItem("assets/icons/toko.png", 3),
                ],
              ),
            ),
          ),
          Positioned(
            top: -45,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 1),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))],
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CameraScreen()),
                  );
                },
                child: Center(
                  child: Image.asset('assets/icons/kamera.png', width: 70),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(String iconPath, int index) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(iconPath, width: 50),
          if (isSelected)
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(51),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }


}
