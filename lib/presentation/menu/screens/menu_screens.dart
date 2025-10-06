import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sri_mahalakshmi/core/utility/app_textstyles.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/utility/app_colors.dart';
import '../../../core/utility/app_images.dart';
import 'kyc_screens.dart';

class MenuScreens extends StatefulWidget {
  const MenuScreens({super.key});

  @override
  State<MenuScreens> createState() => _MenuScreensState();
}

class _MenuScreensState extends State<MenuScreens> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            children: [
              SizedBox(height: 10),
              // HEADER
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppTextStyles.textWith600(text: 'Menu', fontSize: 25),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // SCROLLABLE MENU ITEMS
              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      ...[
                        'Join Now',
                        'My Savings',
                        'Kyc',
                        'Transaction History',
                        'My Profile',
                      ].map((title) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: InkWell(
                            onTap: () {
                              if (title == 'Kyc') {
                                // Navigate to KYC Screen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => KycScreen(),
                                  ),
                                );
                              } else {
                                // Handle other menu items
                                print('Tapped: $title');
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColor.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 2,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                title: AppTextStyles.textWith600(
                                  text: title,
                                  fontSize: 20,
                                  color: AppColor.lightBlack,
                                ),
                                trailing: Icon(Icons.chevron_right),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),


              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextStyles.textWith600(
                    text: 'Our Shop Location',
                    fontSize: 18,
                  ),
                  SizedBox(height: 10),

                  GestureDetector(
                    onTap: () {
                      _openMap(9.931457602796653, 78.1100249845084);
                    },
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          colors: [Colors.white, Colors.grey[100]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                          children: [
                            FlutterMap(
                              options: MapOptions(
                                initialCenter: LatLng(
                                  9.931457602796653,
                                  78.1100249845084,
                                ),
                                initialZoom: 14,
                                onTap: (tapPosition, point) {
                                  _openMap(9.931457602796653, 78.1100249845084);
                                },
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate:
                                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  userAgentPackageName:
                                      'com.example.sri_mahalakshmi',
                                ),
                                MarkerLayer(
                                  markers: [
                                    Marker(
                                      point: LatLng(
                                        9.931457602796653,
                                        78.1100249845084,
                                      ),
                                      width: 40,
                                      height: 40,
                                      child: Icon(
                                        Icons.location_on,
                                        color: Colors.red,
                                        size: 40,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            // Optional overlay with icon + text
                            Positioned(
                              bottom: 10,
                              left: 10,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.location_pin,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      "NM Infotech Solutions",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openMap(double lat, double lng) async {
    final Uri url = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=$lat,$lng",
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not open the map.';
    }
  }
}
