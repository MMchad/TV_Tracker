import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:tv_tracker/models/movie_model.dart';
import 'package:tv_tracker/providers/tmdb_api.dart';
import 'package:tv_tracker/shared/screens/movie_details/components/movie_tile.dart';
import 'package:tv_tracker/shared/widgets/loading_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MovieList extends StatefulWidget {
  const MovieList({super.key});
  @override
  State<MovieList> createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  static const _pageSize = 20;
  final PagingController<int, Movie> _pagingController = PagingController(firstPageKey: 1);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newMovies = await fetchPopularMovies(
        pageKey,
        Localizations.localeOf(context).languageCode,
      );
      final isLastPage = newMovies.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newMovies);
      } else {
        final nextPageKey = pageKey + newMovies.length;
        _pagingController.appendPage(newMovies, nextPageKey);
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
          AppLocalizations.of(context)!.popularMovies,
          style: GoogleFonts.roboto(fontSize: 22.sp, fontWeight: FontWeight.bold),
        ),
      ),
      body: PagedListView.separated(
        padding: EdgeInsets.only(top: 15.h),
        separatorBuilder: (context, index) => SizedBox(height: 15.h),
        physics: const BouncingScrollPhysics(),
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<Movie>(
          animateTransitions: true,
          firstPageProgressIndicatorBuilder: (context) => const LoadingIndicator(),
          itemBuilder: (context, movie, index) => MovieTile(movie: movie),
        ),
      ),
    );
  }
}
