import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:tv_tracker/models/show_model.dart';
import 'package:tv_tracker/providers/tmdb_api.dart';
import 'package:tv_tracker/shared/screens/show_details/show_details.dart';
import 'package:tv_tracker/shared/widgets/loading_indicator.dart';
import 'package:tv_tracker/shared/widgets/media_title.dart';
import 'package:tv_tracker/shared/widgets/media_background_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShowList extends StatefulWidget {
  const ShowList({super.key});
  @override
  State<ShowList> createState() => _ShowListState();
}

class _ShowListState extends State<ShowList> {
  static const _pageSize = 20;
  final PagingController<int, Show> _pagingController = PagingController(firstPageKey: 1);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newShows = await fetchPopularShows(
        pageKey,
        Localizations.localeOf(context).languageCode,
      );
      final isLastPage = newShows.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newShows);
      } else {
        final nextPageKey = pageKey + newShows.length;
        _pagingController.appendPage(newShows, nextPageKey);
      }
    } on Exception catch (e) {
      _pagingController.error = e;
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50.h,
        backgroundColor: const Color.fromARGB(255, 26, 25, 25),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context, null),
          icon: Icon(
            Icons.keyboard_arrow_down,
            size: 35.sp,
            color: Colors.white,
          ),
        ),
        title: Text(
          AppLocalizations.of(context)!.popularShows,
          style: GoogleFonts.roboto(fontSize: 22.sp, fontWeight: FontWeight.bold),
        ),
      ),
      body: PagedListView.separated(
        padding: EdgeInsets.only(top: 15.h),
        separatorBuilder: (context, index) => SizedBox(height: 15.h),
        physics: const BouncingScrollPhysics(),
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<Show>(
          animateTransitions: true,
          firstPageProgressIndicatorBuilder: (context) => const LoadingIndicator(),
          itemBuilder: (context, show, index) => GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ShowDetailsScreen(show: show))),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(3.h),
                child: Stack(
                  children: [
                    MediaBackgroundImage(
                      height: 300.h,
                      width: MediaQuery.of(context).size.width - 30,
                      media: show,
                      fullShadow: true,
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: MediaTitle(
                          media: show,
                          titleFontSize: 22,
                          subFontsize: 17,
                          radius: 40,
                          ratingFontSize: 17,
                          mediaDetails: fetchAppendedShowDetails(
                            show.id.toString(),
                            Localizations.localeOf(context).languageCode,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
