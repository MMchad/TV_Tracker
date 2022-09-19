import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tv_tracker/models/appended_show_details.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tv_tracker/models/season.dart';
import 'package:tv_tracker/providers/tmdb_api.dart';
import 'package:tv_tracker/shared/screens/show_details/components/details_tab.dart';
import 'package:tv_tracker/shared/screens/show_details/components/episodes_tab.dart';

class ShowDetailsTabBarBody extends StatelessWidget {
  final AppendedShowDetails showDetails;
  final TabController? tabController;
  const ShowDetailsTabBarBody({super.key, required this.showDetails, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 26, 25, 25),
      child: Padding(
        padding: EdgeInsets.only(left: 15.h, right: 15.h, top: 15.h),
        child: Column(
          children: [
            [ShowDetailsTab(showDetails: showDetails)],
            [
              FutureBuilder(
                  future: fetchSeasons(
                    showDetails.showDetails!.id!.toString(),
                    showDetails.showDetails?.numberOfSeasons ?? -1,
                    Localizations.localeOf(context).languageCode,
                  ),
                  builder: (context, future) {
                    if (future.connectionState == ConnectionState.done) {
                      return EpisodesTab(
                        show: showDetails,
                        seasons: future.data as List<Season>,
                      );
                    }
                    return SizedBox(
                      height: (MediaQuery.of(context).size.height) - (MediaQuery.of(context).size.height / 2.2) - 40.h,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 25.h,
                            width: 25.h,
                            child: const CircularProgressIndicator(
                              color: Colors.greenAccent,
                            ),
                          ),
                        ],
                      ),
                    );
                  })
            ],
          ][tabController?.index ?? 0],
        ),
      ),
    );
  }
}
