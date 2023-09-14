import 'package:timeline_tile/timeline_tile.dart';
import 'package:flutter/material.dart';

class MyTimeLineTile extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final bool isCurrent;
  final bool isPast;
  final String text;

  const MyTimeLineTile({
    super.key,
    required this.isFirst,
    required this.isLast,
    required this.isPast,
    required this.isCurrent,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: TimelineTile(
        isFirst: isFirst,
        isLast: isLast,
        beforeLineStyle: LineStyle(color: isPast ? Colors.orange : Colors.grey),
        afterLineStyle: LineStyle(
            color: isCurrent
                ? Colors.grey
                : (isPast ? Colors.orange : Colors.grey)),
        indicatorStyle: IndicatorStyle(
            color: isPast ? Colors.orange : Colors.grey,
            width: 40,
            iconStyle: IconStyle(
                iconData: Icons.done,
                color: isPast ? Colors.white : Colors.grey)),
        endChild: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.bold),
            )),
      ),
    );
  }
}
