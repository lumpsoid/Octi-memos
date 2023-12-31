import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/db_helper.dart';
import 'src/note.dart';
import 'src/note_card.dart';
import 'src/note_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NoteManager>(
      create: (context) => NoteManager(DbHelper()),
      child: MaterialApp(
        title: 'Simple Memos',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green[50]!),
          useMaterial3: true,
        ),
        home: MemosScreen(),
      ),
    );
  }
}

class MemosScreen extends StatelessWidget {
  final TextEditingController _noteController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  MemosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memos'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Selector<NoteManager, int?>(
                selector: (context, manager) => manager.itemCount,
                builder: (context, itemCount, child) => ListView.builder(
                  itemCount: itemCount,
                  itemBuilder: (context, index) {
                    NoteManager manager = Provider.of<NoteManager>(context);
                    final note = manager.getByIndex(index);

                    if (note.isLoading) {
                      return const NoteCardLoading();
                    } else {
                      return NoteCard(note: note, index: index);
                    }
                  },
                ),
              ),
            ),
            Container(
              color: Colors.green[50],
              child: Selector<NoteManager, int?>(
                  selector: (context, manager) => manager.editingIndex,
                  builder: (context, editingIndex, child) {
                    if (editingIndex == null) {
                      return _buildingBasedTextInput(context);
                    } else {
                      return _buildingEditingTextInput(context, editingIndex);
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  TextFormField _buildingBasedTextInput(BuildContext context) {
    return TextFormField(
      controller: _noteController,
      maxLines: null,
      // Add your input field properties and functionality here
      decoration: InputDecoration(
        hintText: 'Enter your note...',
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
            onPressed: () async {
              String body = _noteController.text;
              if (body.isNotEmpty) {
                NoteManager manager = context.read<NoteManager>();
                await manager.addNote(body);
                _noteController.clear();
              }
            },
            icon: const Icon(Icons.send)),
      ),
    );
  }

  TextFormField _buildingEditingTextInput(BuildContext context, int index) {
    NoteManager manager = context.read<NoteManager>();
    Note note = manager.getByIndex(index);
    _noteController.text = note.body!;

    // Force keyboard to open when the state changes
    Future.delayed(
        Duration.zero, () => FocusScope.of(context).requestFocus(focusNode));

    return TextFormField(
      controller: _noteController,
      maxLines: null,
      focusNode: focusNode,
      // Add your input field properties and functionality here
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
            onPressed: () async {
              String newBody = _noteController.text;
              if (newBody.isNotEmpty) {
                await manager.editNote(note, newBody);
                _noteController.clear();
                manager.stopEditing();
              }
            },
            icon: const Icon(Icons.send)),
      ),
    );
  }
}
