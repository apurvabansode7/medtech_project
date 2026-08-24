import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCountryPhoneCodeField extends StatelessWidget {
  const CustomCountryPhoneCodeField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 12.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Text(
          //   '🇮🇳',
          //   style: TextStyle(
          //     fontSize: 20.sp,
          //   ),
          // ),

          // SizedBox(width: 5.w),

          Text(
            '+91',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}