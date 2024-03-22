import 'package:app/core/domain/event/entities/event_ticket_category.dart';
import 'package:app/core/domain/event/entities/event_ticket_types.dart';
import 'package:app/core/presentation/widgets/theme_svg_icon_widget.dart';
import 'package:app/core/utils/event_tickets_utils.dart';
import 'package:app/gen/assets.gen.dart';
import 'package:app/gen/fonts.gen.dart';
import 'package:app/i18n/i18n.g.dart';
import 'package:app/theme/sizing.dart';
import 'package:app/theme/spacing.dart';
import 'package:app/theme/typo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EventBuyTicketsCategoryItem extends StatelessWidget {
  final EventTicketCategory? ticketCategory;
  final List<PurchasableTicketType> allTicketTypes;
  final Function(String? category) onSelect;

  const EventBuyTicketsCategoryItem({
    super.key,
    required this.ticketCategory,
    required this.allTicketTypes,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final count = EventTicketUtils.filterTicketTypeByCategory(
      allTicketTypes,
      category: ticketCategory?.id,
    ).length;
    return InkWell(
      onTap: () => onSelect(ticketCategory?.id),
      child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (ticketCategory == null && count != 0)
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: Spacing.smMedium,
                  horizontal: Spacing.smMedium,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    24.r,
                  ),
                  color: colorScheme.onPrimary.withOpacity(0.06),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ThemeSvgIcon(
                          color: colorScheme.onPrimary,
                          builder: (colorFilter) => Assets.icons.icTicket.svg(
                            colorFilter: colorFilter,
                            width: Sizing.xSmall,
                            height: Sizing.xSmall,
                          ),
                        ),
                        SizedBox(width: Spacing.superExtraSmall),
                        Text(
                          '$count ${t.event.otherTickets(n: count)}',
                          style: Typo.small.copyWith(
                            color: colorScheme.onPrimary,
                          ),
                        ),
                      ],
                    ),
                    ThemeSvgIcon(
                      color: colorScheme.onSecondary,
                      builder: (colorFilter) => Assets.icons.icArrowRight.svg(
                        colorFilter: colorFilter,
                        width: Sizing.xSmall,
                        height: Sizing.xSmall,
                      ),
                    ),
                  ],
                ),
              ),
            if (ticketCategory != null) ...[
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(Spacing.smMedium),
                decoration: BoxDecoration(
                  color: colorScheme.onPrimary.withOpacity(0.03),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(LemonRadius.button),
                    topLeft: Radius.circular(LemonRadius.button),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      ticketCategory!.title ?? '',
                      style: Typo.extraMedium.copyWith(
                        color: colorScheme.onPrimary,
                        fontFamily: FontFamily.nohemiVariable,
                      ),
                    ),
                    if (ticketCategory?.description?.isNotEmpty == true) ...[
                      SizedBox(height: 2.w),
                      Text(
                        ticketCategory!.description ?? '',
                        style: Typo.small.copyWith(
                          color: colorScheme.onSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(Spacing.smMedium),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(LemonRadius.button),
                    bottomLeft: Radius.circular(LemonRadius.button),
                  ),
                  color: colorScheme.onPrimary.withOpacity(0.06),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ThemeSvgIcon(
                          color: colorScheme.onPrimary,
                          builder: (colorFilter) => Assets.icons.icTicket.svg(
                            colorFilter: colorFilter,
                            width: Sizing.xSmall,
                            height: Sizing.xSmall,
                          ),
                        ),
                        SizedBox(width: Spacing.superExtraSmall),
                        Text(
                          '$count ${t.event.tickets(n: count)}',
                          style: Typo.small.copyWith(
                            color: colorScheme.onPrimary,
                          ),
                        ),
                      ],
                    ),
                    ThemeSvgIcon(
                      color: colorScheme.onSecondary,
                      builder: (colorFilter) => Assets.icons.icArrowRight.svg(
                        colorFilter: colorFilter,
                        width: Sizing.xSmall,
                        height: Sizing.xSmall,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
