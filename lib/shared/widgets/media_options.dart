import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tv_tracker/shared/widgets/outlined_icon_button.dart';

class MediaOptions extends StatefulWidget {
  const MediaOptions({super.key});

  @override
  State<MediaOptions> createState() => MediaOptionsState();
}

class MediaOptionsState extends State<MediaOptions> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        const OutlinedIconButton(icon: Icons.add, title: "Add to list"),
        SizedBox(
          width: 5.h,
        ),
        const OutlinedIconButton(icon: Icons.close, title: "Not watched"),
      ],
    );
  }
}
