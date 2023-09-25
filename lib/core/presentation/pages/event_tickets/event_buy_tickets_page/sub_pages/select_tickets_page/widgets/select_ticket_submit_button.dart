import 'package:app/core/application/event/accept_event_bloc/accept_event_bloc.dart';
import 'package:app/core/application/event_tickets/assign_tickets_bloc/assign_tickets_bloc.dart';
import 'package:app/core/application/event_tickets/redeem_tickets_bloc/redeem_tickets_bloc.dart';
import 'package:app/core/application/event_tickets/select_event_tickets_bloc/select_event_tickets_bloc.dart';
import 'package:app/core/presentation/widgets/common/button/linear_gradient_button_widget.dart';
import 'package:app/i18n/i18n.g.dart';
import 'package:app/theme/sizing.dart';
import 'package:app/theme/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectTicketSubmitButton extends StatelessWidget {
  const SelectTicketSubmitButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final redeemState = context.watch<RedeemTicketsBloc>().state;
    final acceptEventState = context.watch<AcceptEventBloc>().state;
    final assignTicketsState = context.watch<AssignTicketsBloc>().state;
    final isLoading = redeemState is RedeemTicketsStateLoading ||
        acceptEventState is AcceptEventStateLoading ||
        assignTicketsState is AssignTicketsStateLoading;

    return BlocBuilder<SelectEventTicketTypesBloc, SelectEventTicketTypesState>(
      builder: (context, state) => Padding(
        padding: EdgeInsets.symmetric(horizontal: Spacing.smMedium),
        child: SizedBox(
          height: Sizing.large,
          child: Opacity(
            opacity: !state.isSelectionValid || isLoading ? 0.5 : 1,
            child: LinearGradientButton(
              onTap: () async {
                // TODO:
                // right now only support free flow that why
                // redeem directly after click next
                // we will handle calculate and navigate to summary page if tickets
                // have cost
                if (!state.isSelectionValid || isLoading) return;
                context.read<RedeemTicketsBloc>().add(
                      RedeemTicketsEvent.redeem(
                        ticketItems: state.selectedTicketTypes,
                      ),
                    );
              },
              radius: BorderRadius.circular(LemonRadius.small * 2),
              label: isLoading ? t.common.processing : t.common.next,
              mode: GradientButtonMode.lavenderMode,
            ),
          ),
        ),
      ),
    );
  }
}
