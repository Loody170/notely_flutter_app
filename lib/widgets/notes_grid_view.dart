import 'package:flutter/material.dart';
import 'package:notely_flutter_app/models/note.dart';
import 'package:notely_flutter_app/screens/edit_note_screen.dart';
import 'package:notely_flutter_app/widgets/note_block.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class NotesGridView extends StatelessWidget {
  final ValueNotifier<List<dynamic>> userNotes;
  final Function() onNoteEdit;

  const NotesGridView({
    super.key,
    required this.userNotes,
    required this.onNoteEdit,
  });

  Color stringToColor(String rgbaString) {
    List<String> parts = rgbaString.split(',');
    int r = int.parse(parts[0]);
    int g = int.parse(parts[1]);
    int b = int.parse(parts[2]);
    double opacity = double.parse(parts[3]);
    return Color.fromRGBO(r, g, b, opacity);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<dynamic>>(
      valueListenable: userNotes,
      builder: (context, notesList, child) {
        List<Note> notes =
            notesList.map((note) => Note.fromJSON(note)).toList();
        return StaggeredGridView.countBuilder(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          crossAxisCount: 2,
          crossAxisSpacing: 20.0,
          mainAxisSpacing: 20.0,
          itemCount: notes.length,
          itemBuilder: (context, index) {
            final Note note = notes[index];
            return GestureDetector(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditNoteScreen(
                      id: note.id,
                      userId: note.userId,
                      title: note.title,
                      text: note.content,
                      color: stringToColor(note.color),
                    ),
                  ),
                );
                if (result != null && result) {
                  onNoteEdit();
                }
              },
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: 150,
                  maxWidth: 150,
                  minHeight: 125,
                  maxHeight: 350,
                ),
                child: NoteBlock(
                  title: note.title,
                  text: note.content,
                  color: stringToColor(note.color),
                ),
              ),
            );
          },
          staggeredTileBuilder: (index) => const StaggeredTile.fit(1),
        );
      },
    );
  }
}
