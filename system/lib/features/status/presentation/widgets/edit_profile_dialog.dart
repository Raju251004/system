import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfileDialog extends StatefulWidget {
  final Map<String, dynamic> currentData;
  final Function(Map<String, dynamic>) onSave;

  const EditProfileDialog({
    super.key,
    required this.currentData,
    required this.onSave,
  });

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  late TextEditingController _levelController;
  late TextEditingController _jobController;
  late TextEditingController _titleController;
  late TextEditingController _strController;
  late TextEditingController _agiController;
  late TextEditingController _intController;
  late TextEditingController _vitController;
  late TextEditingController _perController;
  String _selectedRank = 'E';

  @override
  void initState() {
    super.initState();
    _levelController = TextEditingController(text: widget.currentData['level']?.toString() ?? '1');
    _jobController = TextEditingController(text: widget.currentData['jobClass'] ?? 'None');
    _titleController = TextEditingController(text: widget.currentData['title'] ?? 'The Awakened');
    _selectedRank = widget.currentData['rank'] ?? 'E';
    
    _strController = TextEditingController(text: widget.currentData['strength']?.toString() ?? '10');
    _agiController = TextEditingController(text: widget.currentData['agility']?.toString() ?? '10');
    _intController = TextEditingController(text: widget.currentData['intelligence']?.toString() ?? '10');
    _vitController = TextEditingController(text: widget.currentData['vitality']?.toString() ?? '10');
    _perController = TextEditingController(text: widget.currentData['perception']?.toString() ?? '10');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF0F0F1A),
      title: Text('EDIT PROFILE [SYSTEM]', style: GoogleFonts.orbitron(color: Colors.white)),
      content: SingleChildScrollView(
        child: Column(
          children: [
            // AVATAR SELECTION
            Text("AVATAR", style: GoogleFonts.rajdhani(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            SingleChildScrollView(
               scrollDirection: Axis.horizontal,
               child: Row(
                  children: [
                     _buildAvatarOption('assets/avatars/avatar_1.png', Colors.blue),
                     _buildAvatarOption('assets/avatars/avatar_2.png', Colors.red),
                     _buildAvatarOption('assets/avatars/avatar_3.png', Colors.green),
                     _buildAvatarOption('assets/avatars/avatar_4.png', Colors.amber),
                  ],
               ),
            ),
            const Divider(color: Colors.white24),

            _buildInput("Title", _titleController),
            
            const SizedBox(height: 10),
            DropdownButton<String>(
               value: _selectedRank,
               dropdownColor: const Color(0xFF1A1A2E),
               style: GoogleFonts.rajdhani(color: Colors.white),
               items: ['S','A','B','C','D','E'].map((r) => DropdownMenuItem(value: r, child: Text("Rank $r"))).toList(),
               onChanged: (v) => setState(() => _selectedRank = v!),
            ),
            
            const Divider(color: Colors.white24),
            Text("STATS", style: GoogleFonts.rajdhani(color: Colors.blueAccent)),
            _buildInput("Strength", _strController),
            _buildInput("Agility", _agiController),
            _buildInput("Intelligence", _intController),
            _buildInput("Vitality", _vitController),
            _buildInput("Perception", _perController),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCEL")),
        ElevatedButton(
           style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
           onPressed: () {
              final Map<String, dynamic> updates = {
                 'level': int.tryParse(_levelController.text) ?? 1,
                 'jobClass': _jobController.text,
                 'title': _titleController.text,
                 'rank': _selectedRank,
                 'profilePicture': _selectedAvatar, // Save selected avatar
                 'stats': {
                    'str': int.tryParse(_strController.text) ?? 10,
                    'agi': int.tryParse(_agiController.text) ?? 10,
                    'int': int.tryParse(_intController.text) ?? 10,
                    'vit': int.tryParse(_vitController.text) ?? 10,
                    'per': int.tryParse(_perController.text) ?? 10,
                 }
              };
              widget.onSave(updates);
              Navigator.pop(context);
           }, 
           child: const Text("SAVE", style: TextStyle(color: Colors.white))
        ),
      ],
    );
  }

  String? _selectedAvatar;
  
  // Since we don't have real assets yet, we'll use colors to simulate
  Widget _buildAvatarOption(String assetPath, Color color) {
     final isSelected = _selectedAvatar == assetPath;
     return GestureDetector(
        onTap: () => setState(() => _selectedAvatar = assetPath),
        child: Container(
           margin: const EdgeInsets.only(right: 12),
           padding: const EdgeInsets.all(2),
           decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: isSelected ? Colors.white : Colors.transparent, width: 2),
           ),
           child: CircleAvatar(
              backgroundColor: color,
              radius: 20,
              child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 16) : null,
           ),
        ),
     );
  }

  Widget _buildInput(String label, TextEditingController controller) {
     return Padding(
       padding: const EdgeInsets.only(bottom: 8.0),
       child: TextField(
         controller: controller,
         style: const TextStyle(color: Colors.white),
         decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(color: Colors.white54),
            enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
         ),
       ),
     );
  }
}
