import 'package:flutter/material.dart';
import 'package:wear/wear.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wearable Flutter App Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.dark,
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _toggleAnimation() {
    if (controller.isAnimating) {
      controller.stop(canceled: false);
    } else {
      controller.repeat(
        period: const Duration(seconds: 1),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WatchShape(
      builder: (context, shape, child) {
        return Container(
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            shape: shape == WearShape.round
                ? const CircleBorder()
                : const RoundedRectangleBorder(),
          ),
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            body: Stack(
              children: [
                Center(
                  child: AnimatedHeart(controller: controller),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 28),
                    child: TextButton(
                      onPressed: _toggleAnimation,
                      child: const Text("Make my heart flutter"),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class AnimatedHeart extends StatefulWidget {
  const AnimatedHeart({
    super.key,
    required this.controller,
  });

  final AnimationController controller;

  @override
  State<AnimatedHeart> createState() => _AnimatedHeartState();
}

class _AnimatedHeartState extends State<AnimatedHeart> {
  late final Animation<double> flutter;

  @override
  void initState() {
    super.initState();
    flutter = TweenSequence<double>(
      [
        TweenSequenceItem(
          tween: Tween(begin: 1, end: 1.3),
          weight: 0.2,
        ),
        TweenSequenceItem(
          tween: Tween(begin: 1.2, end: 0.9),
          weight: 0.5,
        ),
        TweenSequenceItem(
          tween: Tween(begin: 1.1, end: 1.3),
          weight: 0.2,
        ),
        TweenSequenceItem(
          tween: Tween(begin: 1.3, end: 1),
          weight: 0.5,
        ),
      ],
    ).animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: Curves.easeOutSine,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: flutter,
      builder: (context, child) {
        return Transform.scale(
          origin: const Offset(0, 3),
          scale: flutter.value,
          child: const Icon(
            Icons.favorite_rounded,
            color: Colors.redAccent,
            size: 32,
          ),
        );
      },
    );
  }
}
