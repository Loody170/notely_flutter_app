import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notely_flutter_app/screens/sign_in_screen.dart';
import 'package:notely_flutter_app/screens/sign_up_screen.dart';
import 'package:notely_flutter_app/widgets/red_button.dart';
import 'package:notely_flutter_app/widgets/red_text_button.dart';

class WelcomeScreen extends HookWidget {
  const WelcomeScreen({super.key});

  final List<String> subtexts = const [
      "Notely is the world’s safest, largest and intelligent digital notebook. Join over 10M+ users already using Notely.",
      "Organize your thoughts and tasks effortlessly with Notely. See why millions trust us for their note-taking needs.",
      "Sync your notes across all devices with Notely. Join millions who have upgraded to smarter note-taking."
    ];

  @override
  Widget build(BuildContext context) {
    final PageController pageController = usePageController();
    final currentSlide = useState(0);

    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'NOTELY',
          style: GoogleFonts.titanOne(color: const Color.fromRGBO(64, 59, 54, 1) ),
        ),
        toolbarHeight: 100,
      ),
      body: Center(
        child: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/Group821.png",
                height: 197,
                width: 268,
              ),
              const SizedBox(height: 20),
              Text(
                "World’s Safest And \nLargest Digital Notebook",
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w900,
                    fontSize: 24,
                    color: const Color.fromRGBO(64, 59, 54, 1)),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 100,
                child: PageView.builder(
                  controller: pageController,
                  onPageChanged: (page) {
                    currentSlide.value = page; // Update state using useState
                  },
                  itemCount: subtexts.length,
                  itemBuilder: (context, index) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          subtexts[index],
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: const Color.fromRGBO(89, 85, 80, 1)),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(subtexts.length, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    width: currentSlide.value == index ? 10.0 : 8.0,
                    height: currentSlide.value == index ? 10.0 : 8.0,
                    decoration: BoxDecoration(
                      color: currentSlide.value == index
                          ? const Color.fromRGBO(232, 80, 91, 1)
                          : const Color.fromRGBO(232, 80, 91, 0.5),
                      borderRadius: currentSlide.value == index
                          ? BorderRadius.circular(3.0)
                          : BorderRadius.circular(2.0),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 80),
              RedElevatedButton(
                  buttonText: "GET STARTED",
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignUpScreen()));
                  }),
              const SizedBox(height: 10),
              RedTextButton(
                  text: "Already have an account?",
                  fontSize: 20,
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignInScreen()))),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
