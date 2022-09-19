import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tv_tracker/models/firestore_movie_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MovieDetailsBottombar extends StatefulWidget {
  FirestoreMovie movie;
  DocumentReference docRef;
  MovieDetailsBottombar({Key? key, required this.movie, required this.docRef}) : super(key: key);

  @override
  State<MovieDetailsBottombar> createState() => _MovieDetailsBottombarState();
}

class _MovieDetailsBottombarState extends State<MovieDetailsBottombar> {
  void handleList() {
    widget.movie.listed = !widget.movie.listed!;
    if (widget.movie.listed == false && widget.movie.watched == false) {
      widget.docRef.delete();
      return;
    }
    widget.docRef.set(widget.movie.toJson());
  }

  void handleWatched() {
    widget.movie.watched = !widget.movie.watched!;
    if (widget.movie.listed == false && widget.movie.watched == false) {
      widget.docRef.delete();
      return;
    }
    widget.docRef.set(widget.movie.toJson());
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: () => handleList(),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              color: widget.movie.listed ?? false ? Colors.red : Colors.green,
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
                      child: widget.movie.listed!
                          ? Icon(
                              Icons.close,
                              key: const ValueKey('icon1'),
                              size: 22.sp,
                              color: const Color.fromARGB(255, 26, 25, 25),
                            )
                          : Icon(
                              Icons.add,
                              key: const ValueKey('icon2'),
                              size: 22.sp,
                              color: const Color.fromARGB(255, 26, 25, 25),
                            )),
                  Flexible(
                    child: Text(
                      widget.movie.listed ?? false
                          ? " ${AppLocalizations.of(context)!.removeFromList}"
                          : " ${AppLocalizations.of(context)!.addToList}",
                      style: GoogleFonts.roboto(
                        fontSize: 15.sp,
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
        VerticalDivider(
          width: 1.h,
          thickness: 1.h,
          color: const Color.fromARGB(255, 26, 25, 25),
        ),
        Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: () => handleWatched(),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              color: widget.movie.watched ?? false ? Colors.red : Colors.green,
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
                      child: widget.movie.watched!
                          ? Icon(
                              Icons.close,
                              key: const ValueKey('icon1'),
                              size: 22.sp,
                              color: const Color.fromARGB(255, 26, 25, 25),
                            )
                          : Icon(
                              Icons.add,
                              key: const ValueKey('icon2'),
                              size: 22.sp,
                              color: const Color.fromARGB(255, 26, 25, 25),
                            )),
                  Flexible(
                    child: Text(
                      widget.movie.watched ?? false
                          ? " ${AppLocalizations.of(context)!.removeFromWatched}"
                          : " ${AppLocalizations.of(context)!.addToWatched}",
                      style: GoogleFonts.roboto(
                        fontSize: 15.sp,
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
