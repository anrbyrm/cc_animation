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
      duration: Duration(milliseconds: (animationDuration * 2.5).toInt()),
    );
    final secondCardController = useAnimationController(
      duration: Duration(milliseconds: (animationDuration * 2.5).toInt()),
    );
    final secondStartController = useAnimationController(
      duration: const Duration(milliseconds: animationDuration ~/ 2),
    );

    addButtonController.forward();
    myCardsTextController.forward();
    cardController.forward().timeout(
      const Duration(seconds: 1),
      onTimeout: () {
        secondStartController.forward();
        secondCardController.forward();
        return;
      },
    );

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
            CC(
              cardColor: const Color(0xFFFCF0E2),
              cardNumber: 3667,
              value: 5242.13,
              controller: cardController,
            ),
            const Spacer(),
            FadeTransition(
              opacity: secondStartController,
              child: CC(
                cardColor: const Color(0xFFA95644),
                cardNumber: 9813,
                value: 4133.43,
                controller: secondCardController,
              ),
            ),
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
  const CC({
    this.cardNumber,
    this.value,
    this.cardColor,
    this.controller,
    super.key,
  });

  final int? cardNumber;
  final double? value;
  final Color? cardColor;
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
    final iconAnimation =
        Tween<Offset>(begin: const Offset(1, .5), end: Offset.zero)
            .animate(controller!);
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
        curve: const Interval(.7, 1, curve: Curves.easeInOut),
      ),
    );

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
            color: cardColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FadeTransition(
                opacity: lineAnimation,
                child: Transform.translate(
                  offset: const Offset(0, 10),
                  child: const CustomPaint(
                    painter: Lines(color: scaffoldColor, count: 3),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40) +
                    const EdgeInsets.only(top: 30, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: 30,
                      height: 20,
                      child: FadeTransition(
                        opacity: Tween<double>(begin: 0, end: 1).animate(
                          CurvedAnimation(
                            parent: controller!,
                            curve: const Interval(
                              .2,
                              1,
                              curve: Curves.easeInOutCubic,
                            ),
                          ),
                        ),
                        child: SlideTransition(
                          position: iconAnimation,
                          child: const CustomPaint(
                            painter: Circles(
                              firstCircleColor: Color(0xFFFFFFFF),
                              secondCircleColor: Color(0xFF000000),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        AnimatedCounter(
                          value: value,
                          controller: controller,
                        ),
                        FadeTransition(
                          opacity: lineAnimation
                            ..drive(
                              Tween<double>(begin: 0, end: 1)
                                ..animate(
                                  CurvedAnimation(
                                    parent: controller!,
                                    curve: const Interval(
                                      .6,
                                      1,
                                      curve: Curves.easeInOutCubic,
                                    ),
                                  ),
                                ),
                            ),
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(-3, 0),
                              end: Offset.zero,
                            ).animate(
                              CurvedAnimation(
                                parent: controller!,
                                curve: const Interval(
                                  .6,
                                  1,
                                  curve: Curves.easeInOutCubic,
                                ),
                              ),
                            ),
                            child: const Text(
                              '•••',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 2,
                                color: scaffoldColor,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    FadeTransition(
                      opacity: lineAnimation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 1),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: controller!,
                            curve: const Interval(
                              .5,
                              1,
                              curve: Curves.easeInOutCubic,
                            ),
                          ),
                        ),
                        child: const Text(
                          'Balance',
                          style: TextStyle(
                            fontSize: 15,
                            color: scaffoldColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    FadeTransition(
                      opacity: lineAnimation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 1),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: controller!,
                            curve: const Interval(
                              .7,
                              1,
                              curve: Curves.easeInOutCubic,
                            ),
                          ),
                        ),
                        child: NumberLine(cardNumber),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: ZigZagLine(
                  zigs: 3,
                  width: 5,
                  count: 2,
                  color: scaffoldColor,
                  controller: controller,
                ),
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
  const NumberLine(this.cardNumber, {super.key});
  final int? cardNumber;

  @override
  Widget build(BuildContext context) {
    Size getSize() {
      const textSpan = TextSpan(
        text: '8',
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
            child: const Text(
              '****',
              style: TextStyle(
                color: scaffoldColor,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        Text(
          cardNumber.toString(),
          style: const TextStyle(
            color: scaffoldColor,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}

class ZigZagLine extends HookWidget {
  const ZigZagLine({
    this.count,
    this.zigs,
    this.width,
    this.color,
    this.controller,
  });

  final int? zigs;
  final int? count;
  final double? width;
  final Color? color;
  final AnimationController? controller;

  @override
  Widget build(BuildContext context) {
    final animation =
        Tween<Offset>(begin: const Offset(2, 0), end: Offset.zero).animate(
      CurvedAnimation(
        parent: controller!,
        curve: const Interval(.5, 1, curve: Curves.easeInOutCubic),
      ),
    );

    return SlideTransition(
      position: animation,
      child: SizedBox(
        height: 30,
        width: 50,
        child: CustomPaint(
          painter: LinePainter(this),
        ),
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

    canvas.save();
    canvas.translate(0, 0);

    for (int i = 0; i < line!.count!; i++) {
      final end = Offset(size.width + 2, i * 7);
      final length = end.distance;
      final spacing = length / (line!.zigs! * 2);
      final path = Path()..moveTo(0, end.dy);

      // canvas.rotate(atan(end.dy / end.dx));

      for (int index = 0; index < line!.zigs!; index++) {
        final x = (index * 2 + 1) * spacing;
        final y = line!.width! * ((index % 2) * 2 - 1) + 7 * i;
        path.lineTo(x, y);
      }

      path.lineTo(length, i * 7);
      canvas.drawPath(path, paint);
    }
    canvas.restore();

    // final width = line!.angle == 90
    //     ? line!.depth
    //     : (line!.depth! * tan(line!.angle! / 360 * pi));
    // final zigZagAperture = width! * 2;
    // final zigZagCount = (size.width / zigZagAperture).floor();

    // final zigZagPath = Path()..moveTo(size.width, 0);
    // final points = <Offset>[];

    // double position = 0;

    // points.add(Offset(position, line!.depth! / 2));
    // points.add(Offset(position += width / 2, 0));
    // points.add(Offset(position += width, line!.depth!));

    // for (int i = 2; i <= zigZagCount; i++) {
    //   points.add(Offset(position, line!.depth!));
    //   points.add(Offset(position += width, 0));
    //   points.add(Offset(position += width, line!.depth!));
    // }

    // points.add(Offset(position, line!.depth!));
    // points.add(Offset(position += width / 2, line!.depth! / 2));

    // zigZagPath.addPolygon(points, false);
    // canvas.drawPath(zigZagPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class AnimatedCounter extends HookWidget {
  const AnimatedCounter({
    this.value,
    this.controller,
  });

  final num? value;
  final AnimationController? controller;

  @override
  Widget build(BuildContext context) {
    final counterValue = useAnimation(
      Tween<double>(begin: 0, end: value!.toDouble()).animate(
        CurvedAnimation(parent: controller!, curve: Curves.easeInOutCubic),
      ),
    );

    return AnimatedCounterWidget(
      value: counterValue,
      color: scaffoldColor,
      curve: Curves.easeInOutCubic,
      controller: controller,
      fractionDigits: 2,
      padding: const EdgeInsets.all(2),
      style: const TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 25,
      ),
      wholeDigits: 0,
    );
  }
}

class AnimatedCounterWidget extends HookWidget {
  const AnimatedCounterWidget({
    this.value,
    this.color,
    this.curve,
    this.padding,
    this.fractionDigits,
    this.wholeDigits,
    this.controller,
    this.style,
    super.key,
  });

  final num? value;
  final int? fractionDigits;
  final int? wholeDigits;
  final Curve? curve;
  final Color? color;
  final TextStyle? style;
  final AnimationController? controller;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final digitProp = TextPainter(
      text: TextSpan(
        text: '8',
        style:
            TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: color),
      ),
      textDirection: TextDirection.ltr,
      textScaleFactor: MediaQuery.of(context).textScaleFactor,
    )..layout();

    final value = (this.value! * pow(10, fractionDigits!)).round();

    List<int> digits = value == 0 ? [0] : [];
    int v = value.abs();

    while (v > 0) {
      digits.add(v);
      v = v ~/ 10;
    }
    while (digits.length < wholeDigits! + fractionDigits!) {
      digits.add(0);
    }
    digits = digits.reversed.toList(growable: false);

    final integerWidgets = <Widget>[];
    for (int i = 0; i < digits.length - fractionDigits!; i++) {
      final digit = SingleDigit(
        key: ValueKey(digits.length - i),
        value: digits[i].toDouble(),
        duration: controller!.duration! * 1.5,
        curve: curve!,
        size: digitProp.size,
        color: color!,
        padding: padding!,
      );
      integerWidgets.add(digit);
    }

    final textStyle = style!.merge(TextStyle(color: color));

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          child: TweenAnimationBuilder(
            duration: controller!.duration! * 1.5,
            tween: Tween(end: value < 0 ? 1 : 0),
            builder: (_, int v, __) => Center(
              widthFactor: v.toDouble(),
              child: const Text('-'),
            ),
          ),
        ),
        ...integerWidgets,
        if (fractionDigits != 0)
          Padding(
            padding: EdgeInsets.only(bottom: padding!.bottom),
            child: Text('.', style: textStyle),
          ),
        for (int i = digits.length - fractionDigits!; i < digits.length; i++)
          SingleDigit(
            key: ValueKey("decimal$i"),
            value: digits[i].toDouble(),
            duration: controller!.duration!,
            curve: curve!,
            size: digitProp.size,
            color: color!,
            padding: padding!,
          ),
      ],
    );
  }
}

class SingleDigit extends StatelessWidget {
  final double value;
  final Duration duration;
  final Curve curve;
  final Size size;
  final Color color;
  final EdgeInsets padding;

  const SingleDigit({
    required this.value,
    required this.duration,
    required this.curve,
    required this.size,
    required this.color,
    required this.padding,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Widget buildSingleDigit({
      required int digit,
      required double offset,
      required double opacity,
    }) {
      final Widget? child;
      if (color.opacity == 1) {
        child = Text(
          '$digit',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: color.withOpacity(opacity.clamp(0, 1)),
            fontWeight: FontWeight.w700,
            fontSize: 25,
          ),
        );
      } else {
        child = Opacity(
          opacity: opacity.clamp(0, 1),
          child: Text('$digit', textAlign: TextAlign.center),
        );
      }

      return Positioned(
        left: 0,
        right: 0,
        bottom: offset + padding.bottom,
        child: child,
      );
    }

    return TweenAnimationBuilder(
      tween: Tween(end: value),
      duration: duration,
      curve: curve,
      builder: (_, double value, __) {
        final whole = value ~/ 1;
        final decimal = value - whole;
        final w = size.width + padding.horizontal;
        final h = size.height + padding.vertical;

        return SizedBox(
          width: w,
          height: h,
          child: Stack(
            children: <Widget>[
              buildSingleDigit(
                digit: whole % 10,
                offset: h * decimal,
                opacity: 1 - decimal,
              ),
              buildSingleDigit(
                digit: (whole + 1) % 10,
                offset: h * decimal - h,
                opacity: decimal,
              ),
            ],
          ),
        );
      },
    );
  }
}

class Circles extends CustomPainter {
  const Circles({this.firstCircleColor, this.secondCircleColor});

  final Color? firstCircleColor;
  final Color? secondCircleColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final center = size.width / 2;

    canvas.save();

    final radius = center / 1.5;

    canvas
      ..drawCircle(
        Offset(radius * 2.5, radius),
        radius,
        paint..color = secondCircleColor!,
      )
      ..drawCircle(
        Offset(radius, radius),
        center / 1.5,
        paint..color = firstCircleColor!,
      );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
