import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greentrack/Screens/Welcome/welcome_screen.dart';
import 'package:greentrack/constants.dart';
import 'package:greentrack/services/user_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Screens/main/main_screen.dart';
import 'controllers/MenuAppController.dart';
import 'firebase_options.dart';


User? userData = FirebaseAuth.instance.currentUser;
var c = 54;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  // var data = await UserService().getAllUsers();
  // List<String> userStrings = data.map((user) => {
  //   "username": user.username,
  // "phone": user.phone,
  // "email": user.email,
  // "role":user.role,
  // "id":user.id}.toString()).toList();
  //
  // prefs.setStringList("users", userStrings);

  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyAqkSFps5dSjsns_TVtpec72awMwD7szXE",
        authDomain: "green-track-729ca.firebaseapp.com",
        projectId: "green-track-729ca",
        storageBucket: "green-track-729ca.appspot.com",
        messagingSenderId: "917019747278",
        appId: "1:917019747278:web:f4bdb07ad3cdf0b5f4c19f")
  );
  runApp(const MyApp());
}

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
        // theme: ThemeData.light().copyWith(
        //   scaffoldBackgroundColor: bgColor,
        //   textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
        //       .apply(bodyColor: Colors.white),
        //   canvasColor: secondaryColor,
        // ),
        home: userData == null ?WelcomeScreen(): MainScreen(),
      ),
    );
    ;
    
  }
}
