import 'package:flutter/material.dart';
import 'package:lifter_track_app/components/text.dart';
import 'package:fl_chart/fl_chart.dart';

class Graph extends StatefulWidget {
  final minY;
  final maxY;
  final List data;

  const Graph({Key key, double this.minY, double this.maxY, List this.data}) : super(key: key);

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
          show: false
        ),
        borderData: FlBorderData(
          
        ),
        lineBarsData: [
          LineChartBarData(
            spots: widget.data.map((point) => FlSpot(point['index'].toDouble(), point['value'].toDouble())).toList(),
            isCurved: true
          ),
          
        ]
      ),
    );
  }
}
