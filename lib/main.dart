import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greentrack/Screens/Welcome/welcome_screen.dart';
import 'package:greentrack/constants.dart';
import 'package:provider/provider.dart';

import 'Screens/main/main_screen.dart';
import 'controllers/MenuAppController.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MenuAppController(),
        ),
      ],
      child: MaterialApp(
        // Your app configuration
        debugShowCheckedModeBanner: false,
        title: 'GREEN TRACK',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: bgColor,
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
              .apply(bodyColor: Colors.white),
          canvasColor: secondaryColor,
        ),
        home: WelcomeScreen(),
      ),
    );
    ;
    
  }
}
