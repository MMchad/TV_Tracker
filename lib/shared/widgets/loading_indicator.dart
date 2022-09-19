import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoadingIndicator extends StatelessWidget {
  final double raidus;
  final Color color;
  const LoadingIndicator({Key? key, this.raidus = 40, this.color = Colors.greenAccent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: raidus.h,
        width: raidus.h,
        child: Center(child: CircularProgressIndicator(color: color)),
      ),
    );
  }
}
