import 'package:app/core/domain/badge/entities/badge_entities.dart';
import 'package:app/core/presentation/widgets/lemon_circle_avatar_widget.dart';
import 'package:app/theme/color.dart';
import 'package:app/theme/spacing.dart';
import 'package:app/theme/typo.dart';
import 'package:flutter/material.dart';

class PoapCreatorItem extends StatelessWidget {
  const PoapCreatorItem({
    super.key,
    required this.badgeCollection,
    this.onTap,
    this.selected = false,
  });

  final BadgeList badgeCollection;
  final void Function(BadgeList collection)? onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () {
        onTap?.call(badgeCollection);
      },
      child: SizedBox(
        width: 78,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                border: Border.all(
                  color: selected ? LemonColor.lavender : colorScheme.outline,),
                borderRadius: BorderRadius.circular(70),
              ),
              child: LemonCircleAvatar(
                url: badgeCollection.imageUrl ?? '',
                size: 70,
              ),
            ),
            SizedBox(height: Spacing.superExtraSmall),
            Text(
              badgeCollection.title ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Typo.xSmall,
            )
          ],
        ),
      ),
    );
  }
}
