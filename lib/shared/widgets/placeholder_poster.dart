import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class PlaceholderPoster extends StatelessWidget {
  const PlaceholderPoster({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Shimmer.fromColors(
          period: const Duration(milliseconds: 700),
          baseColor: const Color.fromARGB(255, 70, 70, 70),
          highlightColor: const Color.fromARGB(255, 116, 115, 115),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.sp),
            child: Container(
              color: const Color.fromARGB(255, 26, 25, 25),
              height: MediaQuery.of(context).size.height / 3,
              width: (MediaQuery.of(context).size.height / 3) * 0.6666666666666667,
            ),
          ),
        ),
      ],
    );
  }
}
