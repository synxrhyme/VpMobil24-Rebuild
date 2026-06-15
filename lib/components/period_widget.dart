import 'package:flutter/material.dart';
import 'package:vpmobil_wrapper/theme.dart';
import 'package:vpmobil_wrapper/utils/vpmobil_parser.dart';

class PeriodWidget extends StatefulWidget {
  final Period period;
  const PeriodWidget({super.key, required this.period});

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
    final theme = Theme.of(context).extension<AppColors>()!;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      height: 50,
      decoration: BoxDecoration(
        color: theme.component,
        borderRadius: BorderRadius.circular(10),
        border: BoxBorder.all(color: theme.border)
      ),
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("${widget.period.stunde}", style: TextStyle(color: theme.textPrimary)),
                Text("${widget.period.beginn.hour.toString().padLeft(2, "0")}:${widget.period.beginn.minute.toString().padLeft(2, "0")} /"
                      " ${widget.period.ende.hour.toString().padLeft(2, "0")}:${widget.period.ende.minute.toString().padLeft(2, "0")}",
                      style: TextStyle(color: theme.textSecondary)
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("${widget.period.fachKuerzel}", style: TextStyle(color: theme.textPrimary)),
                Text("${widget.period.lehrerKuerzel}", style: TextStyle(color: theme.textPrimary)),
              ],
            ),
          )
        ],
      ),
    );
  }
}