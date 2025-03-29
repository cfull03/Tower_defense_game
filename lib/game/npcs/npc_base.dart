import 'package:flame/components.dart';

abstract class NPCBase extends PositionComponent {
  double health;
  double speed;
  double baseDamage;
  int currentPointIndex = 0;
  List<Vector2> path;

  NPCBase({
    required this.health,
    required this.speed,
    required this.baseDamage,
    required this.path,
    required Vector2 position,
  }) : super(position: position, size: Vector2.all(32.0), anchor: Anchor.center);

  @override
  void update(double dt) {
    super.update(dt);
    followPath(dt);
  }

  void followPath(double dt) {
    if (currentPointIndex < path.length) {
      final targetPosition = path[currentPointIndex];
      final direction = (targetPosition - position).normalized();
      position += direction * speed * dt;

      if (position.distanceTo(targetPosition) < 5.0) {
        currentPointIndex++;
      }
    }
  }

  void takeDamage(double damage) {
    health -= damage;
    if (health <= 0) {
      removeFromParent();
    }
  }

  bool get isDead => health <= 0;
}
