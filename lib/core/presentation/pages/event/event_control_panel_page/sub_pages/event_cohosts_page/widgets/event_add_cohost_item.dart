import 'package:app/core/domain/user/entities/user.dart';
import 'package:app/core/presentation/widgets/lemon_circle_avatar_widget.dart';
import 'package:app/core/presentation/widgets/theme_svg_icon_widget.dart';
import 'package:app/core/utils/avatar_utils.dart';
import 'package:app/gen/assets.gen.dart';
import 'package:app/theme/sizing.dart';
import 'package:app/theme/spacing.dart';
import 'package:app/theme/typo.dart';
import 'package:flutter/material.dart';

class EventAddCohostItem extends StatelessWidget {
  final User? user;
  final Function onPressItem;
  final bool? selected;

  const EventAddCohostItem({
    super.key,
    this.user,
    required this.onPressItem,
    this.selected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () async {
        onPressItem();
      },
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    LemonCircleAvatar(
                      size: Sizing.medium,
                      url: AvatarUtils.getAvatarUrl(user: user),
                    ),
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Spacing.extraSmall),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.name ?? '',
                              style: Typo.small.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  selected == true
                      ? ThemeSvgIcon(
                          color: colorScheme.onPrimary,
                          builder: (colorFilter) => Assets.icons.icChecked.svg(
                            colorFilter: colorFilter,
                          ),
                        )
                      : ThemeSvgIcon(
                          color: colorScheme.onPrimary,
                          builder: (colorFilter) => Assets.icons.icAdd.svg(
                            colorFilter: colorFilter,
                          ),
                        ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
