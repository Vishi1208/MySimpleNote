import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/note.dart';
import '../services/database_helper.dart';
import 'note_edit_screen.dart';
import '../widgets/note_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DatabaseHelper _dbHelper;
  List<Note> _notes = [];
  bool _showArchived = false;

  @override
  void initState() {
    super.initState();
    _dbHelper = DatabaseHelper.instance;
    _refreshNotes();
  }

  Future<void> _refreshNotes() async {
    final data = _showArchived
        ? await _dbHelper.readArchivedNotes()
        : await _dbHelper.readAllNotes();
    setState(() {
      _notes = data;
    });
  }

  void _navigateToEditScreen(Note? note) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NoteEditScreen(note: note),
      ),
    );
    _refreshNotes();
  }

  void _showDeleteDialog(Note note) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Note', style: TextStyle(color: Colors.red)),
          content: Text('Are you sure you want to delete this note?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel', style: TextStyle(color: Colors.blueGrey)),
            ),
            TextButton(
              onPressed: () async {
                await _dbHelper.delete(note.id!);
                Navigator.of(context).pop();
                _refreshNotes();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Note deleted')),
                );
              },
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _showArchived ? 'Archived Notes' : 'Simple Note App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: FaIcon(_showArchived ? FontAwesomeIcons.boxOpen : FontAwesomeIcons.archive),
            onPressed: () {
              setState(() {
                _showArchived = !_showArchived;
                _refreshNotes();
              });
            },
            tooltip: _showArchived ? 'Show Active Notes' : 'Show Archived Notes',
          ),
        ],
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/background.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          _notes.isEmpty
              ? Center(
            child: Text(
              'No notes available',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
          )
              : Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                final note = _notes[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: NoteCard(
                    note: note,
                    onTap: () => _navigateToEditScreen(note),
                    onEdit: () => _navigateToEditScreen(note),
                    onDelete: () => _showDeleteDialog(note),
                    onArchive: () async {
                      await _dbHelper.archive(note, !note.isArchived);
                      _refreshNotes();
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToEditScreen(null),
        icon: FaIcon(FontAwesomeIcons.plus),
        label: Text('Add Note', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
