import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
      create: (context) => NoteManager(),
      child: MaterialApp(
        title: 'Simple Memos',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
        ),
        home: MemosScreen(),
      ),
    );
  }
}

class MemosScreen extends StatelessWidget {
  final TextEditingController _noteController = TextEditingController();

  MemosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memos'),
      ),
      body: SafeArea(
        child: Selector<NoteManager, int?>(
          selector: (context, manager) => manager.itemCount,
          builder: (context, itemCount, child) => ListView.builder(
            padding: const EdgeInsets.only(bottom: 64.0),
            itemCount: itemCount,
            itemBuilder: (context, index) {
              NoteManager manager = Provider.of<NoteManager>(context);
              final note = manager.getByIndex(index);

              // Use a different approach to create NoteCard based on note state
              if (note.isLoading) {
                return const NoteCardLoading();
              } else {
                return NoteCard(note: note, index: index);
              }
            },
          ),
        ),
      ),
      bottomSheet: TextFormField(
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
              icon: const Icon(Icons.arrow_circle_right)
          ),
        ),
      ),
    );
  }
}
