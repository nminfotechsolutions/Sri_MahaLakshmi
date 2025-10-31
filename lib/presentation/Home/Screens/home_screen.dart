import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sri_mahalakshmi/core/utility/app_colors.dart';
import 'package:sri_mahalakshmi/core/utility/app_images.dart';
import 'package:sri_mahalakshmi/core/utility/app_loader.dart';
import 'package:sri_mahalakshmi/presentation/Home/controller/home_controller.dart';
import 'package:sri_mahalakshmi/presentation/menu/screens/menu_screens.dart';

import '../../../core/utility/app_textstyles.dart';
import '../../Authentication/models/customer_response.dart';
import '../../Join_schemes/controller/scheme_controller.dart';
import '../../Join_schemes/screens/customer_details_screen.dart';
import '../../Join_schemes/screens/join_now_screens.dart';
import '../../my_schemes/screens/my_plan_screens.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController controller = Get.put(HomeController());
  final SchemeController schemeController = Get.put(SchemeController());

  bool isButtonPressed = false;
  String userName = '';
  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('userData');

    if (userDataString != null) {
      try {
        final customerJson = jsonDecode(userDataString);
        final customer = CustomerResponse.fromJson(customerJson);
        setState(() {
          userName = '${customer.firstName ?? ''}';
        });
      } catch (e) {
        print('Error decoding customer data: $e');
      }
    }
  }

  void buttonPressed() {
    setState(() {
      if (isButtonPressed == false) {
        isButtonPressed = true;
      } else if (isButtonPressed == true) {
        isButtonPressed = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserName();
    controller.fetchTodayRate();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await false;
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8),
                BlendMode.lighten,
              ),
              image: AssetImage(AppImages.bg),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: RefreshIndicator(
                onRefresh: () async {
                  return await controller.fetchTodayRate();
                },
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 10,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 7,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppTextStyles.textWithSmall(
                                    text: 'Hello',
                                    fontSize: 17,
                                  ),
                                  AppTextStyles.googleFontIbmPlex(
                                    fontSize: 17,
                                    tittle: userName,
                                  ),
                                ],
                              ),
                            ),

                            Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MenuScreens(),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.teal,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 30),
                      ClipPath(
                        clipper: ConcaveClipper(),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFFF4B5C), Color(0xFFFF7B92)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              // Left Icon
                              Container(
                                width: 50,
                                height: 50,
                                margin: EdgeInsets.symmetric(horizontal: 15),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Image.asset(AppImages.gold),
                                ),
                              ),

                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Gold Rate',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Obx(() {
                                      // Check if the data is available
                                      if (controller
                                          .goldAndSilverRateData
                                          .isEmpty) {
                                        return Text(
                                          'Loading...',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        );
                                      } else {
                                        return Text(
                                          '₹${controller.goldAndSilverRateData.first.gold}/-',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        );
                                      }
                                    }),
                                  ],
                                ),
                              ),

                              Container(
                                width: 1,
                                height: 60,
                                color: Colors.white54,
                              ),
                              SizedBox(width: 5),

                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Silver Rate',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Obx(() {
                                      if (controller
                                          .goldAndSilverRateData
                                          .isEmpty) {
                                        return Text(
                                          'Loading...',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        );
                                      } else {
                                        return Text(
                                          '₹${controller.goldAndSilverRateData.first.silver}/-',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        );
                                      }
                                    }),
                                  ],
                                ),
                              ),

                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MenuScreens(),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  margin: EdgeInsets.symmetric(horizontal: 15),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Image.asset(AppImages.silver),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // ClipPath(
                      //   clipper: ConcaveClipper(),
                      //   child: Container(
                      //     decoration: BoxDecoration(
                      //       gradient: LinearGradient(
                      //         colors: [Color(0xFFFF4B5C), Color(0xFFFF7B92)],
                      //         begin: Alignment.topLeft,
                      //         end: Alignment.bottomRight,
                      //       ),
                      //       borderRadius: BorderRadius.circular(16),
                      //     ),
                      //     child: Row(
                      //       children: [
                      //         // Left Icon
                      //         Container(
                      //           width: 50,
                      //           height: 50,
                      //           margin: EdgeInsets.symmetric(horizontal: 15),
                      //           decoration: BoxDecoration(
                      //             color: Colors.white,
                      //             shape: BoxShape.circle,
                      //           ),
                      //           child: Center(
                      //             child: Image.asset(AppImages.gold),
                      //           ),
                      //         ),
                      //
                      //         Expanded(
                      //           child: Column(
                      //             mainAxisAlignment: MainAxisAlignment.center,
                      //             crossAxisAlignment: CrossAxisAlignment.start,
                      //             children: [
                      //               Text(
                      //                 'Gold Rate',
                      //                 style: TextStyle(
                      //                   color: Colors.white,
                      //                   fontWeight: FontWeight.bold,
                      //                   fontSize: 16,
                      //                 ),
                      //               ),
                      //               SizedBox(height: 4),
                      //               Obx(
                      //                 () => Text(
                      //                   '₹${controller.goldAndSilverRateData.first.gold}/-',
                      //                   style: TextStyle(
                      //                     color: Colors.white,
                      //                     fontSize: 14,
                      //                   ),
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //         ),
                      //
                      //         Container(
                      //           width: 1,
                      //           height: 60,
                      //           color: Colors.white54,
                      //         ),
                      //         SizedBox(width: 5),
                      //
                      //         Expanded(
                      //           child: Column(
                      //             mainAxisAlignment: MainAxisAlignment.center,
                      //             crossAxisAlignment: CrossAxisAlignment.end,
                      //             children:   [
                      //               Text(
                      //                 'Silver Rate',
                      //                 style: TextStyle(
                      //                   color: Colors.white,
                      //                   fontWeight: FontWeight.bold,
                      //                   fontSize: 16,
                      //                 ),
                      //               ),
                      //               SizedBox(height: 4),
                      //               Obx(
                      //                     () => Text(
                      //                   '₹${controller.goldAndSilverRateData.first.silver}/-',
                      //                   style: TextStyle(
                      //                     color: Colors.white,
                      //                     fontSize: 14,
                      //                   ),
                      //                 ),
                      //               ),
                      //               // Text(
                      //               //   '₹ 78.81/-',
                      //               //   style: TextStyle(
                      //               //     color: Colors.white,
                      //               //     fontSize: 14,
                      //               //   ),
                      //               // ),
                      //             ],
                      //           ),
                      //         ),
                      //
                      //         InkWell(
                      //           onTap: () {
                      //             Navigator.push(
                      //               context,
                      //               MaterialPageRoute(
                      //                 builder: (context) => MenuScreens(),
                      //               ),
                      //             );
                      //           },
                      //           child: Container(
                      //             width: 50,
                      //             height: 50,
                      //             margin: EdgeInsets.symmetric(horizontal: 15),
                      //             decoration: BoxDecoration(
                      //               color: Colors.white,
                      //               shape: BoxShape.circle,
                      //             ),
                      //             child: Center(
                      //               child: Image.asset(AppImages.silver),
                      //             ),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      SizedBox(height: 30),
                      CarouselSlider(
                        options: CarouselOptions(
                          height: 125,
                          autoPlay: true,
                          enlargeCenterPage: true,
                          viewportFraction: 0.75,
                        ),
                        items:
                            [
                              AppImages.banner_1,
                              AppImages.banner_2,
                              AppImages.banner_1,
                            ].map((imagePath) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Container(
                                    width:
                                        MediaQuery.of(context).size.width *
                                        0.85, // slightly wider
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 5.0,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        10,
                                      ), // border radius 10
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 5,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        imagePath,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                      ),
                      SizedBox(height: 40),

                      Row(
                        children: [
                          Expanded(
                            child: BouncePressButton(
                              gradientColors: [
                                Color(0xFFFF6B6B),
                                Color(0xFFFF8B94),
                              ],
                              onTap: () {
                                Get.to(JoinNowScreens());

                                print("Join Now clicked!");
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(AppImages.deal, height: 25),

                                  Text(
                                    'Join Now',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: BouncePressButton(
                              gradientColors: [
                                Color(0xFF6B9CFF),
                                Color(0xFF4B79FF),
                              ],
                              onTap: () {
                                Get.to(MyPlanScreens());
                                print("My Plan clicked!");
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    AppImages.my_plan2,
                                    width: 35,
                                    height: 35,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'My Plan',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      /* SizedBox(height: 30),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppTextStyles.googleFontLaTo(
                            tittle: 'Transaction Details',
                            fontSize: 18,
                          ),
                          SizedBox(height: 20),

                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFFFFF5E5),
                                  Color(0xFFFFE0C8),
                                ], // soft gradient
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ListTile(
                              leading: Image.asset(
                                AppImages.t_history,
                                height: 32,
                              ),
                              title: AppTextStyles.textWithSmall(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                text: 'Or_3542',
                                color: AppColor.darkTeal,
                              ),
                              subtitle: AppTextStyles.textWithSmall(
                                fontSize: 12,
                                text: '24.Oct.2025',
                              ),
                              trailing: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppTextStyles.textWithSmall(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    text: '₹ 78900',
                                    color: AppColor.darkTeal,
                                  ),
                                  AppTextStyles.textWithSmall(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    text: 'St: Success',
                                    color: AppColor.darkTeal,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 5),

                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFFFFF5E5),
                                  Color(0xFFFFE0C8),
                                ], // soft gradient
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ListTile(
                              leading: Image.asset(
                                AppImages.t_history,
                                height: 32,
                              ),
                              title: AppTextStyles.textWithSmall(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                text: 'Or_3542',
                                color: AppColor.darkTeal,
                              ),
                              subtitle: AppTextStyles.textWithSmall(
                                fontSize: 12,
                                text: '24.Oct.2025',
                              ),
                              trailing: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppTextStyles.textWithSmall(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    text: '₹ 78900',
                                    color: AppColor.darkTeal,
                                  ),
                                  AppTextStyles.textWithSmall(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    text: 'St: Success',
                                    color: AppColor.darkTeal,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 5),

                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFFFFF5E5),
                                  Color(0xFFFFE0C8),
                                ], // soft gradient
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ListTile(
                              leading: Image.asset(
                                AppImages.t_history,
                                height: 32,
                              ),
                              title: AppTextStyles.textWithSmall(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                text: 'Or_3542',
                                color: AppColor.darkTeal,
                              ),
                              subtitle: AppTextStyles.textWithSmall(
                                fontSize: 12,
                                text: '24.Oct.2025',
                              ),
                              trailing: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppTextStyles.textWithSmall(
                                    fontWeight: FontWeight.w500,

                                    text: '₹ 78900',
                                    color: AppColor.darkTeal,
                                  ),
                                  AppTextStyles.textWithSmall(
                                    fontWeight: FontWeight.w500,

                                    text: 'St: Success',
                                    color: AppColor.darkTeal,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 5),

                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFFFFF5E5),
                                  Color(0xFFFFE0C8),
                                ], // soft gradient
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ListTile(
                              leading: Image.asset(
                                AppImages.t_history,
                                height: 32,
                              ),
                              title: AppTextStyles.textWithSmall(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                text: 'Or_3542',
                                color: AppColor.darkTeal,
                              ),
                              subtitle: AppTextStyles.textWithSmall(
                                fontSize: 12,
                                text: '24.Oct.2025',
                              ),
                              trailing: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppTextStyles.textWithSmall(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    text: '₹ 78900',
                                    color: AppColor.darkTeal,
                                  ),
                                  AppTextStyles.textWithSmall(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    text: 'St: Success',
                                    color: AppColor.darkTeal,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 5),

                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFFFFF5E5),
                                  Color(0xFFFFE0C8),
                                ], // soft gradient
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ListTile(
                              leading: Image.asset(
                                AppImages.t_history,
                                height: 32,
                              ),
                              title: AppTextStyles.textWithSmall(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                text: 'Or_3542',
                                color: AppColor.darkTeal,
                              ),
                              subtitle: AppTextStyles.textWithSmall(
                                fontSize: 12,
                                text: '24.Oct.2025',
                              ),
                              trailing: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppTextStyles.textWithSmall(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    text: '₹ 78900',
                                    color: AppColor.darkTeal,
                                  ),
                                  AppTextStyles.textWithSmall(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    text: 'St: Success',
                                    color: AppColor.darkTeal,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 5),

                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFFFFF5E5),
                                  Color(0xFFFFE0C8),
                                ], // soft gradient
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ListTile(
                              leading: Image.asset(
                                AppImages.t_history,
                                height: 32,
                              ),
                              title: AppTextStyles.textWithSmall(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                text: 'Or_3542',
                                color: AppColor.darkTeal,
                              ),
                              subtitle: AppTextStyles.textWithSmall(
                                fontSize: 12,
                                text: '24.Oct.2025',
                              ),
                              trailing: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppTextStyles.textWithSmall(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    text: '₹ 78900',
                                    color: AppColor.darkTeal,
                                  ),
                                  AppTextStyles.textWithSmall(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    text: 'St: Success',
                                    color: AppColor.darkTeal,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),*/
                      SizedBox(height: 25),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Popular Schemes",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF5A4636),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Get.to(() => JoinNowScreens());
                              },
                              child: const Text(
                                "View All",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(
                                    0xFF8B6F47,
                                  ), // elegant gold-brown
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Obx(() {
                        final schemes = schemeController.schemeList
                            .take(3)
                            .toList(); // 🟡 Only 3
                        if (controller.isLoading.value) {
                          return Center(child: AppLoader.circularLoader());
                        } else if (schemes.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.all(20),
                            child: Text("No Schemes Available"),
                          );
                        }

                        return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: schemes.length,
                          itemBuilder: (context, index) {
                            final scheme = schemes[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFFDF3E7),
                                    Color(0xFFFFE6A7),
                                    Color(0xFFF7DFA7),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.brown.shade200.withOpacity(
                                      0.3,
                                    ),
                                    blurRadius: 8,
                                    offset: const Offset(2, 4),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16),
                                title: Text(
                                  scheme.schemeName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF5A4636),
                                  ),
                                ),
                                subtitle: Text(
                                  "Type: ${scheme.schemeType}\nAmount: ₹${scheme.chitAmt}",
                                  style: const TextStyle(
                                    color: Color(0xFF6D4C41),
                                  ),
                                ),
                                trailing: ElevatedButton(
                                  onPressed: () {
                                    if (scheme.chitAmt == 'FLEXIBLE') {
                                      enteredAmount.value = 0;
                                      Get.bottomSheet(
                                        _flexibleAmountBottomSheet(scheme),
                                        isScrollControlled: true,
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(25),
                                          ),
                                        ),
                                      );
                                    } else {
                                      Get.to(
                                        () => CustomerDetailsScreen(),
                                        arguments: scheme,
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF8B6F47),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text("Join"),
                                ),
                              ),
                            );
                          },
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  final RxDouble enteredAmount = 0.0.obs;
  Widget _flexibleAmountBottomSheet(dynamic scheme) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(Get.context!).viewInsets.bottom + 16,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          boxShadow: [
            BoxShadow(
              color: Colors.brown.shade200.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top handle
            Center(
              child: Container(
                height: 5,
                width: 50,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
            ),

            // Title
            Text(
              "Enter Flexible Amount",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.brown.shade800,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 16),

            // Amount Input
            TextField(
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: "Amount (₹)",
                labelStyle: TextStyle(color: Colors.brown.shade600),
                filled: true,
                fillColor: Colors.brown.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(
                fontSize: 16,
                color: Colors.brown.shade800,
                fontWeight: FontWeight.w600,
              ),
              onChanged: (value) {
                double val = double.tryParse(value) ?? 0.0;
                enteredAmount.value = val;
              },
            ),
            const SizedBox(height: 16),

            // Gold Weight Display
            Obx(() {
              double goldRate = controller.goldAndSilverRateData.first.gold
                  .toDouble();
              double weight = (goldRate > 0)
                  ? enteredAmount.value / goldRate
                  : 0;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Gold Rate:",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.brown.shade600,
                    ),
                  ),
                  Text(
                    "₹${goldRate.toStringAsFixed(2)}/g",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown.shade800,
                    ),
                  ),
                ],
              );
            }),
            const SizedBox(height: 8),
            Obx(() {
              double goldRate = controller.goldAndSilverRateData.first.gold
                  .toDouble();
              double weight = (goldRate > 0)
                  ? enteredAmount.value / goldRate
                  : 0;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Equivalent Gold Weight:",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.brown.shade600,
                    ),
                  ),
                  Text(
                    "${weight.toStringAsFixed(3)} g",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown.shade800,
                    ),
                  ),
                ],
              );
            }),
            const SizedBox(height: 24),

            // Proceed Button with gradient
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (enteredAmount.value > 0) {
                    Get.back(); // Close BottomSheet
                    Get.to(
                      () => CustomerDetailsScreen(
                        enteredAmount: enteredAmount.value,
                      ), // ✅ pass .value
                      arguments: scheme,
                    );
                  } else {
                    Get.snackbar(
                      "Invalid Amount",
                      "Please enter a valid amount.",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.orange.shade100,
                      colorText: Colors.brown.shade700,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  backgroundColor: Colors.orange.shade100,
                ),
                child: Text(
                  "Proceed",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,

                    color: AppColor.black,
                    fontSize: 16,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class ConcaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    double concaveWidth = 20;
    double curveHeight = size.height / 3;

    path.moveTo(0, 0);
    path.lineTo(0, curveHeight);
    path.quadraticBezierTo(
      concaveWidth,
      size.height / 2,
      0,
      size.height - curveHeight,
    );
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, size.height - curveHeight);
    path.quadraticBezierTo(
      size.width - concaveWidth,
      size.height / 2,
      size.width,
      curveHeight,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class BouncePressButton extends StatefulWidget {
  final List<Color> gradientColors;
  final Widget child;
  final VoidCallback onTap;

  const BouncePressButton({
    super.key,
    required this.gradientColors,
    required this.child,
    required this.onTap,
  });

  @override
  State<BouncePressButton> createState() => _BouncePressButtonState();
}

class _BouncePressButtonState extends State<BouncePressButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        duration: Duration(milliseconds: 100),
        scale: _isPressed ? 0.85 : 1.0, // bounce/shrink effect
        curve: Curves.easeOutBack,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 100),
          height: 70,
          margin: EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: _isPressed
                  ? widget.gradientColors
                        .map((c) => c.withOpacity(0.7))
                        .toList()
                  : widget.gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: _isPressed ? 3 : 6,
                offset: _isPressed ? Offset(2, 2) : Offset(0, 4),
              ),
            ],
          ),
          child: Center(child: widget.child),
        ),
      ),
    );
  }
}

// class ConcaveClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     final path = Path();
//
//     double concaveWidth = 20; // width of the concave cutout
//     double curveHeight = size.height / 3;
//
//     path.moveTo(0, 0);
//     // Left edge with concave curve
//     path.lineTo(0, curveHeight);
//     path.quadraticBezierTo(
//       concaveWidth,
//       size.height / 2,
//       0,
//       size.height - curveHeight,
//     );
//     path.lineTo(0, size.height);
//     path.lineTo(size.width, size.height);
//     // Right edge with concave curve
//     path.lineTo(size.width, size.height - curveHeight);
//     path.quadraticBezierTo(
//       size.width - concaveWidth,
//       size.height / 2,
//       size.width,
//       curveHeight,
//     );
//     path.lineTo(size.width, 0);
//     path.close();
//
//     return path;
//   }
//
//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => false;
// }
