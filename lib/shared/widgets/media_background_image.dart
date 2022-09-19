import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tv_tracker/providers/tmdb_api.dart';

class MediaBackgroundImage extends StatelessWidget {
  const MediaBackgroundImage({
    Key? key,
    required this.height,
    required this.width,
    required this.media,
    this.fullShadow = false,
  }) : super(key: key);

  final media;
  final double height;
  final double width;
  final bool fullShadow;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: ShaderMask(
        shaderCallback: (rect) {
          return LinearGradient(
            begin: (!fullShadow ? Alignment.center : Alignment.topCenter),
            end: Alignment.bottomCenter,
            colors: const [Colors.black, Colors.transparent],
          ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
        },
        blendMode: BlendMode.dstIn,
        child: SizedBox(
          height: height,
          width: width,
          child: (media.backdropPath ?? media.posterPath) != null
              ? CachedNetworkImage(
                  imageUrl: getImageApiUrl(
                    media.backdropPath ?? media.posterPath,
                  ),
                  fit: BoxFit.cover,
                )
              : Icon(
                  Icons.no_photography,
                  size: 55.h,
                ),
        ),
      ),
    );
  }
}
