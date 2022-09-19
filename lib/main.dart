import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tv_tracker/constants/app_constants.dart';
import 'package:tv_tracker/screens/auth/sign_in.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 851),
      minTextAdapt: true,
      builder: (context, child) => MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate, // Add this line
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          // English, no country code
          Locale('ar'), // Spanish, no country code
          Locale('de'), // Spanish, no country code
          Locale('en'), // Spanish, no country code
          Locale('es'), // Spanish, no country code
          Locale('fr'), // Spanish, no country code
          Locale('ru'), // Spanish, no country code
        ],
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          splashFactory: NoSplash.splashFactory,
          colorScheme: ThemeData.dark().colorScheme.copyWith(
                secondary: Colors.greenAccent,
              ),
        ),
        home: const RootPage(),
      ),
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

var _currentIndex = 2;

class _RootPageState extends State<RootPage> {
  final _pageController = PageController(initialPage: _currentIndex);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: ((context, snapshot) {
          if (!snapshot.hasData) _currentIndex = 2;
          return snapshot.hasData
              ? Scaffold(
                  body: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: pages,
                  ),
                  bottomNavigationBar: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.greenAccent, width: 2),
                      ),
                    ),
                    child: BottomNavigationBar(
                      items: [
                        BottomNavigationBarItem(
                          icon: const Icon(Icons.live_tv, color: Colors.white30),
                          label: AppLocalizations.of(context)!.shows,
                          activeIcon: const Icon(Icons.live_tv, color: Colors.greenAccent),
                        ),
                        BottomNavigationBarItem(
                          icon: const Icon(Icons.movie, color: Colors.white30),
                          label: AppLocalizations.of(context)!.movies,
                          activeIcon: const Icon(Icons.movie, color: Colors.greenAccent),
                        ),
                        BottomNavigationBarItem(
                          icon: const Icon(Icons.search, color: Colors.white30),
                          label: AppLocalizations.of(context)!.discover,
                          activeIcon: const Icon(Icons.search, color: Colors.greenAccent),
                        ),
                        BottomNavigationBarItem(
                          icon: const Icon(Icons.person, color: Colors.white30),
                          label: AppLocalizations.of(context)!.profile,
                          activeIcon: const Icon(Icons.person, color: Colors.greenAccent),
                        ),
                      ],
                      onTap: (int index) {
                        setState(() {
                          _currentIndex = index;
                          _pageController.jumpToPage(index);
                        });
                      },
                      unselectedLabelStyle: GoogleFonts.roboto(fontWeight: FontWeight.w500),
                      selectedLabelStyle: GoogleFonts.roboto(fontWeight: FontWeight.w500),
                      currentIndex: _currentIndex,
                      fixedColor: Colors.greenAccent,
                      type: BottomNavigationBarType.fixed,
                      iconSize: 24.h,
                      selectedFontSize: 15.h,
                      unselectedFontSize: 15.h,
                      backgroundColor: const Color.fromARGB(255, 26, 25, 25),
                    ),
                  ),
                )
              : const Scaffold(
                  body: SignIn(),
                );
        }));
  }
}
