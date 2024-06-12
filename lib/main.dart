import 'package:flutter/material.dart';
import "./screens/welcome_screen.dart";
import "./screens/notes_home_screen.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logging/logging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


void main()async {
    await dotenv.load(fileName: ".env"); 
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
     MyApp({super.key});

  final Logger _logger = Logger('MainLogger');


  Future<bool> checkAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('user_id');
    if (id != null) {
      return true;
    } else {
      return false;
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Color whiteColor = const Color.fromRGBO(255, 255, 255, 1);
    Future<bool> isAuthenticated = checkAuth();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notely',
      theme: ThemeData(  
        appBarTheme: AppBarTheme(
          backgroundColor: whiteColor,
        ),
        colorScheme:
            ColorScheme.fromSeed(seedColor: whiteColor),
        useMaterial3: true,
        scaffoldBackgroundColor: whiteColor,
      ),
      home: FutureBuilder<bool>(
        future: isAuthenticated,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          _logger.info("Checking auth status...");
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: Color.fromRGBO(232, 80, 91, 1),
            )); 
          } else if (snapshot.hasData && snapshot.data == true) {
            // isAuthenticated is true
            _logger.info("User is authenticated");
            return NotesHomeScreen();
          } else {
            // isAuthenticated is false
            _logger.info("User is not authenticated");
            return const WelcomeScreen();
          }
        },
      ),
    );
  }
}
