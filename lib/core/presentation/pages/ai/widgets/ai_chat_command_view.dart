import 'package:app/core/presentation/widgets/ai/ai_chat_composer.dart';
import 'package:app/core/presentation/widgets/lemon_circle_avatar_widget.dart';
import 'package:app/core/presentation/widgets/theme_svg_icon_widget.dart';
import 'package:app/core/utils/modal_utils.dart';
import 'package:app/gen/assets.gen.dart';
import 'package:app/i18n/i18n.g.dart';
import 'package:app/router/app_router.gr.dart';
import 'package:app/theme/spacing.dart';
import 'package:app/theme/typo.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app/core/presentation/pages/ai/widgets/ai_chat_command_section.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

class AIChatCommandView extends StatelessWidget {
  const AIChatCommandView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final t = Translations.of(context);
    return Positioned(
      bottom: aiChatComposerHeight,
      left: 0.0,
      right: 0.0,
      child: Container(
        height: 400.h,
        decoration: BoxDecoration(
          color: colorScheme.surfaceVariant,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withOpacity(
                1.0,
              ),
              const Color.fromRGBO(23, 23, 23, 1.0),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Header(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              child: AiChatCommandSection(
                sectionLabel: t.ai.createCommand,
                commandList: [
                  {
                    'label': 'post',
                    'onPressed': () {
                      Vibrate.feedback(FeedbackType.light);
                      AutoRouter.of(context).navigate(const CreatePostRoute());
                    },
                  },
                  {
                    'label': 'room',
                    'onPressed': () {
                      Vibrate.feedback(FeedbackType.light);
                      showComingSoonDialog(context);
                    }
                  },
                  {
                    'label': 'event',
                    'onPressed': () {
                      showComingSoonDialog(context);
                    }
                  },
                  {
                    'label': 'poap',
                    'onPressed': () {
                      Vibrate.feedback(FeedbackType.light);
                      showComingSoonDialog(context);
                    }
                  },
                  {
                    'label': 'collectible',
                    'onPressed': () {
                      Vibrate.feedback(FeedbackType.light);
                      showComingSoonDialog(context);
                    }
                  },
                ],
              ),
            ),
            Container(height: 1, color: colorScheme.outline),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              child: AiChatCommandSection(
                sectionLabel: t.ai.discoverCommand,
                commandList: [
                  {
                    'label': 'events',
                    'onPressed': () {
                      Vibrate.feedback(FeedbackType.light);
                      showComingSoonDialog(context);
                    }
                  },
                  {
                    'label': 'badges',
                    'onPressed': () {
                      Vibrate.feedback(FeedbackType.light);
                      AutoRouter.of(context).navigate(PoapListingRoute());
                    }
                  },
                  {
                    'label': 'collaborators',
                    'onPressed': () {
                      Vibrate.feedback(FeedbackType.light);
                      showComingSoonDialog(context);
                    }
                  },
                  {
                    'label': 'collectibles',
                    'onPressed': () {
                      Vibrate.feedback(FeedbackType.light);
                      showComingSoonDialog(context);
                    }
                  },
                  {
                    'label': 'communities',
                    'onPressed': () {
                      Vibrate.feedback(FeedbackType.light);
                      showComingSoonDialog(context);
                    }
                  },
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final t = Translations.of(context);
    return Container(
      height: 84.h,
      padding: EdgeInsets.all(24.r),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1, color: colorScheme.outline),
        ),
      ),
      child: Row(
        children: [
          const LemonCircleAvatar(
            isLemonIcon: true,
          ),
          SizedBox(
            width: Spacing.small,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.ai.chattingWith,
                  style: Typo.small.copyWith(color: colorScheme.onSecondary),
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Text(
                      'Lulu',
                      style: Typo.medium.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 2,
                      height: 2,
                      decoration: ShapeDecoration(
                        color: Colors.white.withOpacity(0.5400000214576721),
                        shape: const OvalBorder(),
                      ),
                    ),
                    SizedBox(width: Spacing.superExtraSmall),
                    Text(
                      t.ai.personalAssistant,
                      style: Typo.medium.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          InkWell(
            onTap: () => showComingSoonDialog(context),
            child: ThemeSvgIcon(
              color: colorScheme.onSurfaceVariant,
              builder: (filter) => Assets.icons.icReload.svg(),
            ),
          ),
        ],
      ),
    );
  }
}
