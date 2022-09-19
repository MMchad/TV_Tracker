import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class KeepAliveStack extends StatefulWidget {
  final List<Widget> children;

  KeepAliveStack({
    required this.children,
  });
  @override
  State<KeepAliveStack> createState() => _KeepAliveStackState();
}

class _KeepAliveStackState extends State<KeepAliveStack> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: widget.children,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
