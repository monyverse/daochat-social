import 'package:app/core/application/auth/auth_bloc.dart';
import 'package:app/core/application/event/get_event_detail_bloc/get_event_detail_bloc.dart';
import 'package:app/core/application/event/get_event_reward_uses_bloc/get_event_reward_uses_bloc.dart';
import 'package:app/core/domain/user/user_repository.dart';
import 'package:app/core/presentation/pages/event/event_detail_page/guest_event_detail_page/sub_pages/guest_event_reward_uses_page/widgets/guest_event_reward_uses_listing.dart';
import 'package:app/core/presentation/widgets/common/appbar/lemon_appbar_widget.dart';
import 'package:app/core/presentation/widgets/loading_widget.dart';
import 'package:app/gen/fonts.gen.dart';
import 'package:app/i18n/i18n.g.dart';
import 'package:app/injection/register_module.dart';
import 'package:app/theme/spacing.dart';
import 'package:app/theme/typo.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class GuestEventRewardUsesPage extends StatelessWidget {
  const GuestEventRewardUsesPage({super.key});

  @override
  Widget build(BuildContext context) {
    String userId = context.watch<AuthBloc>().state.maybeWhen(
              authenticated: (authSession) => authSession.userId,
              orElse: () => "",
            ) ??
        "";
    String eventId = context.watch<GetEventDetailBloc>().state.maybeWhen(
              fetched: (event) => event.id,
              orElse: () => "",
            ) ??
        "";
    return BlocProvider(
      create: (context) => GetEventRewardUsesBloc(eventId)
        ..add(
          GetEventRewardUsesEvent.getEventRewardUses(
            showLoading: true,
            userId: userId,
            eventId: eventId,
          ),
        ),
      child: _GuestEventRewardUsesPageView(userId: userId),
    );
  }
}

class _GuestEventRewardUsesPageView extends StatelessWidget {
  const _GuestEventRewardUsesPageView({required this.userId});
  final String userId;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: LemonAppBar(
        title: t.event.rewards,
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            leading: const SizedBox.shrink(),
            collapsedHeight: kToolbarHeight,
            pinned: true,
            flexibleSpace: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder(
                  future: getIt<UserRepository>().getUser(userId: userId),
                  builder: (context, snapshot) {
                    final user =
                        snapshot.data?.fold((l) => null, (user) => user);
                    return Padding(
                      padding: EdgeInsets.only(
                        left: Spacing.smMedium,
                        right: Spacing.smMedium,
                        top: Spacing.xSmall,
                      ),
                      child: Text(
                        user?.name ?? '',
                        style: Typo.superLarge.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.w800,
                          fontFamily: FontFamily.nohemiVariable,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          BlocBuilder<GetEventRewardUsesBloc, GetEventRewardUsesState>(
            builder: (context, state) {
              if (state.initialLoading == true) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(top: Spacing.large),
                    child: Loading.defaultLoading(context),
                  ),
                );
              }
              return GuestRewardUsesListing(userId: userId);
            },
          ),
        ],
      ),
    );
  }
}
