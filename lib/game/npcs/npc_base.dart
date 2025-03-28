import 'package:flame/components.dart';
import 'package:flame/game.dart';

/// Abstract base class for all NPCs that follow a path
abstract class NPCBase extends SpriteComponent with HasGameRef<FlameGame> {
  List<Vector2> path; // List of points to follow
  double speed; // Movement speed of the NPC
  int currentPointIndex = 0; // Current position in the path

  NPCBase({
    required this.path,
    this.speed = 50.0, // Default movement speed
    Vector2? position,
    Sprite? sprite,
  }) : super(position: position, sprite: sprite);

  /// Moves the NPC along the path defined in the Tiled map
  void followPath(double dt) {
    if (currentPointIndex < path.length) {
      final targetPoint = path[currentPointIndex];
      final direction = (targetPoint - position).normalized();

      // Move NPC toward the target point
      position.add(direction * speed * dt);

      // Check if the NPC has reached the target point
      if (position.distanceTo(targetPoint) < 1.0) {
        currentPointIndex++;
      }
    }
  }

  /// Abstract method to define custom NPC behavior
  /// Subclasses must implement this method
  void performAction();

  @override
  void update(double dt) {
    super.update(dt);
    followPath(dt);
    performAction(); // Allows subclasses to define their behavior
  }
}
