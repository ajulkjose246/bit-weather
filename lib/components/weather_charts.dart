import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class WeatherChart extends StatelessWidget {
  final Size size;
  final String heading;
  final String subheading;
  final Color color;
  final double value;
  final double minimum;
  final double maximum;
  const WeatherChart(
      {super.key,
      required this.size,
      required this.heading,
      required this.subheading,
      required this.value,
      required this.minimum,
      required this.maximum,
      required this.color});

  @override
  Widget build(BuildContext context) {
    final double width = size.width;
    return Container(
      width: size.width / 2.5,
      height: size.width / 2.5,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              heading,
              style: TextStyle(
                color: Colors.black,
                fontSize: width * 0.04,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              subheading,
              style: TextStyle(
                color: Colors.grey,
                fontSize: width * 0.03,
              ),
            ),
            SizedBox(
              height: width * 0.22,
              child: SfRadialGauge(
                enableLoadingAnimation: true,
                animationDuration: 5,
                axes: <RadialAxis>[
                  RadialAxis(
                    minimum: minimum,
                    maximum: maximum,
                    showLabels: false,
                    showAxisLine: false,
                    annotations: <GaugeAnnotation>[
                      GaugeAnnotation(
                          widget: Text(value.toString(),
                              style: TextStyle(
                                  fontSize: width * 0.03,
                                  fontWeight: FontWeight.bold)),
                          angle: 90,
                          positionFactor: 0.8)
                    ],
                    ranges: <GaugeRange>[
                      GaugeRange(
                          startValue: 0,
                          endValue: value,
                          color: color,
                          startWidth: 10,
                          endWidth: 10)
                    ],
                    pointers: <GaugePointer>[
                      NeedlePointer(
                        value: value,
                        enableAnimation: true,
                        needleColor: Colors.red,
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
