import 'package:chick_chack_beta/main.dart';
import 'package:chick_chack_beta/models/exem.dart';
import 'package:chick_chack_beta/styles/styled_text.dart';
import 'package:flutter/material.dart';

class ExemItem extends StatelessWidget {
  const ExemItem(this.exem, {super.key});

  final Exem exem;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, //טקסט בעמודה העליונה מתחיל מצד שמאל
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                StyledText.title(exem.title),
                const Spacer(),
                //const SizedBox(width: ??),
                Text(
                    '${exem.date.day} / ${exem.date.month} / ${exem.date.year}',
                    style: TextStyle(
                      color: exem.date.isBefore(DateTime.now())
                          ? kColorScheme.error
                          : kColorScheme.primary,
                      fontSize: 20,
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
