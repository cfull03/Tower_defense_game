import 'package:flame/components.dart';
import '../tower_defense_game.dart';
import 'npc_base.dart';

/// Basic NPC that follows a path and deals damage to the player's base
class BasicNPC extends NPCBase {
  double baseDamage; // Damage dealt to the base
  bool reachedBase = false; // Tracks if NPC reached the target

  BasicNPC({
    required super.path,
    this.baseDamage = 10.0, // Default damage amount
    super.position,
    super.sprite,
  });

  @override
  void performAction() {
    // Check if NPC has reached the end of the path
    if (currentPointIndex >= path.length && !reachedBase) {
      _dealDamageToBase(); // Deal damage when the target is reached
      reachedBase = true; // Mark NPC as having reached the base
      removeFromParent(); // Remove NPC from the game after dealing damage
    }
  }

  /// Deals damage to the player's base when the NPC reaches the target
  void _dealDamageToBase() {
    // Cast gameRef to TowerDefenseGame to access baseHealth
    final game = gameRef as TowerDefenseGame;

    print('Basic NPC reached the base! Dealing $baseDamage damage!');
    game.baseHealth -= baseDamage;

    // Check if the base health has reached 0
    if (game.baseHealth <= 0) {
      print('Game Over! The base has been destroyed!');
    }
  }
}
