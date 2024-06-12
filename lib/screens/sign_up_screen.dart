import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:notely_flutter_app/screens/sign_in_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notely_flutter_app/widgets/red_button.dart';
import 'package:notely_flutter_app/widgets/red_text_button.dart';
import "../supabase_client.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logging/logging.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SignUpScreen extends HookWidget {
  final Logger _logger = Logger('SignUpScreenLogger');

  SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final email = useState('');
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();

    //we use useMemoized to ensure that the SupabaseClient is only created once
    final supabaseClient = useMemoized(() => SupabaseClient());

    void showToast(String message, Color color) {
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: color,
          textColor: Colors.white,
          fontSize: 16.0);
    }

    Future<void> signUpUser() async {
      try {
        final value = await supabaseClient.signUpUser(
            email.value, passwordController.text);
        if (value != null) {
          _logger.info('Sign up successful');

          email.value = '';
          passwordController.clear();
          confirmPasswordController.clear();

          showToast("Signed up successfully!", Colors.green);

          // Navigate to Notes home screen
          if (context.mounted) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const SignInScreen()));
          }
        } else {
          _logger.info('Sign up failed');
          showToast("Sign up failed. Please try again.", Colors.red);
        }
      } catch (e) {
        _logger.info('Sign up error: $e');
        showToast("Sign up failed. Please try again.", Colors.red);
      }
    }

    void trySubmitForm() {
      final isValid = formKey.currentState?.validate();
      if (isValid == true) {
        _logger.info('Form is valid');

        formKey.currentState?.save();
        signUpUser();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create an account'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 80,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 65),
                child: Text(
                  'NOTELY',
                  style: GoogleFonts.titanOne(fontSize: 50),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: formKey,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          key: const ValueKey('email'),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                !value.contains('@')) {
                              return 'Please enter a valid email address.';
                            }
                            return null;
                          },
                          onSaved: (value) => email.value = value!,
                          decoration:
                              const InputDecoration(labelText: 'Email Address'),
                        ),
                        TextFormField(
                          key: const ValueKey('password'),
                          controller: passwordController,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.length < 7) {
                              return 'Password must be at least 7 characters long.';
                            }
                            return null;
                          },
                          decoration:
                              const InputDecoration(labelText: 'Password'),
                          obscureText: true,
                        ),
                        TextFormField(
                          key: const ValueKey('confirmPassword'),
                          controller: confirmPasswordController,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value != passwordController.text) {
                              return 'Passwords do not match.';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              labelText: 'Confirm Password'),
                          obscureText: true,
                        ),
                        const SizedBox(height: 50),
                        RedElevatedButton(
                            buttonText: "Sign Up", onPressed: trySubmitForm),
                        RedTextButton(
                            text: "Already have an account?",
                            fontSize: 16,
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SignInScreen())))
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().slideX(duration: 250.ms, begin: -1);
  }
}
