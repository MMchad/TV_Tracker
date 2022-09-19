import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tv_tracker/models/cast.dart';
import 'package:tv_tracker/shared/widgets/actor_card.dart';
import 'package:tv_tracker/shared/widgets/details_divider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ActorsList extends StatelessWidget {
  const ActorsList({
    Key? key,
    required this.cast,
  }) : super(key: key);

  final List<Actor> cast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DetailsDivider(
          details: AppLocalizations.of(context)!.cast,
          divide: false,
        ),
        SizedBox(
          height: 20.h,
        ),
        SizedBox(
          height: 200.h,
          child: ListView(
            addAutomaticKeepAlives: true,
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: [
              for (var actor in cast.sublist(0, min(cast.length, 7))) ActorCard(actor: actor),
            ],
          ),
        ),
        const DetailsDivider(
          details: "",
          divide: true,
        ),
      ],
    );
  }
}
