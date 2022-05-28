import 'package:fluent_ui/fluent_ui.dart';
import 'dart:math' as math;

class ProcessDuration {
  String pid;
  int startTime;
  int endTime;
  late Color displayColor;
  late Color fontColor;

  ProcessDuration(
      {required this.pid,
      required this.startTime,
      required this.endTime,
      Color? color}) {
    displayColor = color ?? _randomColor();
    fontColor = _determineFontColor(displayColor);
  }

  Color _randomColor() {
    return Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
        .withOpacity(1.0);
  }

  Color _determineFontColor(Color background) {
    return (background.computeLuminance() > 0.179)
        ? Colors.black
        : Colors.white;
  }
}
