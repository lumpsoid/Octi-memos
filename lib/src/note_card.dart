import 'package:provider/provider.dart';
import 'note_manager.dart';

import 'note.dart' show Note;
import 'package:flutter/material.dart';

class NoteCard extends StatefulWidget {
  final int index;
  final Note note;
  final int id;

  NoteCard({required this.note, required this.index, super.key}) : id = note.id;

  @override
  NoteCardState createState() => NoteCardState();
}

class NoteCardState extends State<NoteCard> {
  late TextEditingController _controller;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.note.body);
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        // drag to the right (edit)
        background: Container(
          color: Colors.blue[50],
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 30.0),
          child: const Icon(Icons.edit_outlined),
        ),
        // drag to the left (delete)
        secondaryBackground: Container(
          color: Colors.red[50],
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 30.0),
          child: const Icon(Icons.delete_outline),
        ),
        confirmDismiss: (DismissDirection direction) async {
          if (direction == DismissDirection.startToEnd) {
            setState(() {
              _isEditing = true;
            });
            return false;
          }
          // delete
          if (direction == DismissDirection.endToStart) {
            return true;
          }
          return false;
        },
        onDismissed: (DismissDirection direction) async {
          String action = '';
          NoteManager manager =
              Provider.of<NoteManager>(context, listen: false);
          // edit
          // if (direction == DismissDirection.startToEnd) {
          //   action = 'edited';
          //   await manager.editNote(index, 'ITSWORKED');
          // }
          // delete
          if (direction == DismissDirection.endToStart) {
            await manager.deleteNote(widget.index);
            action = 'deleted';
          }
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Memo was $action",
                style: const TextStyle(fontSize: 16.0)),
            duration: const Duration(seconds: 2),
          ));
        },
        key: Key(widget.id.toString()),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          child: _isEditing
              ? TextField(
                  controller: _controller,
                  autofocus: true,
                  maxLines: null,
                  onTapOutside: (event) {
                    _onSubmit(context, _controller.text);
                  },
                  style: const TextStyle(fontSize: 16.0),
                )
              : Text(
                  widget.note.body,
                  style: const TextStyle(fontSize: 16.0),
                ),
        ));
  }

  Future<void> _onSubmit(BuildContext context, newValue) async {
    if (newValue.isNotEmpty) {
      await Provider.of<NoteManager>(context, listen: false)
          .editNote(widget.index, newValue);
    }

    setState(() {
      _isEditing = false;
    });
  }

  Future<void> _showEditDialog(BuildContext context, int index) async {
    final NoteManager manager =
        Provider.of<NoteManager>(context, listen: false);
    Note note = manager.getByIndex(index);
    String newBody = '';

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Item'),
          content: TextFormField(
            initialValue: note.body,
            onChanged: (value) {
              newBody = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (newBody.isNotEmpty) {
                  // Update the item in the list
                  await manager.editNote(index, newBody);
                }
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}

class CardTest extends StatelessWidget {
  const CardTest({
    super.key,
    required this.note,
  });

  final Note note;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        child: Text(
          note.body,
          style: const TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}

class NoteCardLoading extends StatelessWidget {
  const NoteCardLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      margin: EdgeInsets.all(16.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          '...',
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}
