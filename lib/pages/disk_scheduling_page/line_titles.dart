import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineTitles {
  static getTitleData() => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false, reservedSize: 20),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false, reservedSize: 20),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false, reservedSize: 20),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            interval: 10,
            showTitles: true,
            reservedSize: 30,
          ),
        ),
      );
}
