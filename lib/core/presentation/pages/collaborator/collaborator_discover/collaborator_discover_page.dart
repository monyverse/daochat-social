import 'package:app/core/presentation/pages/collaborator/collaborator_discover/widgets/collaborator_discover_actions_bar.dart';
import 'package:app/core/presentation/pages/collaborator/collaborator_discover/widgets/collaborator_discover_view.dart';
import 'package:app/core/presentation/widgets/common/appbar/lemon_appbar_widget.dart';
import 'package:app/core/presentation/widgets/theme_svg_icon_widget.dart';
import 'package:app/gen/assets.gen.dart';
import 'package:app/theme/spacing.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@RoutePage()
class CollaboratorDiscoverPage extends StatelessWidget {
  const CollaboratorDiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.primary,
      appBar: LemonAppBar(
        actions: [
          Padding(
            padding: EdgeInsets.only(right: Spacing.medium),
            child: InkWell(
              onTap: () {},
              child: Icon(
                Icons.filter_alt_outlined,
                color: colorScheme.onPrimary,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: Spacing.medium),
            child: InkWell(
              onTap: () {},
              child: Icon(
                Icons.favorite_border,
                color: colorScheme.onPrimary,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: Spacing.smMedium),
            child: InkWell(
              onTap: () {},
              child: ThemeSvgIcon(
                color: colorScheme.onPrimary,
                builder: (filter) => Assets.icons.icChatBubble.svg(
                  colorFilter: filter,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: Spacing.xSmall),
            child: InkWell(
              onTap: () {},
              child: Icon(
                Icons.more_vert,
                color: colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: const Stack(
          children: [
            CustomScrollView(
              slivers: [
                CollaboratorDiscoverView(),
              ],
            ),
            CollaboratorDiscoverActionsBar()
          ],
        ),
      ),
    );
  }
}
