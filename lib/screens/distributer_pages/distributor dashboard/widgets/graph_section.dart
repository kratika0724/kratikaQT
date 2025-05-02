import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_textstyles.dart';

class GraphSection extends StatelessWidget {
  const GraphSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
      ),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 12.0, bottom: 12.0, left: 8, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "Overview",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: boldTextStyle(
                      fontSize: dimen18,
                      color: Colors.black,
                      latterSpace: 1.0,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(
                    show: true,
                    border:
                        Border.all(color: AppColors.primary.withOpacity(0.2)),
                  ),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          // Generate last 7 dates from today
                          final now = DateTime.now();
                          final List<String> last7Days =
                              List.generate(7, (index) {
                            final date =
                                now.subtract(Duration(days: 6 - index));
                            return "${date.day.toString().padLeft(2, '0')} ${_monthShort(date.month)}";
                          });

                          int index = value.toInt();
                          return Text(
                            index >= 0 && index < last7Days.length
                                ? last7Days[index]
                                : '',
                            style: const TextStyle(
                                fontSize: 10, color: Colors.black),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 20,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}',
                            style: TextStyle(fontSize: 10, color: Colors.black),
                          );
                        },
                      ),
                    ),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  lineBarsData: [
                    _buildLineBarData([10, 20, 30, 25, 35, 40], Colors.green),
                    _buildLineBarData(
                        [12, 24, 20, 30, 28, 22], Colors.amberAccent),
                    _buildLineBarData(
                        [7, 15, 17, 22, 20, 27], Colors.red.shade600),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLegend(Colors.green, "Users"),
                    SizedBox(width: 10),
                    _buildLegend(Colors.amberAccent, "Products"),
                    SizedBox(width: 10),
                    _buildLegend(Colors.red, "Payments"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  LineChartBarData _buildLineBarData(List<double> values, Color color) {
    return LineChartBarData(
      isCurved: false,
      color: color,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      spots: values
          .asMap()
          .entries
          .map((e) => FlSpot(e.key.toDouble(), e.value))
          .toList(),
    );
  }

  Widget _buildLegend(Color color, String title) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        SizedBox(width: 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            title,
            style: regularTextStyle(fontSize: dimen12, color: Colors.black),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

String _monthShort(int month) {
  const monthNames = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];
  return monthNames[month - 1];
}
