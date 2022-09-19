import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tv_tracker/models/appended_show_details.dart';
import 'package:tv_tracker/models/firestore_movie_model.dart';
import 'package:tv_tracker/models/firestore_show.dart';
import 'package:tv_tracker/models/season.dart';
import 'package:tv_tracker/models/show_details_model.dart';
import 'package:tv_tracker/providers/tmdb_api.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShowDetailsBottombar extends StatefulWidget {
  FirestoreShow firestoreShow;
  DocumentReference docRef;
  AppendedShowDetails showDetails;
  ShowDetailsBottombar({Key? key, required this.firestoreShow, required this.docRef, required this.showDetails}) : super(key: key);

  @override
  State<ShowDetailsBottombar> createState() => _ShowDetailsBottombarState();
}

class _ShowDetailsBottombarState extends State<ShowDetailsBottombar> {
  void handleList() {
    final ref = FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser!.uid).doc("Tracking");
    bool newListed = !widget.firestoreShow.listed!;
    widget.firestoreShow.listed = newListed;
    !newListed && widget.firestoreShow.watchedLength! < 1 ? widget.docRef.delete() : widget.docRef.set(widget.firestoreShow.toJson());
    ref.get().then((snapshot) {
      Map<String, dynamic> tracking = snapshot.data() ?? {};
      if (!tracking.containsKey(widget.docRef.id.toString()) && newListed) {
        tracking[widget.docRef.id.toString()] = widget.showDetails.showDetails!.name!;
      }

      if (!newListed) tracking.remove(widget.docRef.id);
      ref.set(tracking);
    });
  }

  void handleWatched() {
    FirestoreShow newFirestoreShow = widget.firestoreShow;
    newFirestoreShow.completed = !newFirestoreShow.completed!;
    newFirestoreShow.watched = [];
    widget.docRef.set(newFirestoreShow.toJson());
  }

  @override
  Widget build(BuildContext context) {
    bool watched = widget.firestoreShow.completed == true || widget.firestoreShow.watched!.isNotEmpty ? true : false;
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: () => handleList(),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              color: widget.firestoreShow.listed ?? false ? Colors.red : Colors.green,
              height: 50.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 150),
                    transitionBuilder: (child, anim) => RotationTransition(
                      turns: child.key == const ValueKey('icon1')
                          ? Tween<double>(begin: 1, end: 0.75).animate(anim)
                          : Tween<double>(begin: 0.75, end: 1).animate(anim),
                      child: ScaleTransition(scale: anim, child: child),
                    ),
                    child: widget.firestoreShow.listed!
                        ? Icon(
                            Icons.close,
                            key: const ValueKey('icon1'),
                            size: watched ? 20.sp : 20.sp,
                            color: const Color.fromARGB(255, 26, 25, 25),
                          )
                        : Icon(
                            Icons.add,
                            key: const ValueKey('icon2'),
                            size: watched ? 20.sp : 20.sp,
                            color: const Color.fromARGB(255, 26, 25, 25),
                          ),
                  ),
                  Flexible(
                    child: Text(
                      widget.firestoreShow.listed ?? false
                          ? AppLocalizations.of(context)!.showNotTracked
                          : AppLocalizations.of(context)!.showsTracked,
                      style: GoogleFonts.roboto(
                        fontSize: watched ? 18.sp : 18.sp,
                        color: const Color.fromARGB(255, 26, 25, 25),
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
