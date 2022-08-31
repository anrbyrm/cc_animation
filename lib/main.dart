import 'dart:math';

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
        scaffoldBackgroundColor: scaffoldColor,
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
    final transform = useState<double>(.0009);
    final animation =
        Tween<Offset>(begin: const Offset(0, .3), end: Offset.zero).animate(
      CurvedAnimation(
        parent: controller!,
        curve: const Interval(0, .3, curve: Curves.easeIn),
      ),
    );
    final transformAnimation = TweenSequence([
      TweenSequenceItem(
        tween: Tween(begin: .0009, end: -.0007),
        weight: 1,
      ),
      TweenSequenceItem(tween: Tween(begin: -.0007, end: 0), weight: 1),
    ]).animate(
      CurvedAnimation(
        parent: controller!,
        curve: const Interval(.3, 1, curve: Curves.easeIn),
      ),
    );

    final lineAnimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
            parent: controller!,
            curve: Interval(.7, 1, curve: Curves.easeInOut)));

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
          0,
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
          ..rotateZ(0)
          ..setEntry(3, 1, transform.value),
        alignment: FractionalOffset.center,
        child: DecoratedBox(
          decoration: BoxDecoration(
              color: Color(0xFFFCF0E2),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FadeTransition(
                opacity: lineAnimation,
                child: Transform.translate(
                  offset: Offset(0, 15),
                  child: CustomPaint(
                    painter: Lines(color: scaffoldColor, count: 3),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40) +
                    EdgeInsets.only(top: 40, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 15,
                      width: 15,
                      decoration: BoxDecoration(
                        color: scaffoldColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '\$5421.50',
                          style: TextStyle(
                              fontSize: 25,
                              color: scaffoldColor,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '•••',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2,
                            color: scaffoldColor,
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Balance',
                      style: TextStyle(
                          fontSize: 15,
                          color: scaffoldColor,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: 10),
                    NumberLine(),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: const ZigZagLine(
                    angle: 90, color: scaffoldColor, depth: 20),
              ),
            ],
          ),
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
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;

    final path = Path()..moveTo(0, 0);

    for (int i = 1; i <= count!; i++) {
      canvas
        ..drawPath(path, paint)
        ..drawLine(
          Offset(0, 10 + i * 6),
          Offset(15, 20 + i * 6),
          paint,
        );
    }

    return;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class NumberLine extends StatelessWidget {
  const NumberLine({super.key});

  @override
  Widget build(BuildContext context) {
    Size getSize() {
      final textSpan = TextSpan(
        text: '5',
        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
      );
      final painter = TextPainter(text: textSpan);
      painter.textDirection = TextDirection.ltr;

      painter.textScaleFactor = 1.0;
      painter.layout();

      return painter.size;
    }

    final numberSize = getSize();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        for (int i = 0; i < 3; i++)
          SizedBox(
            height: numberSize.height,
            child: Text(
              '****',
              style: TextStyle(
                  color: scaffoldColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
        Text('3233',
            style: TextStyle(
                color: scaffoldColor,
                fontWeight: FontWeight.w700,
                fontSize: 20)),
      ],
    );
  }
}

class ZigZagLine extends StatelessWidget {
  const ZigZagLine({this.depth, this.angle, this.color});

  final double? depth;
  final double? angle;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 80,
      child: CustomPaint(
        painter: LinePainter(this),
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  const LinePainter(this.line);

  final ZigZagLine? line;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = line!.color!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final width = line!.angle == 90
        ? line!.depth
        : (line!.depth! * tan(line!.angle! / 360 * pi));
    final zigZagAperture = width! * 2;
    final zigZagCount = (size.width / zigZagAperture).floor();

    final zigZagPath = Path()..moveTo(size.width, 0);
    final points = <Offset>[];

    double position = 0;

    points.add(Offset(position, line!.depth! / 2));
    points.add(Offset(position += width / 2, 0));
    points.add(Offset(position += width, line!.depth!));

    for (int i = 2; i <= zigZagCount; i++) {
      points.add(Offset(position, line!.depth!));
      points.add(Offset(position += width, 0));
      points.add(Offset(position += width, line!.depth!));
    }

    points.add(Offset(position, line!.depth!));
    points.add(Offset(position += width / 2, line!.depth! / 2));

    zigZagPath.addPolygon(points, false);
    canvas.drawPath(zigZagPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
