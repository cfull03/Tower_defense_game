import 'package:flame/components.dart';
import '../npcs/npc_base.dart';
import 'projectiles/basic_projectile.dart';
import 'tower_base.dart';

class BasicTower extends TowerBase {
  BasicTower({
    required Vector2 position,
    double attackRange = 150.0,
    double attackSpeed = 1.0,
    double damage = 20.0,
    Sprite? sprite,
  }) : super(
          position: position,
          attackRange: attackRange,
          attackSpeed: attackSpeed,
          damage: damage,
          sprite: sprite,
        );

  @override
  void _attack(NPCBase target) {
    final projectile = BasicProjectile(
      position: position,
      target: target,
      damage: damage,
    );
    gameRef.add(projectile);
  }
}
