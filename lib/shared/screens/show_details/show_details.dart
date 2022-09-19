import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tv_tracker/models/appended_show_details.dart';
import 'package:tv_tracker/models/firestore_show.dart';
import 'package:tv_tracker/models/show_details_model.dart';
import 'package:tv_tracker/models/show_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tv_tracker/providers/tmdb_api.dart';
import 'package:tv_tracker/shared/screens/show_details/components/bottom_bar.dart';
import 'package:tv_tracker/shared/widgets/media_background_image.dart';
import 'package:tv_tracker/shared/widgets/media_details_app_bar.dart';
import 'package:tv_tracker/shared/widgets/media_title.dart';
import 'package:tv_tracker/shared/screens/show_details/components/tab_bar.dart';

class ShowDetailsScreen extends StatefulWidget {
  final Show show;

  const ShowDetailsScreen({
    super.key,
    required this.show,
  });

  @override
  State<ShowDetailsScreen> createState() => _ShowDetailsScreenState();
}

class _ShowDetailsScreenState extends State<ShowDetailsScreen> with SingleTickerProviderStateMixin {
  TabController? tabController;
  Future<AppendedShowDetails>? showDetails;
  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    tabController?.addListener(_handleTabSelection);

    super.initState();
  }

  @override
  void dispose() {
    tabController?.dispose();
    super.dispose();
  }

  _handleTabSelection() {
    if (tabController?.indexIsChanging ?? false) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    showDetails = fetchAppendedShowDetails(widget.show.id.toString(), Localizations.localeOf(context).languageCode);
    final ref = FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser!.uid);
    return Scaffold(
      extendBodyBehindAppBar: true,
      bottomNavigationBar: SizedBox(
        height: 50.h,
        child: StreamBuilder(
          stream: ref.doc(widget.show.id!.toString()).snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container();
            }
            var data = snapshot.data as DocumentSnapshot;
            Map<String, dynamic>? map = data.data() as Map<String, dynamic>?;
            FirestoreShow firestoreShow = map != null
                ? FirestoreShow.fromJson(map)
                : FirestoreShow(
                    listed: false,
                    type: "Show",
                    watched: [],
                    completed: false,
                    watchedLength: 0,
                    showName: widget.show.name,
                  );
            return FutureBuilder(
                future: showDetails,
                builder: (context, future) {
                  Widget f1;
                  if (future.connectionState == ConnectionState.done) {
                    f1 = ShowDetailsBottombar(
                        firestoreShow: firestoreShow,
                        docRef: ref.doc(
                          widget.show.id!.toString(),
                        ),
                        showDetails: future.data as AppendedShowDetails);
                  } else {
                    f1 = Container();
                  }

                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 100),
                    child: f1,
                  );
                });
          },
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 26, 25, 25),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          DetailsAppBar(media: widget.show, mediaDetails: showDetails!),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: 1,
              (BuildContext context, int index) {
                return Column(
                  children: [
                    DefaultTabController(
                      length: 2,
                      child: ShowDetailsTabController(show: widget.show, showDetails: showDetails!, tabController: tabController),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
