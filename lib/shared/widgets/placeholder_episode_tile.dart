import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlaceholderEpisodeTile extends StatelessWidget {
  const PlaceholderEpisodeTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.h),
      child: Container(
        color: const Color.fromARGB(255, 43, 42, 42),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Shimmer.fromColors(
              period: const Duration(milliseconds: 700),
              baseColor: const Color.fromARGB(255, 70, 70, 70),
              highlightColor: const Color.fromARGB(255, 116, 115, 115),
              child: Container(
                color: const Color.fromARGB(255, 70, 70, 70),
                height: 100.h,
                width: 100.h,
                child: Container(),
              ),
            ),
            SizedBox(
              width: 15.h,
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.only(top: 20.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      period: const Duration(milliseconds: 700),
                      baseColor: const Color.fromARGB(255, 70, 70, 70),
                      highlightColor: const Color.fromARGB(255, 116, 115, 115),
                      child: Container(
                        height: 15.h,
                        width: 100.h,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    Shimmer.fromColors(
                      period: const Duration(milliseconds: 700),
                      baseColor: const Color.fromARGB(255, 70, 70, 70),
                      highlightColor: const Color.fromARGB(255, 116, 115, 115),
                      child: Container(
                        height: 15.h,
                        width: 60.h,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Shimmer.fromColors(
              period: const Duration(milliseconds: 700),
              baseColor: const Color.fromARGB(255, 70, 70, 70),
              highlightColor: const Color.fromARGB(255, 116, 115, 115),
              child: Container(
                height: 100.h,
                width: 65.h,
                color: const Color.fromARGB(255, 70, 70, 70),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [Container()],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
