import 'package:chick_chack_beta/models/mission.dart';
import 'package:chick_chack_beta/widgets/mission_card.dart';
import 'package:flutter/material.dart';

class MissionsList extends StatelessWidget {
  const MissionsList({
    super.key,
    required this.missions,
    required this.onRemoveMission,
  });

  final List<Mission> missions;
  final void Function(Mission expnse) onRemoveMission;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: missions.length,
      itemBuilder: (ctx, index) => Dismissible(
        //נותן את האופציה להחליק משימה ולמחוק אותה
        background: Container(
          color: Theme.of(context).colorScheme.error.withOpacity(0.75),
          margin: EdgeInsets.symmetric(
            horizontal: Theme.of(context).cardTheme.margin!.horizontal,
            vertical: Theme.of(context).cardTheme.margin!.vertical,
          ),
        ),
        key: ValueKey(
            missions[index]), //מזהה יחודי לויגט ("משימה") הספציפים שרוצים למחוק
        onDismissed: (direction) {
          onRemoveMission(missions[index]);
        },
        child: MissionCard(missions[index]),
      ),
    );
  }
}
