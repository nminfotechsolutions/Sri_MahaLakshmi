import 'package:flutter/material.dart';

class AnimatedNavigation {


 static void navigateWithAnimation(BuildContext context, Widget page) {
   Navigator.push(
     context,
     PageRouteBuilder(
       transitionDuration: const Duration(milliseconds: 400),
       reverseTransitionDuration: const Duration(milliseconds: 400), // important for pop animation
       pageBuilder: (context, animation, secondaryAnimation) => page,
       transitionsBuilder: (context, animation, secondaryAnimation, child) {
         // Slide + Fade animation
         final offsetAnimation = Tween<Offset>(
           begin: const Offset(1.0, 0.0), // from right
           end: Offset.zero,
         ).animate(CurvedAnimation(
           parent: animation,
           curve: Curves.easeInOut,
         ));

         final fadeAnimation = Tween<double>(
           begin: 0.0,
           end: 1.0,
         ).animate(CurvedAnimation(
           parent: animation,
           curve: Curves.easeInOut,
         ));

         return SlideTransition(
           position: offsetAnimation,
           child: FadeTransition(
             opacity: fadeAnimation,
             child: child,
           ),
         );
       },
     ),
   );
 }
}