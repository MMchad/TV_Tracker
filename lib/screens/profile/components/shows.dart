import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tv_tracker/screens/profile/components/tracked_shows.dart';
import 'package:tv_tracker/screens/profile/components/watched_movies.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileShows extends StatelessWidget {
  const ProfileShows({super.key});

  @override
  Widget build(BuildContext context) {
    final ref = FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser!.uid);
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
          AppLocalizations.of(context)!.shows,
          style: GoogleFonts.roboto(fontSize: 22.sp, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 15.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 23.h,
                    child: OutlinedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 43, 42, 42)),
                        side: MaterialStateProperty.all(
                          BorderSide(color: Colors.transparent, width: 2.h),
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.h),
                          ),
                        ),
                      ),
                      onPressed: null,
                      child: Text(
                        AppLocalizations.of(context)!.haventStarted,
                        style: GoogleFonts.roboto(fontSize: 15.sp, fontWeight: FontWeight.bold, color: Colors.greenAccent),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15.h,
              ),
              ProfileTrackedShows(
                filters: ref.where("Type", isEqualTo: "Show").where("Listed", isEqualTo: true).where("Watched Length", isEqualTo: 0).snapshots(),
                hasStarted: false,
              ),
              SizedBox(
                height: 15.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 23.h,
                    child: OutlinedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 43, 42, 42)),
                        side: MaterialStateProperty.all(
                          BorderSide(color: Colors.transparent, width: 2.h),
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.h),
                          ),
                        ),
                      ),
                      onPressed: null,
                      child: Text(
                        AppLocalizations.of(context)!.tracking,
                        style: GoogleFonts.roboto(fontSize: 15.sp, fontWeight: FontWeight.bold, color: Colors.greenAccent),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15.h,
              ),
              ProfileTrackedShows(
                filters: ref.where("Type", isEqualTo: "Show").where("Listed", isEqualTo: true).where("Completed", isEqualTo: false).snapshots(),
                hasStarted: true,
              ),
              SizedBox(
                height: 15.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 23.h,
                    child: OutlinedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 43, 42, 42)),
                        side: MaterialStateProperty.all(
                          BorderSide(color: Colors.transparent, width: 2.h),
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.h),
                          ),
                        ),
                      ),
                      onPressed: null,
                      child: Text(
                        AppLocalizations.of(context)!.notTracking,
                        style: GoogleFonts.roboto(fontSize: 15.sp, fontWeight: FontWeight.bold, color: Colors.greenAccent),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15.h,
              ),
              ProfileTrackedShows(
                filters: ref.where("Type", isEqualTo: "Show").where("Listed", isEqualTo: false).where("Completed", isEqualTo: false).snapshots(),
                hasStarted: true,
              ),
              SizedBox(
                height: 15.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 23.h,
                    child: OutlinedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 43, 42, 42)),
                        side: MaterialStateProperty.all(
                          BorderSide(color: Colors.transparent, width: 2.h),
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.h),
                          ),
                        ),
                      ),
                      onPressed: null,
                      child: Text(
                        AppLocalizations.of(context)!.finished,
                        style: GoogleFonts.roboto(fontSize: 15.sp, fontWeight: FontWeight.bold, color: Colors.greenAccent),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15.h,
              ),
              ProfileTrackedShows(
                filters: ref.where("Type", isEqualTo: "Show").where("Completed", isEqualTo: true).snapshots(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
