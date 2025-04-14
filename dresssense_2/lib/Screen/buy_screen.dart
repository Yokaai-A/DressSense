import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class BuyScreen extends StatefulWidget {
  const BuyScreen({super.key});

  @override
  State<BuyScreen> createState() => _BuyScreenState();
}

class _BuyScreenState extends State<BuyScreen> {
  String? _selectedMarketplace;

  final Map<String, String> marketplaceWebLinks = {
    "Tokopedia": "https://www.tokopedia.com/odsstores/kaos-oversize-ods-oversized-t-shirt-abu-grey-s?utm_campaign=pdp-3w8uxpw9pel7-1328689023--10000&utm_source=salinlink&utm_medium=share",
    "Shopee": "https://id.shp.ee/SNqkP6m",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.arrow_back_ios_new_outlined, size: 30),
                        ),
                        const SizedBox(width: 10),
                        Text("Back", style: GoogleFonts.kalnia(fontSize: 18)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          height: 250,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Image.asset('assets/icons/baju-1.png', height: 150),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Grey Misty T-Shirts",
                                  style: GoogleFonts.kalnia(
                                      fontSize: 16, fontWeight: FontWeight.bold)),
                              Align(
                                alignment: Alignment.center,
                                child: Text("ODS", style: GoogleFonts.kalnia(fontSize: 16)),
                              ),
                              const SizedBox(height: 8),
                              Text("Price :",
                                  style: GoogleFonts.kalnia(
                                      fontSize: 16, fontWeight: FontWeight.w500)),
                              Text("Rp 99.000,00",
                                  style: GoogleFonts.kalnia(
                                      fontSize: 20, fontWeight: FontWeight.w500)),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 7,
                                runSpacing: 7,
                                children: [
                                  _buildTag("#Color: Grey Misty"),
                                  _buildTag("#Occasion: Casual"),
                                  _buildTag("#Material: cotton combed 24s"),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Text("This product pairs with:",
                        style: GoogleFonts.kalnia(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildPairItem('assets/icons/baju-2.png'),
                        _buildPairItem('assets/icons/baju-6.png'),
                        _buildPairItem('assets/icons/baju-5.png'),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Text("This product is available on:",
                        style: GoogleFonts.kalnia(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: marketplaceWebLinks.entries.map((entry) {
                        return _buildMarketplaceButton(entry.key);
                      }).toList(),
                    ),
                    const SizedBox(height: 30),
                    Text("Similar Products:",
                        style: GoogleFonts.kalnia(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 6,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.8,
                      ),
                      itemBuilder: (context, index) {
                        return _buildSimilarProduct('assets/icons/baju-1.png');
                      },
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(12),
                color: Colors.white,
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      final messenger = ScaffoldMessenger.of(context);

                      if (_selectedMarketplace == null) {
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text(
                              "Please select a marketplace first",
                              style: GoogleFonts.kalnia(color: Colors.white, fontWeight: FontWeight.w500),
                            ),
                            backgroundColor: Colors.black,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                        return;
                      }

                      final url = marketplaceWebLinks[_selectedMarketplace!]!;
                      final uri = Uri.parse(url);

                      try {
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(
                            uri,
                            mode: LaunchMode.externalApplication,
                            webOnlyWindowName: '_blank',
                          );
                        } else {
                          throw 'Could not launch $url';
                        }
                      } catch (e) {
                        debugPrint('Error launching URL: $e');
                        messenger.showSnackBar(
                          const SnackBar(
                            content: Text('Failed to open marketplace'),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(),
                    ),
                    child: Text("BUY NOW",
                        style: GoogleFonts.kalnia(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 150),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: GoogleFonts.kalnia(fontSize: 12, fontWeight: FontWeight.w500),
          softWrap: true,
        ),
      ),
    );
  }


  Widget _buildPairItem(String imagePath) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Image.asset(imagePath, height: 90),
    );
  }

  Widget _buildMarketplaceButton(String name) {
    final isSelected = _selectedMarketplace == name;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMarketplace = name;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          name,
          style: GoogleFonts.kalnia(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildSimilarProduct(String imagePath) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(25),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black),
              ),
              child: Center(
                child: Image.asset(imagePath, height: 80),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 90,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
              child: Text("BUY",
                  style: GoogleFonts.kalnia(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }
}
