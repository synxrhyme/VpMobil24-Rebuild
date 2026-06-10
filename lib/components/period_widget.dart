import 'package:flutter/material.dart';

class PeriodWidget extends StatefulWidget {
  final int period;
  final String className;
  const PeriodWidget({super.key, required this.period, required this.className});

  @override
  State<PeriodWidget> createState() => _PeriodWidgetState();
}

class _PeriodWidgetState extends State<PeriodWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            height: 50,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 15, 15, 15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Text(""),
              ],
            ),
          )
        )
      ],
    );
  }
}