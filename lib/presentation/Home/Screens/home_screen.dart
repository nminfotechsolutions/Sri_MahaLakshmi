import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:sri_mahalakshmi/core/utility/app_colors.dart';
import 'package:sri_mahalakshmi/core/utility/app_images.dart';
import 'package:sri_mahalakshmi/presentation/menu/menu_screens.dart';

import '../../../core/utility/app_textstyles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isButtonPressed = false;
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
  Widget build(BuildContext context) {
    return Scaffold(
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
                                tittle: 'Vignesh Kumar',
                              ),
                            ],
                          ),
                        ),

                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: (){
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
                      height: 100,
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
                            width: 60,
                            height: 60,
                            margin: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Center(child: Image.asset(AppImages.gold)),
                          ),

                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Gold Rate',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '₹ 5500.70/-',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Divider
                          Container(
                            width: 1,
                            height: 60,
                            color: Colors.white54,
                          ),
                          SizedBox(width: 2),

                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: const [
                                Text(
                                  'Silver Rate',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '₹ 78.81/-',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
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
                              width: 60,
                              height: 60,
                              margin: EdgeInsets.all(16),
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
                                margin: EdgeInsets.symmetric(horizontal: 5.0),
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
                            print("Join Now clicked!");
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                AppImages.deal,
                                width: 35,
                                height: 35,
                              ),
                              SizedBox(width: 10),
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

                  SizedBox(height: 30),

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
                          leading: Image.asset(AppImages.t_history, height: 32),
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
                          leading: Image.asset(AppImages.t_history, height: 32),
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
                          leading: Image.asset(AppImages.t_history, height: 32),
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
                          leading: Image.asset(AppImages.t_history, height: 32),
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
                          leading: Image.asset(AppImages.t_history, height: 32),
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
                          leading: Image.asset(AppImages.t_history, height: 32),
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
                  ),
                ],
              ),
            ),
          ),
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
