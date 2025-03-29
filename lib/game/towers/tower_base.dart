import 'package:flame/components.dart';
import '../npcs/npc_base.dart';

abstract class TowerBase extends SpriteComponent with HasGameRef {
  double attackRange;
  double attackSpeed;
  double damage;
  double cooldown = 0.0;
  int upgradeLevel = 0;

  TowerBase({
    required Vector2 position,
    this.attackRange = 150.0,
    this.attackSpeed = 1.0,
    this.damage = 20.0,
    Sprite? sprite,
  }) : super(
          position: position,
          size: Vector2.all(32.0),
          anchor: Anchor.center,
          sprite: sprite,
        );

  @override
  void update(double dt) {
    super.update(dt);
    if (cooldown > 0) {
      cooldown -= dt;
    }
  }

  void checkAndShoot(List<NPCBase> npcs) {
    if (cooldown <= 0) {
      for (var npc in npcs) {
        if (position.distanceTo(npc.position) <= attackRange) {
          _attack(npc);
          cooldown = 1 / attackSpeed;
          break;
        }
      }
    }
  }

  void _attack(NPCBase target);

  void upgrade() {
    if (upgradeLevel < 4) {
      upgradeLevel++;
      _applyBasicUpgrade();
    } else {
      _applyTier4Upgrade();
    }
  }

  void _applyBasicUpgrade() {
    switch (upgradeLevel) {
      case 1:
        damage *= 1.25;
        break;
      case 2:
        attackRange += 20;
        break;
      case 3:
        attackSpeed *= 1.5;
        break;
      case 4:
        damage *= 1.5;
        break;
    }
  }

  void _applyTier4Upgrade() {
    print('Choose a unique Tier 4 upgrade:');
    print('1. Double Shot');
    print('2. Explosive Rounds');
    print('3. Freeze Effect');
  }

  void applyTier4Choice(int choice) {
    switch (choice) {
      case 1:
        _applyDoubleShot();
        break;
      case 2:
        _applyExplosiveRounds();
        break;
      case 3:
        _applyFreezeEffect();
        break;
      default:
        print('Invalid choice');
    }
  }

  void _applyDoubleShot() {
    print('Double Shot upgrade applied!');
  }

  void _applyExplosiveRounds() {
    print('Explosive Rounds applied!');
  }

  void _applyFreezeEffect() {
    print('Freeze Effect applied!');
  }
}
