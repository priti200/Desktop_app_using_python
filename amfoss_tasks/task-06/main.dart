//import 'dart:html';
import 'package:flutter/widgets.dart';
import 'dart:ui';
import 'package:flame/game.dart';
//import 'package:flame/input.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/gestures.dart';
import 'package:flame/flame.dart';
import 'package:flame/components.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();
  final game = PritiGame();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            GameWidget(
              game: game,
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: NavigationKeys(
                onDirectionChanged: game.onArrowKeyChanged,
              ),
            )
          ],
        ),
      ),
    ),
  );
}

class Bunny extends SpriteComponent with HasGameRef {
  Bunny() : super(size: Vector2.all(200.0));

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite('bunny.png');

    position = gameRef.size / 2;
  }
}

class Background extends SpriteComponent with HasGameRef {
  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite('background.png');
    size = sprite!.originalSize;
  }

  Direction direction = Direction.none;

  @override
  void update(double dt) {
    super.update(dt);
    updatePosition(dt);
  }

  updatePosition(double dt) {
    switch (direction) {
      case Direction.up:
        position.y--;
        break;
      case Direction.down:
        position.y++;
        break;
      case Direction.left:
        position.x--;
        break;
      case Direction.right:
        position.x++;
        break;
      case Direction.none:
        break;
    }
  }
}

class PritiGame extends FlameGame {
  Bunny bunny = Bunny();
  Background background = Background();

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await add(background);
    await add(bunny);
    bunny.position = background.size / 1.5;

    camera.followComponent(bunny,
        worldBounds: Rect.fromLTRB(0, 0, background.size.x, background.size.y));
  }

  onArrowKeyChanged(Direction direction) {
    background.direction = direction;
  }
}

enum Direction { up, down, left, right, none }

class NavigationKeys extends StatefulWidget {
  final ValueChanged<Direction>? onDirectionChanged;

  const NavigationKeys({Key? key, required this.onDirectionChanged})
      : super(key: key);

  @override
  State<NavigationKeys> createState() => _NavigationKeysState();
}

class _NavigationKeysState extends State<NavigationKeys> {
  Direction direction = Direction.none;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: 120,
      child: Column(
        children: [
          ArrowKey(
              icons: Icons.keyboard_arrow_up,
              onTapDown: (det) {
                updateDirection(Direction.up);
              },
              onTapUp: (dets) {
                updateDirection(Direction.none);
              },
              onLongPressDown: () {
                updateDirection(Direction.up);
              },
              onLongPressEnd: (dets) {
                updateDirection(Direction.none);
              }),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ArrowKey(
                icons: Icons.keyboard_arrow_left,
                onTapDown: (det) {
                  updateDirection(Direction.left);
                },
                onTapUp: (dets) {
                  updateDirection(Direction.none);
                },
                onLongPressDown: () {
                  updateDirection(Direction.left);
                },
                onLongPressEnd: (dets) {
                  updateDirection(Direction.none);
                },
              ),
              ArrowKey(
                icons: Icons.keyboard_arrow_right,
                onTapDown: (det) {
                  updateDirection(Direction.right);
                },
                onTapUp: (dets) {
                  updateDirection(Direction.none);
                },
                onLongPressDown: () {
                  updateDirection(Direction.right);
                },
                onLongPressEnd: (dets) {
                  updateDirection(Direction.none);
                },
              ),
            ],
          ),
          ArrowKey(
              icons: Icons.keyboard_arrow_down,
              onTapDown: (det) {
                updateDirection(Direction.down);
              },
              onTapUp: (dets) {
                updateDirection(Direction.none);
              },
              onLongPressDown: () {
                updateDirection(Direction.down);
              },
              onLongPressEnd: (dets) {
                updateDirection(Direction.none);
              }),
        ],
      ),
    );
  }

  void updateDirection(Direction newDirection) {
    direction = newDirection;
    widget.onDirectionChanged!(direction);
  }
}

class ArrowKey extends StatelessWidget {
  const ArrowKey({
    Key? key,
    required this.icons,
    required this.onTapDown,
    required this.onTapUp,
    required this.onLongPressDown,
    required this.onLongPressEnd,
  }) : super(key: key);
  final IconData icons;
  final Function(TapDownDetails) onTapDown;
  final Function(TapUpDetails) onTapUp;
  final Function() onLongPressDown;
  final Function(LongPressEndDetails) onLongPressEnd;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onLongPress: onLongPressDown,
      onLongPressEnd: onLongPressEnd,
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0x88ffffff),
          borderRadius: BorderRadius.circular(60),
        ),
        child: Icon(
          icons,
          size: 42,
        ),
      ),
    );
  }
}
