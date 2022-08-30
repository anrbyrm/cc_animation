import 'package:cc_animation/constants.dart';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CC animation',
      theme: ThemeData(
        textTheme: Theme.of(context).textTheme.apply(
              displayColor: const Color(0xFFFFFFFF),
              bodyColor: const Color(0xFFFFFFFF),
            ),
      ),
      home: const Home(),
    );
  }
}

class Home extends HookWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final addButtonController = useAnimationController(
      duration: const Duration(milliseconds: animationDuration),
    );
    final myCardsTextController = useAnimationController(
      duration: const Duration(milliseconds: animationDuration),
    );
    final cardController = useAnimationController(
      duration: const Duration(milliseconds: animationDuration * 2),
    );

    addButtonController.forward();
    myCardsTextController.forward();
    cardController.forward();

    return Scaffold(
      backgroundColor: const Color(0xFF040303),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child: Column(
          children: <Widget>[
            Stack(
              children: [
                Row(
                  children: [
                    MyCardsText(controller: myCardsTextController),
                    const Spacer(),
                    AddButton(controller: addButtonController),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            CC(controller: cardController),
          ],
        ),
      ),
    );
  }
}

class AddButton extends HookWidget {
  const AddButton({this.controller, super.key});
  final AnimationController? controller;

  @override
  Widget build(BuildContext context) {
    final animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: controller!, curve: Curves.elasticOut),
    );

    return ScaleTransition(
      scale: animation,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Color(0xFFFFFFFF),
        ),
        height: 40,
        width: 40,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class MyCardsText extends HookWidget {
  const MyCardsText({this.controller, super.key});

  final AnimationController? controller;

  @override
  Widget build(BuildContext context) {
    final slideAnimation = Tween<Offset>(
      begin: const Offset(3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: controller!, curve: Curves.easeInOut));

    final opacityAnimation = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: controller!, curve: Curves.easeIn));

    return SlideTransition(
      position: slideAnimation,
      child: FadeTransition(
        opacity: opacityAnimation,
        child: const Text(
          'My Cards',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class CC extends HookWidget {
  const CC({this.controller, super.key});

  final AnimationController? controller;

  @override
  Widget build(BuildContext context) {
    final transform = useState<double>(.0005);
    final animation =
        Tween<Offset>(begin: const Offset(0, .3), end: Offset.zero).animate(
            CurvedAnimation(
                parent: controller!,
                curve: Interval(0, .3, curve: Curves.easeIn)));
    final transformAnimation = TweenSequence([
      TweenSequenceItem(
        tween: Tween(begin: .0005, end: -.0015),
        weight: 1,
      ),
      TweenSequenceItem(tween: Tween(begin: -.0015, end: 0), weight: 1),
    ]).animate(CurvedAnimation(
        parent: controller!, curve: Interval(.3, 1, curve: Curves.easeIn)));

    transformAnimation.addListener(() {
      transform.value = transformAnimation.value.toDouble();
    });

    return SlideTransition(
      position: animation,
      child: Transform(
        transform: Matrix4(
          1,
          0,
          0,
          0,
          0,
          1,
          0,
          transform.value,
          0,
          0,
          1,
          0,
          0,
          0,
          0,
          1,
        )
          ..rotateX(0)
          ..rotateY(0)
          ..rotateZ(0),
        alignment: FractionalOffset.center,
        child: Container(
          height: 100,
          decoration: BoxDecoration(
              color: Color(0xFFFCF0E2),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text('ble'),
                    ],
                  )
                ],
              )),
        ),
      ),
    );
  }
}

class Lines extends CustomPainter {
  const Lines({this.color, this.offset, this.count});

  final Color? color;
  final Offset? offset;
  final int? count;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color!
      ..style = PaintingStyle.fill;

    for (int i = 0; i < count!; i++) {
      canvas
        ..restore()
        ..drawRect(
          Rect.fromPoints(
            Offset((10 * i).toDouble(), 1),
            Offset(
              (20 * i).toDouble(),
              0,
            ),
          ),
          paint,
        )
        ..save();
    }

    return;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
