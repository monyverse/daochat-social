import 'package:app/core/domain/farcaster/entities/airstack_farcaster_cast.dart';
import 'package:app/core/domain/farcaster/entities/farcaster_channel.dart';
import 'package:app/core/presentation/pages/farcaster/widgets/farcaster_cast_item_widget/farcaster_cast_item_widget.dart';
import 'package:app/core/presentation/pages/farcaster/farcaster_channel_newsfeed_page/widgets/farcaster_channel_detail_popup.dart';
import 'package:app/core/presentation/widgets/common/appbar/lemon_appbar_widget.dart';
import 'package:app/core/presentation/widgets/common/list/empty_list_widget.dart';
import 'package:app/core/presentation/widgets/lemon_network_image/lemon_network_image.dart';
import 'package:app/core/presentation/widgets/loading_widget.dart';
import 'package:app/core/presentation/widgets/theme_svg_icon_widget.dart';
import 'package:app/core/utils/debouncer.dart';
import 'package:app/core/utils/gql/gql.dart';
import 'package:app/gen/assets.gen.dart';
import 'package:app/graphql/farcaster_airstack/query/get_farcaster_casts.graphql.dart';
import 'package:app/injection/register_module.dart';
import 'package:app/theme/spacing.dart';
import 'package:app/theme/typo.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

@RoutePage()
class FarcasterChannelNewsfeedPage extends StatefulWidget {
  final FarcasterChannel channel;
  const FarcasterChannelNewsfeedPage({
    super.key,
    required this.channel,
  });

  @override
  State<FarcasterChannelNewsfeedPage> createState() =>
      _FarcasterChannelNewsfeedPageState();
}

class _FarcasterChannelNewsfeedPageState
    extends State<FarcasterChannelNewsfeedPage>
    with SingleTickerProviderStateMixin {
  bool channelInfoVisible = false;
  final debouncer = Debouncer(milliseconds: 300);
  late ValueNotifier<GraphQLClient> airstackClient;
  final _refreshController = RefreshController();
  late final AnimationController _animation;

  @override
  initState() {
    super.initState();
    airstackClient = ValueNotifier(getIt<AirstackGQL>().client);
    _animation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  dispose() {
    _animation.dispose();
    debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: LemonAppBar(
        actions: [
          SizedBox(
            width: Spacing.xLarge,
          ),
        ],
        titleBuilder: (context) => InkWell(
          onTap: () {
            if (_animation.value == 0) {
              _animation.forward();
              setState(() {
                channelInfoVisible = true;
              });
            } else {
              _animation.reverse();
              setState(() {
                channelInfoVisible = false;
              });
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LemonNetworkImage(
                width: 27.w,
                height: 27.w,
                imageUrl: widget.channel.imageUrl ?? '',
                borderRadius: BorderRadius.circular(LemonRadius.extraSmall),
              ),
              SizedBox(width: Spacing.xSmall),
              Flexible(
                child: Text(
                  widget.channel.id?.isNotEmpty == true
                      ? '/${widget.channel.id}'
                      : '',
                  style: Typo.medium.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                ),
              ),
              SizedBox(width: Spacing.xSmall),
              ThemeSvgIcon(
                color: colorScheme.onSecondary,
                builder: (filter) => channelInfoVisible
                    ? Assets.icons.icArrowDown.svg(
                        colorFilter: filter,
                      )
                    : Assets.icons.icArrowUp.svg(
                        colorFilter: filter,
                      ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: Assets.images.bgChat.provider(),
                fit: BoxFit.cover,
              ),
            ),
            child: GraphQLProvider(
              client: airstackClient,
              child: Query$GetFarCasterCasts$Widget(
                options: Options$Query$GetFarCasterCasts(
                  fetchPolicy: FetchPolicy.cacheFirst,
                  variables: Variables$Query$GetFarCasterCasts(
                    rootParentUrl: widget.channel.url,
                  ),
                  onComplete: (_, __) {
                    _refreshController.refreshCompleted();
                  },
                ),
                builder: (
                  result, {
                  refetch,
                  fetchMore,
                }) {
                  final casts = (result.parsedData?.FarcasterCasts?.Cast ?? [])
                      .map(
                        (item) => AirstackFarcasterCast.fromJson(
                          item.toJson(),
                        ),
                      )
                      .toList();
                  if (result.isLoading && casts.isEmpty) {
                    return Center(
                      child: Loading.defaultLoading(context),
                    );
                  }

                  if (casts.isEmpty || result.hasException) {
                    return const Center(
                      child: EmptyList(),
                    );
                  }

                  return NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification is ScrollEndNotification) {
                        if (notification.metrics.pixels ==
                            notification.metrics.maxScrollExtent) {
                          final pageInfo =
                              result.parsedData?.FarcasterCasts?.pageInfo;
                          if (result.isLoading ||
                              pageInfo?.hasNextPage == false) {
                            return true;
                          }

                          final fetchMoreOptions =
                              FetchMoreOptions$Query$GetFarCasterCasts(
                            variables: Variables$Query$GetFarCasterCasts(
                              rootParentUrl: widget.channel.url,
                              cursor: pageInfo?.nextCursor,
                            ),
                            updateQuery: (prevResult, nextResult) {
                              final prevList = prevResult?['FarcasterCasts']
                                      ?['Cast'] as List<dynamic>? ??
                                  [];
                              final nextList = nextResult?['FarcasterCasts']
                                      ?['Cast'] as List<dynamic>? ??
                                  [];
                              final newList = [...prevList, ...nextList];
                              nextResult?['FarcasterCasts']['Cast'] = newList;
                              return nextResult;
                            },
                          );
                          debouncer.run(
                            () => fetchMore?.call(fetchMoreOptions),
                          );
                        }
                      }
                      return true;
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Spacing.xSmall,
                      ),
                      child: SmartRefresher(
                        controller: _refreshController,
                        onRefresh: () async {
                          refetch?.call();
                        },
                        child: CustomScrollView(
                          slivers: [
                            SliverList.separated(
                              itemCount: casts.length + 1,
                              itemBuilder: (context, index) {
                                if (index == casts.length) {
                                  if (result.parsedData?.FarcasterCasts
                                          ?.pageInfo?.hasNextPage !=
                                      true) {
                                    return const SizedBox.shrink();
                                  }
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: Spacing.medium,
                                    ),
                                    child: Loading.defaultLoading(context),
                                  );
                                }
                                return FarcasterCastItemWidget(
                                  key: ValueKey(casts[index].id),
                                  cast: casts[index],
                                  showActions: true,
                                );
                              },
                              separatorBuilder: (context, index) => Divider(
                                height: 1.w,
                                color: colorScheme.outline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Column(
            children: [
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, -1),
                  end: Offset.zero,
                ).animate(_animation),
                child: GraphQLProvider(
                  client: airstackClient,
                  child: FarcasterChannelDetailPopup(
                    channel: widget.channel,
                  ),
                ),
              ),
              if (channelInfoVisible)
                Expanded(
                  child: FadeTransition(
                    opacity: Tween<double>(
                      begin: 0,
                      end: 1,
                    ).animate(_animation),
                    child: InkWell(
                      onTap: () {
                        _animation.reverse();
                        setState(() {
                          channelInfoVisible = false;
                        });
                      },
                      child: Container(
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
