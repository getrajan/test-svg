import 'dart:math';

import 'package:flutter/material.dart';
import 'package:testing/wave_form/single_bar_painter.dart';

import 'background_painter.dart';

class WaveProgressBar extends StatefulWidget {
  final double progressPercentage;
  final List<double> listOfHeights;
  final double width;
  final Color initalColor;
  final Color progressColor;
  final Color backgroundColor;
  final int timeInMilliSeconds;
  final bool isVerticallyAnimated;
  final bool isHorizontallyAnimated;

  const WaveProgressBar({
    this.isVerticallyAnimated = true,
    this.isHorizontallyAnimated = true,
    required this.listOfHeights,
    this.initalColor = Colors.red,
    this.progressColor = Colors.green,
    this.backgroundColor = Colors.white,
    required this.width,
    required this.progressPercentage,
    this.timeInMilliSeconds = 20000,
  });

  @override
  WaveProgressBarState createState() {
    return WaveProgressBarState();
  }
}

class WaveProgressBarState extends State<WaveProgressBar>
    with SingleTickerProviderStateMixin {
  final List<Widget> arrayOfBars = [];
  late Animation<double> horizontalAnimation;
  late Animation<double> verticalAnimation;
  late AnimationController controller;
  late double begin;
  late double end;

  @override
  void initState() {
    begin = 0;
    end = widget.width;

    super.initState();
    controller = AnimationController(
        duration: Duration(milliseconds: widget.timeInMilliSeconds),
        vsync: this);

    horizontalAnimation = Tween(begin: begin, end: end).animate(controller)
      ..addListener(() {
        setState(() {});
      });
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    arrayOfBars.add(CustomPaint(
      painter: BackgroundBarPainter(
        widthOfContainer: (widget.isHorizontallyAnimated)
            ? horizontalAnimation.value
            : widget.width,
        heightOfContainer: widget.listOfHeights.reduce(max),
        progresPercentage: widget.progressPercentage,
        initialColor: widget.initalColor,
        progressColor: widget.progressColor,
      ),
    ));

    for (int i = 0; i < widget.listOfHeights.length; i++) {
      verticalAnimation =
          Tween(begin: 0.0, end: widget.listOfHeights[i]).animate(controller)
            ..addListener(() {
              setState(() {});
            });
      controller.forward();
      arrayOfBars.add(
        CustomPaint(
          painter: SingleBarPainter(
              startingPosition:
                  (i * ((widget.width / widget.listOfHeights.length))),
              singleBarWidth: widget.width / widget.listOfHeights.length,
              maxSeekBarHeight: widget.listOfHeights.reduce(max) + 1,
              actualSeekBarHeight: (widget.isVerticallyAnimated)
                  ? verticalAnimation.value
                  : widget.listOfHeights[i],
              heightOfContainer: widget.listOfHeights.reduce(max),
              backgroundColor: widget.backgroundColor),
        ),
      );
    }

    return Center(
      child: Container(
          height: widget.listOfHeights.reduce(max),
          width: widget.width,
          child: Row(
            children: arrayOfBars,
          )),
    );
  }
}
