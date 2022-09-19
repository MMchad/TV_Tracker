import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OutlinedIconButton extends StatelessWidget {
  final String title;
  final double fontSize;
  final double height;
  final Color borderColor;
  final double iconSize;
  final IconData icon;
  final Color iconColor;
  final Color textColor;
  final double borderWidth;
  final Color fillColor;
  final void Function()? onPress;
  const OutlinedIconButton({
    Key? key,
    required this.title,
    required this.icon,
    this.onPress,
    this.height = 30,
    this.fontSize = 14,
    this.borderColor = Colors.white,
    this.iconSize = 18,
    this.iconColor = Colors.white,
    this.textColor = Colors.white,
    this.borderWidth = 2,
    this.fillColor = Colors.transparent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height.h,
      child: OutlinedButton.icon(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(fillColor),
          side: MaterialStateProperty.all(
            BorderSide(color: borderColor, width: borderWidth.h),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.h),
            ),
          ),
        ),
        onPressed: onPress,
        icon: Icon(
          icon,
          size: iconSize.h,
          color: iconColor,
        ),
        label: Padding(
          padding: EdgeInsets.only(right: 6.sp),
          child: Text(
            title,
            style: GoogleFonts.roboto(
              fontSize: fontSize.sp,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
