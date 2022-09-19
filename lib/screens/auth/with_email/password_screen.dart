import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:tv_tracker/screens/auth/with_email/password_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PasswordScreen extends StatefulWidget {
  const PasswordScreen({super.key, required this.emailExists, required this.email});
  final bool emailExists;
  final String email;
  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final formKey = GlobalKey<FormState>();
  bool isChecking = false;
  bool isNotValid = false;
  String password = "";
  String? errorMsg;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 26, 25, 25),
        leading: IconButton(
          onPressed: () => Navigator.pop(context, null),
          icon: Icon(
            Icons.arrow_back_ios,
            size: 25.sp,
            color: Colors.greenAccent,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          color: const Color.fromARGB(255, 26, 25, 25),
          child: Padding(
            padding: EdgeInsets.only(
              left: 35.h,
              right: 35.h,
              top: 25.h,
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
                            widget.emailExists ? AppLocalizations.of(context)!.enterPassword : AppLocalizations.of(context)!.createPassword,
                            style: GoogleFonts.roboto(fontSize: 22.sp, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.email,
                            style: GoogleFonts.roboto(fontSize: 18.sp, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            obscureText: true,
                            textAlignVertical: TextAlignVertical.center,
                            onChanged: (value) => password = value,
                            validator: (value) => validatePassword(value ?? ""),
                            style: GoogleFonts.roboto(fontSize: 18.sp, fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                              errorText: errorMsg,
                              errorStyle: GoogleFonts.roboto(fontSize: 14.sp),
                              prefixIcon: Icon(
                                Icons.lock_outline,
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
                              hintText: AppLocalizations.of(context)!.password,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    SizedBox(
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
                            if (widget.emailExists) {
                              signUserIn();
                            } else {
                              FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(email: widget.email, password: password)
                                  .then((value) => Navigator.pop(context));
                            }
                          } else {
                            setState(() {
                              isNotValid = true;
                            });
                          }
                        },
                        child: Text(
                          widget.emailExists ? AppLocalizations.of(context)!.signin : AppLocalizations.of(context)!.createAccount,
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
      ),
    );
  }

  String? validatePassword(String password) {
    return password.length >= 6 ? null : AppLocalizations.of(context)!.invalidPassword;
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

  void signUserIn() async {
    setState(() {
      errorMsg = null;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: widget.email, password: password).then((value) => Navigator.pop(context));
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "wrong-password":
          setState(() {
            isNotValid = true;
            isChecking = false;
            errorMsg = "Wrong password";
          });
          break;
        case "user-disabled":
          setState(() {
            isNotValid = true;
            isChecking = false;
            errorMsg = "This account has been disabled";
          });
          break;
        case "too-many-requests":
          setState(() {
            isNotValid = true;
            isChecking = false;
            errorMsg = "Too many attempts. Try again later";
          });
      }
    }
  }
}
