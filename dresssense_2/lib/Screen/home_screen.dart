import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dresssense/module/weather_box.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  final List<Map<String, String>> discounts = [
    {'image': 'assets/icons/baju-1.png', 'discount': '20%'},
    {'image': 'assets/icons/baju-2.png', 'discount': '30%'},
    {'image': 'assets/icons/baju-3.png', 'discount': '50%'},
    {'image': 'assets/icons/baju-1.png', 'discount': '10%'},
    {'image': 'assets/icons/baju-2.png', 'discount': '25%'},
    {'image': 'assets/icons/baju-3.png', 'discount': '40%'},
  ];

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Image.asset('assets/icons/profile.png', width: 60),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Hi, ",
                                      style: GoogleFonts.cormorantGaramond(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "John",
                                      style: GoogleFonts.kalnia(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                "How’s your day?",
                                style: GoogleFonts.kalnia(fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Image.asset('assets/icons/notif-off.png', width: 35),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Weather Box
                  const WeatherBox(),
                  const SizedBox(height: 20),

                  // Feeling Section
                  Container(
                    padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 8,),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "How are you feeling today?",
                          style: GoogleFonts.kalnia(fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 5,
                          runSpacing: 5,
                          children: [
                            feelingChip("Happy"),
                            feelingChip("Gloomy"),
                            feelingChip("Bad"),
                            feelingChip("Adventurous"),
                            feelingChip("Cool"),
                            feelingChip("Brave"),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(120, 15),
                              side: const BorderSide(color: Colors.black),
                            ),
                            child: Text(
                              "Find Recommendation",
                              style: GoogleFonts.kalnia(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                      child: Text(
                        "Today's Discount",
                        style: GoogleFonts.kalnia(fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ),
                  const SizedBox(height: 10),
                ]),
              ),
            ),

            // Discount Grid Section
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                      (context, index) => discountCard(
                    widget.discounts[index]['image']!,
                    widget.discounts[index]['discount']!,
                  ),
                  childCount: widget.discounts.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.75,
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),

    );
  }

  static Widget feelingChip(String label) {
    return OutlinedButton(
      onPressed: () {},
      child: Text(
        label,
        style: GoogleFonts.kalnia(
          fontSize: 15,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }


  static Widget discountCard(String imagePath, String discount) {
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
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                padding: EdgeInsets.zero,
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
