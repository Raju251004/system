import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:system/core/presentation/widgets/glass_box.dart';
import 'package:system/features/inventory/domain/item_model.dart';

class InventoryScreen extends ConsumerWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Mock Data
    final List<Item> items = [
       const Item(id: '1', name: 'Rank E Badge', description: 'Proof of awakening.', type: ItemType.BADGE, iconPath: 'badge_e'),
       const Item(id: '2', name: 'XP Boost (1h)', description: 'Double XP for 1 hour.', type: ItemType.CONSUMABLE, iconPath: 'potion_xp'),
       const Item(id: '3', name: 'Vitality Elixir', description: 'Restores 50% HP.', type: ItemType.CONSUMABLE, iconPath: 'potion_hp'),
       const Item(id: '4', name: 'Dagger', description: 'Basic E-Rank Weapon.', type: ItemType.EQUIPMENT, iconPath: 'dagger'),
       const Item(id: '5', name: '7-Day Streak', description: 'Consistency reward.', type: ItemType.BADGE, iconPath: 'badge_streak'),
    ];

    return Scaffold(
       backgroundColor: const Color(0xFF0F0518),
       body: Container(
          decoration: const BoxDecoration(
             gradient: LinearGradient(
                colors: [Color(0xFF0F0518), Color(0xFF001f3f)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter
             )
          ),
          child: SafeArea(
             child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                      Text("INVENTORY", style: GoogleFonts.orbitron(color: Colors.white, fontSize: 24, letterSpacing: 2)),
                      const SizedBox(height: 20),
                      Expanded(
                         child: GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                               crossAxisCount: 3,
                               childAspectRatio: 0.8,
                               crossAxisSpacing: 12,
                               mainAxisSpacing: 12,
                            ),
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                               final item = items[index];
                               return GestureDetector(
                                  onTap: () => _showItemDetails(context, item),
                                  child: GlassBox(
                                     borderRadius: BorderRadius.circular(12),
                                     padding: const EdgeInsets.all(8),
                                     child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                           Icon(Icons.hexagon_outlined, color: _getItemColor(item.type), size: 40), // Placeholder Icon
                                           const SizedBox(height: 8),
                                           Text(
                                              item.name, 
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.rajdhani(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)
                                           ),
                                           Text(
                                              "x${item.quantity}", 
                                              style: GoogleFonts.rajdhani(color: Colors.white54, fontSize: 10)
                                           ),
                                        ],
                                     ),
                                  ),
                               );
                            },
                         ),
                      ),
                   ],
                ),
             ),
          ),
       ),
    );
  }

  Color _getItemColor(ItemType type) {
     switch(type) {
        case ItemType.BADGE: return Colors.amber;
        case ItemType.CONSUMABLE: return Colors.blueAccent;
        case ItemType.EQUIPMENT: return Colors.redAccent;
     }
  }

  void _showItemDetails(BuildContext context, Item item) {
     showDialog(
        context: context,
        builder: (context) => AlertDialog(
           backgroundColor: const Color(0xFF1A0B2E),
           title: Text(item.name, style: GoogleFonts.orbitron(color: Colors.white)),
           content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                 Icon(Icons.hexagon_outlined, color: _getItemColor(item.type), size: 60),
                 const SizedBox(height: 16),
                 Text(item.description, style: GoogleFonts.rajdhani(color: Colors.white70)),
                 const SizedBox(height: 8),
                 Text("Type: ${item.type.name}", style: GoogleFonts.rajdhani(color: Colors.white38)),
              ],
           ),
           actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("CLOSE")),
              if (item.type == ItemType.CONSUMABLE)
                 ElevatedButton(
                    onPressed: () {
                       // Logic to use item
                       Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent), 
                    child: const Text("USE", style: TextStyle(color: Colors.white))
                 ),
           ],
        ),
     );
  }
}
