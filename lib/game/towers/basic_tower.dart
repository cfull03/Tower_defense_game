import 'package:flame/events.dart';
import '../npcs/npc_base.dart';
import 'projectiles/basic_projectile.dart';
import 'tower_base.dart';

class BasicTower extends TowerBase with DragCallbacks {
  BasicTower({required super.position});

  @override
  void checkAndShoot(List<NPCBase> npcs) {
    for (var npc in npcs) {
      if (npc.position.distanceTo(position) <= attackRange) {
        final projectile = BasicProjectile(
          position: position.clone(),
          target: npc,
          damage: damage,
        );
        parent?.add(projectile);
      }
    }
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    position.add(event.localDelta);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    print('Tower dropped at position: $position');
  }
}
