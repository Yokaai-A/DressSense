import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dresssense/Screen/buy_screen.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  String selectedCategory = 'All';

  final List<Map<String, String>> allItems = const [
    {'image': 'assets/icons/baju-1.png', 'discount': '34%', 'category': 'Sweaters'},
    {'image': 'assets/icons/baju-5.png', 'discount': '30%', 'category': 'T-shirt'},
    {'image': 'assets/icons/baju-3.png', 'discount': '50%', 'category': 'Trousers'},
    {'image': 'assets/icons/baju-1.png', 'discount': '10%', 'category': 'Shirt'},
    {'image': 'assets/icons/baju-5.png', 'discount': '25%', 'category': 'T-shirt'},
    {'image': 'assets/icons/baju-3.png', 'discount': '40%', 'category': 'Sweaters'},
  ];

  List<Map<String, String>> get filteredItems {
    if (selectedCategory == 'All') return allItems;
    return allItems.where((item) => item['category'] == selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 30, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 12),
              _buildSearchBar(),
              const SizedBox(height: 16),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBannerSlider(),
                      const SizedBox(height: 24),
                      Text(
                        'Recommendations For You',
                        style: GoogleFonts.kalnia(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildCategories(),
                      const SizedBox(height: 16),
                      _buildItemGrid(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'SHOPPING',
          style: GoogleFonts.kalnia(
            fontSize: 40,
            fontWeight: FontWeight.w600,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          child: Image.asset('assets/icons/profile.png', width: 50),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextField(
        style: GoogleFonts.kalnia(),
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: Image.asset(
            'assets/icons/search.png',
            width: 30,
          ),
          hintText: 'Search',
          hintStyle: GoogleFonts.kalnia(),
        ),
      ),
    );
  }

  Widget _buildBannerSlider() {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) => Container(
          margin: const EdgeInsets.only(right: 10),
          width: 360,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: const DecorationImage(
              image: AssetImage('assets/images/banner.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategories() {
    final categories = ['All', 'Sweaters', 'Trousers', 'T-shirt', 'Shirt'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((title) {
          final isSelected = selectedCategory == title;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = title;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                title,
                style: GoogleFonts.kalnia(
                  fontSize: 18,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  decoration:
                  isSelected ? TextDecoration.underline : TextDecoration.none,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildItemGrid() {
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 0.79,
      children: List.generate(filteredItems.length, (index) {
        final item = filteredItems[index];

        final bool isButtonEnabled = selectedCategory == 'All' && index == 0;

        return _buildDiscountCard(
          item['image']!,
          item['discount']!,
          onBuyPressed: isButtonEnabled
              ? () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BuyScreen()),
            );
          }
              : null,
        );
      }),
    );
  }



  Widget _buildDiscountCard(String imagePath, String discount, {VoidCallback? onBuyPressed}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 110,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.all(10),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                ),
              ),
              Positioned(
                top: -10,
                right: -10,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    discount,
                    style: GoogleFonts.kalnia(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          SizedBox(
            height: 35,
            width: 80,
            child: ElevatedButton(
              onPressed: onBuyPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                padding: EdgeInsets.zero,
                disabledBackgroundColor: Colors.black,
                disabledForegroundColor: Colors.white,
              ),
              child: Text(
                "BUY",
                style: GoogleFonts.kalnia(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
