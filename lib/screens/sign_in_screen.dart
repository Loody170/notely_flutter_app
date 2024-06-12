
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notely_flutter_app/widgets/red_button.dart';
import 'package:notely_flutter_app/widgets/red_text_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:notely_flutter_app/screens/notes_home_screen.dart';
import 'package:notely_flutter_app/screens/sign_up_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import '../user_util.dart';
import 'package:flutter_animate/flutter_animate.dart'; 

class SignInScreen extends HookWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    void showToast(String message, Color color) {
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          backgroundColor: color,
          textColor: Colors.white,
          fontSize: 16.0);
    }

    void signIn() async {
      try {
        var result = await signInUserHTTP(emailController.text, passwordController.text);
        if (result.isNotEmpty) {
          showToast("Signed in successfully!", Colors.green);

          // Clear the text fields
          emailController.clear();
          passwordController.clear();

          // Save user details to shared preferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('access_token', result['access_token']);
          await prefs.setString('user_id', result['user_id']);

          // Navigate to Notes home screen
          if(context.mounted){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NotesHomeScreen()));
          }
        } else {
          showToast("Sign in failed", Colors.red);
        }
      } catch (e) {
        showToast("Sign in failed", Colors.red);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign In"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              Padding(
                padding: const EdgeInsets.only(bottom: 65),
                child: Text('NOTELY', style: GoogleFonts.titanOne(fontSize: 50)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(labelText: "Email"),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: passwordController,
                        decoration: const InputDecoration(labelText: "Password"),
                        obscureText: true,
                      ),
                      const SizedBox(height: 50),
                      RedElevatedButton(buttonText: "Sign in", onPressed: signIn),
                      RedTextButton(text: "Don't have an account? Register here", fontSize: 14,
                       onPressed: ()=> Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignUpScreen()))
                       ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().slideX(duration: 250.ms, begin:-1 );
  }
}
