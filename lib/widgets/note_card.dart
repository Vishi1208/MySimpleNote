import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/note.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback onArchive;

  NoteCard({
    Key? key,
    required this.note,
    required this.onTap,
    required this.onDelete,
    required this.onEdit,
    required this.onArchive,
  }) : super(key: key);

  final List<String> _categories = [
    'Default',
    'Urgent',
    'Work',
    'Personal',
    'Important',
  ];

  final List<Color> _categoryColors = [
    Colors.grey,
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Chip(
                  label: Text(
                    _categories[getCategoryIndex(note.color)],
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                  backgroundColor: _categoryColors[getCategoryIndex(note.color)],
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                ),
              ),
              SizedBox(height: 3),
              Text(
                note.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.teal[900],
                ),
              ),
              SizedBox(height: 5),
              Text(
                note.content,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 12,
                ),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildActionIcon(
                    icon: FontAwesomeIcons.penToSquare,
                    tooltip: 'Edit Note',
                    onPressed: onEdit,
                    color: Colors.blueAccent,
                  ),
                  SizedBox(width: 10),
                  _buildActionIcon(
                    icon: FontAwesomeIcons.trash,
                    tooltip: 'Delete Note',
                    onPressed: onDelete,
                    color: Colors.redAccent,
                  ),
                  SizedBox(width: 10),
                  _buildActionIcon(
                    icon: note.isArchived
                        ? FontAwesomeIcons.boxOpen
                        : FontAwesomeIcons.boxArchive,
                    tooltip: note.isArchived ? 'Unarchive Note' : 'Archive Note',
                    onPressed: onArchive,
                    color: Colors.grey,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionIcon({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: FaIcon(
          icon,
          color: color,
          size: 22,
        ),
      ),
    );
  }

  int getCategoryIndex(int colorValue) {
    return (colorValue >= 0 && colorValue < _categoryColors.length)
        ? colorValue
        : 0;
  }
}
