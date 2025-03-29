import 'package:flame/components.dart';
import '../npcs/npc_base.dart';

abstract class ProjectileBase extends SpriteComponent with HasGameRef {
  NPCBase target;
  double speed;
  double damage;

  ProjectileBase({
    required Vector2 position,
    required this.target,
    this.speed = 200.0,
    this.damage = 20.0,
    Sprite? sprite,
  }) : super(
          position: position,
          size: Vector2.all(8.0),
          anchor: Anchor.center,
          sprite: sprite,
        );

  @override
  void update(double dt) {
    super.update(dt);
    if (!target.isMounted || target.isDead) {
      removeFromParent();
      return;
    }

    _moveToTarget(dt);
    if (_hasReachedTarget()) {
      _hitTarget();
    }
  }

  void _moveToTarget(double dt) {
    final direction = (target.position - position).normalized();
    position += direction * speed * dt;
  }

  bool _hasReachedTarget() {
    return position.distanceTo(target.position) < 5.0;
  }

  void _hitTarget();
}
