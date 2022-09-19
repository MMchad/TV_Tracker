import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class KeepAliveCachedImage extends StatefulWidget {
  final String imageUrl;
  final BoxFit fit;

  KeepAliveCachedImage({
    required this.imageUrl,
    this.fit = BoxFit.contain,
  });
  @override
  State<KeepAliveCachedImage> createState() => _KeepAliveCachedImageState();
}

class _KeepAliveCachedImageState extends State<KeepAliveCachedImage> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CachedNetworkImage(imageUrl: widget.imageUrl, fit: widget.fit);
  }

  @override
  bool get wantKeepAlive => true;
}

class KeepAliveImage extends StatefulWidget {
  final String imageUrl;
  final BoxFit fit;

  KeepAliveImage({
    required this.imageUrl,
    this.fit = BoxFit.contain,
  });
  @override
  State<KeepAliveImage> createState() => _KeepAliveImageState();
}

class _KeepAliveImageState extends State<KeepAliveImage> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Image.network(widget.imageUrl, fit: widget.fit);
  }

  @override
  bool get wantKeepAlive => true;
}
