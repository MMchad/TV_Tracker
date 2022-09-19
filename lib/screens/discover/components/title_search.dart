import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tv_tracker/screens/discover/components/title_search_results_list.dart';

void titleSearch(context) {
  showSearch(
    context: context,
    delegate: TitleSearchDelegate(),
  );
}

class TitleSearchDelegate extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context).copyWith(
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
      ),
      textTheme: TextTheme(
        headline6: GoogleFonts.roboto(
          color: Colors.white,
          fontSize: 20.sp,
        ),
      ),
    );
    return theme;
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query != "" ? query = "" : close(context, null);
        },
        icon: const Icon(Icons.clear),
        iconSize: 22.sp,
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(
        Icons.arrow_back,
        size: 22.sp,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return TitleSearchResultList(query: query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return TitleSearchResultList(query: query);
  }
}
