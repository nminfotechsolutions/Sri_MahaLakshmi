import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppLoader {
  static circularLoader({Color? color = AppColor.blue}) {
    return Center(
      child: CircularProgressIndicator(color: color, strokeWidth: 2),
    );
  }
}
