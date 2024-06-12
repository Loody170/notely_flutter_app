import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notely_flutter_app/screens/welcome_screen.dart';
import 'package:notely_flutter_app/supabase_client.dart';
import "../user_util.dart";
import 'package:flutter_animate/flutter_animate.dart';

class EditNoteScreen extends HookWidget {
  final String id;
  final String? title;
  final String? text;
  final String? userId;
  final Color? color;

  const EditNoteScreen({
    super.key,
    this.id = "",
    this.title,
    this.text,
    this.userId,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final titleController = useTextEditingController(text: title);
    final textController = useTextEditingController(text: text);
    final supabaseClient = useMemoized(() => SupabaseClient(), []);

    String colorToString(Color color) {
      return "${color.red}, ${color.green}, ${color.blue}, ${color.opacity}";
    }

    Future<bool> createNote() async {
      final title = titleController.text;
      final text = textController.text;
      final color = colorToString(this.color!);
      return supabaseClient.insertNote(
        'notes',
        title,
        text,
        userId!,
        color,
      );
    }

    Future<bool> updateNote() async {
      final title = titleController.text;
      final text = textController.text;
      return supabaseClient.updateNote(
        'notes',
        id,
        title,
        text,
        userId!,
      );
    }

    Future<bool> deleteNote() async {
      return supabaseClient.deleteNote('notes', id);
    }

    return Scaffold(
      backgroundColor: color,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          id.isEmpty ? 'Create Note' : 'Edit Note',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 16.03,
          ),
        ),
        backgroundColor: color,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 28,
          ),
          onPressed: () async {
            if (id.isEmpty) {
              if (titleController.text.isEmpty && textController.text.isEmpty) {
                Navigator.pop(context, false);
              } else {
                final value = await createNote();
                if (context.mounted) {
                  Navigator.pop(context, value);
                }
              }
            } else {
              // Check if the note content has been updated
              if (titleController.text == title &&
                  textController.text == text) {
                Navigator.pop(context, false);
              } else {
                // Updates detected, proceed with update
                final value = await updateNote();
                if (context.mounted) {
                  Navigator.pop(context, value);
                }
              }
            }
          },
        ),
        actions: <Widget>[
          PopupMenuButton(
            icon: const Icon(
              Icons.more_vert,
              size: 40,
            ),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'sign_out',
                child: Text('Sign Out'),
              ),
              const PopupMenuItem<String>(
                value: 'delete_note',
                child: Text('Delete Note'),
              ),
            ],
            onSelected: (String value) async {
              if (value == 'sign_out') {
                signOutUser();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const WelcomeScreen()));
              } else if (value == 'delete_note') {
                final result = await deleteNote();
                if(context.mounted){
                Navigator.pop(context, result);
                }
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              style: GoogleFonts.inter(
                color: const Color.fromRGBO(100, 100, 100, 1),
                fontSize: 30.75,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'Title',
                border: InputBorder.none,
                hintStyle: GoogleFonts.inter(
                  fontSize: 30.75,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              child: TextField(
                controller: textController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                style: GoogleFonts.poppins(
                  color: const Color.fromRGBO(129, 129, 129, 1),
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 40.0),
                  hintText: 'Start writing...',
                  border: InputBorder.none,
                  hintStyle: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fade(
          duration: 350.ms,
        );
  }
}
