import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vpmobil_wrapper/theme.dart';
import 'package:vpmobil_wrapper/utils/data_provider.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.component,
      ),
      backgroundColor: theme.base,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("savedDates: ${context.read<DataProvider>().savedDates}"),
            Text("data: ${context.read<DataProvider>().data}"),
            Text("klassen: ${context.read<DataProvider>().classes}"),
            Text("newest known date: ${context.read<DataProvider>().newestKnownDate}"),
          ],
        ),
      ),
    );
  }
}