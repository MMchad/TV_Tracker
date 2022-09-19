import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tv_tracker/models/appended_show_details.dart';
import 'package:tv_tracker/models/show_details_model.dart';
import 'package:tv_tracker/models/show_model.dart';
import 'package:tv_tracker/providers/tmdb_api.dart';
import 'package:tv_tracker/shared/screens/show_details/components/tab_bar_body.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShowDetailsTabController extends StatelessWidget {
  final Show show;
  final Future showDetails;
  final TabController? tabController;

  const ShowDetailsTabController({super.key, required this.show, required this.showDetails, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: 40.h,
        child: TabBar(
          controller: tabController,
          indicatorColor: Colors.greenAccent,
          indicatorWeight: 3.h,
          tabs: [
            Tab(
              child: Text(
                AppLocalizations.of(context)!.details,
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(fontSize: 18.sp),
              ),
            ),
            Tab(
                child: Text(
              AppLocalizations.of(context)!.episodes,
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(fontSize: 18.sp),
            )),
          ],
        ),
      ),
      FutureBuilder(
        future: showDetails,
        builder: (context, future) {
          if (future.connectionState == ConnectionState.done && future.data != null) {
            return ShowDetailsTabBarBody(showDetails: future.data as AppendedShowDetails, tabController: tabController);
          } else {
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
          }
        },
      ),
    ]);
  }
}
