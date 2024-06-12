import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notely_flutter_app/screens/edit_note_screen.dart';
import 'package:notely_flutter_app/screens/sign_in_screen.dart';
import 'package:notely_flutter_app/supabase_client.dart';
import 'package:notely_flutter_app/widgets/notes_grid_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logging/logging.dart';
import 'package:flutter_animate/flutter_animate.dart';

class NotesHomeScreen extends HookWidget {
  NotesHomeScreen({super.key});
  final Logger _logger = Logger('NotesHomeScreenLogger');

  final List<Color> colors = const [
    Color.fromRGBO(197, 203, 255, 1),
    Color.fromRGBO(196, 255, 202, 1),
    Color.fromRGBO(251, 190, 207, 1),
    Color.fromRGBO(150, 244, 244, 1),
    Color.fromRGBO(253, 243, 191, 1),
    Color.fromRGBO(254, 197, 255, 1),
  ];

  Color stringToColor(String rgbaString) {
    List<String> parts = rgbaString.split(',');
    int r = int.parse(parts[0]);
    int g = int.parse(parts[1]);
    int b = int.parse(parts[2]);
    double opacity = double.parse(parts[3]);
    return Color.fromRGBO(r, g, b, opacity);
  }

  void navigateToSignIn(BuildContext context) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const SignInScreen()));
  }

  List<dynamic> filterNotes(List<dynamic> notes, String query) {
    return notes.where((note) {
      return note['title']
          .toString()
          .toLowerCase()
          .contains(query.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final userNotes = useState<List<dynamic>>([]);
    final filteredUserNotes = useState<List<dynamic>>([]);
    final userId = useState<String>("");
    final refreshNeeded = useState(false);
    final searchQuery = useState<String>("");

    Future<void> fetchNotes() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString('user_id');
      if (id != null) {
        userId.value = id;
        final notes = await SupabaseClient().fetchUserNote("notes", id);
        userNotes.value = notes;
      } else {
        if (context.mounted) {
          navigateToSignIn(context);
        }
      }
    }

    useEffect(() {
      fetchNotes();
      return null;
    }, []);

    useEffect(() {
      if (refreshNeeded.value) {
        _logger.info("Data refresh needed. Fetching notes...");
        fetchNotes();
        refreshNeeded.value = false;
      }
      return null;
    }, [refreshNeeded.value]);

    useEffect(() {
      Future<void> checkAuth() async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? id = prefs.getString('user_id');
        if (id != null) {
          userId.value = id;
        } else {
          if (context.mounted) {
            navigateToSignIn(context);
          }
        }
      }

      checkAuth();
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Recent Notes',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 16.03,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for notes',
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset('assets/searchnormal1.png'),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: const Color.fromRGBO(240, 240, 240, 1),
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  searchQuery.value = value;
                  _logger.info("Search query: $value");
                  filteredUserNotes.value = filterNotes(userNotes.value, value);
                } else {
                  _logger.info("Search query is empty");
                  searchQuery.value = "";
                }
              },
            ),
          ),
          Expanded(
              child: userNotes.value.isEmpty
                  ? const Center(child: Text("No notes found"))
                  : NotesGridView(
                      userNotes: searchQuery.value.isEmpty
                          ? userNotes
                          : filteredUserNotes,
                      onNoteEdit: () => refreshNeeded.value = true)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditNoteScreen(
                        color: colors[Random().nextInt(colors.length)],
                        title: '',
                        text: '',
                        userId: userId.value,
                      )));

          if (result) {
            refreshNeeded.value = true;
          }
        },
        backgroundColor: const Color.fromRGBO(232, 80, 91, 1),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        materialTapTargetSize: MaterialTapTargetSize.padded,
        child: 
        Image.asset(
          "assets/plus_positive.png",
          width: 26,
          height: 26,
        )
        // const Icon(
        //   Icons.add,
        //   size: 40,
          
        //   color: Colors.white,
        // ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    ).animate().slideX(duration: 400.ms, begin: -1);
  }
}
