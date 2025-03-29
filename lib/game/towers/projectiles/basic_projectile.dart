import '../npcs/npc_base.dart';
import 'projectile_base.dart';

class BasicProjectile extends ProjectileBase {
  BasicProjectile({
    required Vector2 position,
    required NPCBase target,
    double speed = 200.0,
    double damage = 20.0,
    Sprite? sprite,
  }) : super(
          position: position,
          target: target,
          speed: speed,
          damage: damage,
          sprite: sprite,
        );

  @override
  void _hitTarget() {
    target.takeDamage(damage);
    removeFromParent();
  }
}
