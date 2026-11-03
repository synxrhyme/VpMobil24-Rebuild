import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vpmobil_wrapper/theme.dart';
import 'package:vpmobil_wrapper/utils/log_buffer.dart';

class LogPage extends StatelessWidget {
  const LogPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      backgroundColor: theme.base,
      appBar: AppBar(
        backgroundColor: theme.surface,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: theme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Log', style: TextStyle(color: theme.textPrimary)),
        actions: [
          IconButton(
            icon: Icon(Icons.copy_rounded, color: theme.textPrimary),
            onPressed: () => Clipboard.setData(
              ClipboardData(text: LogBuffer.instance.text),
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete_outline_rounded, color: theme.textPrimary),
            onPressed: LogBuffer.instance.clear,
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: LogBuffer.instance,
        builder: (context, _) {
          return SingleChildScrollView(
            reverse: true, // springt ans Ende zu den neuesten Zeilen
            padding: const EdgeInsets.all(12),
            child: SelectableText(
              LogBuffer.instance.text,
              style: TextStyle(
                color: theme.textPrimary,
                fontFamily: 'monospace',
                fontSize: 12,
              ),
            ),
          );
        },
      ),
    );
  }
}