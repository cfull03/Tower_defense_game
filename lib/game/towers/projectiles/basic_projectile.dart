import 'projectile_base.dart';

class BasicProjectile extends ProjectileBase {
  BasicProjectile({
    required super.position,
    required super.target,
    super.speed,
    super.damage,
    super.sprite,
  });

  @override
  void _hitTarget() {
    target.takeDamage(damage);
    removeFromParent();
  }
}
