import 'package:flutter/material.dart';
import 'package:lifter_track_app/components/text.dart';
import 'package:fl_chart/fl_chart.dart';

class Graph extends StatefulWidget {
  final minY;
  final maxY;
  final List data;

  const Graph({Key key, double this.minY, double this.maxY, List this.data})
      : super(key: key);

  @override
  _GraphState createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
          minX: 0,
          maxX: widget.data.length.toDouble() - 1,
          minY: widget.minY,
          maxY: widget.maxY,
          gridData: FlGridData(
            show: false,
          ),
          borderData: FlBorderData(
              show: false,
              border: Border.all(color: Theme.of(context).primaryColor)),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: SideTitles(showTitles: false),
            topTitles: SideTitles(showTitles: false),
            bottomTitles: SideTitles(showTitles: false),
            leftTitles: SideTitles(
              showTitles: true,
              getTextStyles: (textContext, value) => const TextStyle(
                color: Color(0xff67727d),
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              reservedSize: 60,
              margin: 12,
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: widget.data
                  .map((point) => FlSpot(
                      point['index'].toDouble(), point['value'].toDouble()))
                  .toList(),
              isCurved: true,
              barWidth: 1,
              belowBarData: BarAreaData(show: true, colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).focusColor
              ]),
              dotData: FlDotData(
                show: false,
              ),
            ),
          ]),
    );
  }
}
