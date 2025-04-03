import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'npc_base.dart';
import '../tower_defense_game.dart';

class BasicNPC extends NPCBase {
  bool reachedBase = false;
  late final SpriteAnimationComponent animationComponent;
  late final Map<String, SpriteAnimation> animations;

  BasicNPC({
    required super.path,
    required super.position,
    required super.health,
    required super.baseDamage,
  }) : super(speed: 40.0);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final spriteSheet = SpriteSheet(
      image: await gameRef.images.load('sprites/black_knight.png'),
      srcSize: Vector2.all(32),
    );

    animations = {
      'down': spriteSheet.createAnimation(row: 0, stepTime: 0.15, from: 0, to: 3),
      'left': spriteSheet.createAnimation(row: 1, stepTime: 0.15, from: 0, to: 3),
      'right': spriteSheet.createAnimation(row: 2, stepTime: 0.15, from: 0, to: 3),
      'up': spriteSheet.createAnimation(row: 3, stepTime: 0.15, from: 0, to: 3),
    };

    animationComponent = SpriteAnimationComponent(
      animation: animations['down'],
      size: Vector2.all(32),
    );

    add(animationComponent);
  }

  @override
  void update(double dt) {
    super.update(dt);
    updateAnimationDirection();
  }

  void updateAnimationDirection() {
    if (path.isEmpty || currentPointIndex >= path.length) return;
    final next = path[currentPointIndex];
    final delta = next - position;

    if (delta.x.abs() > delta.y.abs()) {
      animationComponent.animation = delta.x > 0 ? animations['right'] : animations['left'];
    } else {
      animationComponent.animation = delta.y > 0 ? animations['down'] : animations['up'];
    }
  }

  @override
  void performAction() {
    if (currentPointIndex >= path.length && !reachedBase) {
      _dealDamageToBase();
      reachedBase = true;
      removeFromParent();
    }
  }

  void _dealDamageToBase() {
    final game = gameRef as TowerDefenseGame;
    game.baseHealth -= baseDamage;
    if (game.baseHealth <= 0) {
      print('Game Over! The base has been destroyed!');
    }
  }

  @override
  void takeDamage(double damage) {
    health -= damage;
    if (health <= 0) {
      removeFromParent();
    }
  }
}
