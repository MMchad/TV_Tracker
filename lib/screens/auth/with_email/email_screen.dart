import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:tv_tracker/screens/auth/with_email/password_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmailScreen extends StatefulWidget {
  const EmailScreen({super.key});

  @override
  State<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  final formKey = GlobalKey<FormState>();
  bool isChecking = false;
  bool isNotValid = false;
  var email = "";

  String? validateEmail(String password) {
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)
        ? null
        : AppLocalizations.of(context)!.invalidEmail;
  }

  Future<bool> checkIfEmailExists(String emailAddress) async {
    try {
      final list = await FirebaseAuth.instance.fetchSignInMethodsForEmail(emailAddress);

      if (list.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      log(error.toString());
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: const Color.fromARGB(255, 26, 25, 25),
        child: Padding(
          padding: EdgeInsets.only(
            left: 35.h,
            right: 35.h,
            top: 50.h,
          ),
          child: Form(
            key: formKey,
            child: Theme(
              data: Theme.of(context).copyWith(
                splashFactory: NoSplash.splashFactory,
                colorScheme: ThemeData.dark().colorScheme.copyWith(
                      primary: Colors.greenAccent,
                    ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Text(
                        AppLocalizations.of(context)!.enterEmail,
                        style: GoogleFonts.roboto(fontSize: 22.sp, fontWeight: FontWeight.bold),
                      )),
                    ],
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          textAlignVertical: TextAlignVertical.center,
                          onChanged: (value) => email = value,
                          validator: (value) => validateEmail(value ?? ""),
                          style: GoogleFonts.roboto(fontSize: 18.sp, fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            errorStyle: GoogleFonts.roboto(fontSize: 14.sp),
                            prefixIcon: Icon(
                              Icons.email,
                              size: 25.sp,
                              color: isNotValid ? Colors.red : Colors.greenAccent,
                            ),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.greenAccent),
                            ),
                            errorBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent),
                            ),
                            focusedErrorBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent),
                            ),
                            hintText: AppLocalizations.of(context)!.email,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  SizedBox(
                    width: 100.h,
                    child: TextButton(
                      style: ButtonStyle(
                        overlayColor: MaterialStateColor.resolveWith((states) => Colors.transparent),
                      ),
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          setState(() {
                            isNotValid = false;
                            isChecking = true;
                          });
                          checkIfEmailExists(email).then(
                            (emailExists) {
                              setState(() {
                                isChecking = false;
                              });
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: ((context) => PasswordScreen(
                                        emailExists: emailExists,
                                        email: email,
                                      )),
                                ),
                              );
                            },
                          );
                        } else {
                          setState(() {
                            isNotValid = true;
                          });
                        }
                      },
                      child: Text(
                        AppLocalizations.of(context)!.next,
                        style: GoogleFonts.roboto(fontSize: 20.sp, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  SizedBox(
                    height: 25.h,
                    width: 25.h,
                    child: CircularProgressIndicator(
                      color: isChecking ? Colors.greenAccent : Colors.transparent,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
