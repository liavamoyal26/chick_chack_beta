import 'package:chick_chack_beta/models/exem.dart';
import 'package:chick_chack_beta/widgets/exem_item.dart';
import 'package:flutter/material.dart';

class ExemsList extends StatelessWidget {
  const ExemsList({
    super.key,
    required this.exems,
    required this.onRemoveExem,
  });

  final List<Exem> exems;
  final void Function(Exem expnse) onRemoveExem;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: exems.length,
      itemBuilder: (ctx, index) =>
       Dismissible(
        //נותן את האופציה להחליק משימה ולמחוק אותה
        background: Container(
          color: Theme.of(context).colorScheme.error.withOpacity(0.75),
          margin: EdgeInsets.symmetric(
            horizontal: Theme.of(context).cardTheme.margin!.horizontal,
            vertical: Theme.of(context).cardTheme.margin!.vertical,
          ),
        ),
        key: ValueKey(
            exems[index]), //מזהה יחודי לויגט ("הוצאה") הספציפים שרוצים למחוק
        onDismissed: (direction) {
        onRemoveExem(exems[index]);
        },
        child: ExemItem(exems[index]),
      ),
    );
  }
}
