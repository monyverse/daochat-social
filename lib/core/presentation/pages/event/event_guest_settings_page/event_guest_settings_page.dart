import 'package:app/core/application/event/create_event_bloc/create_event_bloc.dart';
import 'package:app/core/presentation/pages/setting/widgets/setting_tile_widget.dart';
import 'package:app/core/presentation/widgets/common/appbar/lemon_appbar_widget.dart';
import 'package:app/core/presentation/widgets/lemon_text_field.dart';
import 'package:app/i18n/i18n.g.dart';
import 'package:app/theme/color.dart';
import 'package:app/theme/spacing.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

enum EventPrivacy { public, private }

@RoutePage()
class EventGuestSettingsPage extends StatefulWidget {
  const EventGuestSettingsPage({Key? key}) : super(key: key);

  @override
  State<EventGuestSettingsPage> createState() => _EventGuestSettingsPageState();
}

class _EventGuestSettingsPageState extends State<EventGuestSettingsPage> {
  final TextEditingController guestLimitPerController = TextEditingController();
  final TextEditingController guestLimitController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final createEventBloc = context.read<CreateEventBloc>().state;
    guestLimitPerController.text = createEventBloc.guestLimitPer ?? "";
    guestLimitController.text = createEventBloc.guestLimit ?? "";
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final t = Translations.of(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: LemonAppBar(
          backgroundColor: colorScheme.onPrimaryContainer,
          title: t.event.eventCreation.guestSettings,
        ),
        backgroundColor: colorScheme.onPrimaryContainer,
        body: SingleChildScrollView(child: _buildContent(colorScheme)),
        resizeToAvoidBottomInset: true,
      ),
    );
  }

  Widget _buildContent(ColorScheme colorScheme) {
    return BlocBuilder<CreateEventBloc, CreateEventState>(
      builder: (context, state) {
        return Column(
          children: [
            _buildSegmentedButton(colorScheme),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Spacing.xSmall,
                vertical: Spacing.xSmall,
              ),
              child: Column(
                children: [
                  _buildSettingTile(
                    title: "Auto Approve",
                    subTitle: "All requests to join instantly approved",
                    value: state.verify,
                    onChanged: (value) {
                      Vibrate.feedback(FeedbackType.light);
                      context
                          .read<CreateEventBloc>()
                          .add(VerifyChanged(verify: value));
                    },
                  ),
                  SizedBox(
                    height: Spacing.xSmall,
                  ),
                  _buildContainer(
                    _buildSettingTile(
                      title: "Guest unlock limit",
                      subTitle:
                          "Number of friends and matches a guest can unlock this experience for",
                      value: state.guestLimitPer == null,
                      onChanged: (value) =>
                          _onGuestLimitPerToggle(value, state),
                      trailing: SizedBox(
                        width: 60.w,
                        child: LemonTextField(
                          textInputType: TextInputType.number,
                          controller: guestLimitPerController,
                          contentPadding: EdgeInsets.all(Spacing.small),
                          onChange: (value) => context
                              .read<CreateEventBloc>()
                              .add(GuestLimitPerChanged(guestLimitPer: value)),
                          readOnly: state.guestLimitPer == null,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Spacing.xSmall,
                  ),
                  _buildContainer(
                    _buildSettingTile(
                      title: "No unlock limit",
                      value: state.guestLimitPer == null,
                      onChanged: (value) =>
                          _onNoGuestLimitPerToggle(value, state),
                      subTitle: '',
                    ),
                  ),
                  SizedBox(
                    height: Spacing.xSmall,
                  ),
                  _buildContainer(
                    _buildSettingTile(
                      title: "Total guest limit",
                      subTitle:
                          "Total number of people who can attend this experience",
                      value: state.guestLimit == null,
                      onChanged: (value) => _onGuestLimitToggle(value, state),
                      trailing: SizedBox(
                        width: 60.w,
                        child: LemonTextField(
                          textInputType: TextInputType.number,
                          controller: guestLimitController,
                          contentPadding: EdgeInsets.all(Spacing.small),
                          onChange: (value) => context
                              .read<CreateEventBloc>()
                              .add(GuestLimitChanged(guestLimit: value)),
                          readOnly: state.guestLimit == null,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Spacing.xSmall,
                  ),
                  _buildContainer(
                    _buildSettingTile(
                      title: "No guest limit",
                      value: state.guestLimit == null,
                      onChanged: (value) => _onNoGuestLimitToggle(value, state),
                      subTitle: '',
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSegmentedButton(ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Spacing.xSmall),
      width: double.maxFinite,
      child: SegmentedButton(
        segments: [
          ButtonSegment(
            value: EventPrivacy.public.name,
            label: const Text("Public"),
            icon: const Icon(Icons.visibility_off_outlined),
          ),
          ButtonSegment(
            value: EventPrivacy.private.name,
            label: const Text("Private"),
            icon: const Icon(Icons.visibility_outlined),
          ),
        ],
        selected: {EventPrivacy.public.name},
      ),
    );
  }

  Widget _buildSettingTile({
    required String title,
    required String subTitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    Widget? trailing,
  }) {
    return SettingTileWidget(
      title: title,
      subTitle: subTitle,
      onTap: () => {},
      trailing: trailing ??
          FlutterSwitch(
            inactiveColor:
                Theme.of(context).colorScheme.onPrimary.withOpacity(0.12),
            inactiveToggleColor:
                Theme.of(context).colorScheme.onPrimary.withOpacity(0.18),
            activeColor: LemonColor.switchActive,
            activeToggleColor: Theme.of(context).colorScheme.onPrimary,
            height: 24.h,
            width: 42.w,
            value: value,
            onToggle: onChanged,
          ),
    );
  }

  Widget _buildContainer(Widget child) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(LemonRadius.normal),
      ),
      clipBehavior: Clip.hardEdge,
      child: child,
    );
  }

  void _onGuestLimitPerToggle(bool value, CreateEventState state) {
    guestLimitPerController.text = value ? '' : '2';
    context.read<CreateEventBloc>().add(
          GuestLimitPerChanged(
            guestLimitPer: value ? null : "2",
          ),
        );
  }

  void _onNoGuestLimitPerToggle(bool value, CreateEventState state) {
    guestLimitPerController.text = value ? '' : '2';
    context.read<CreateEventBloc>().add(
          GuestLimitPerChanged(
            guestLimitPer: value ? null : "2",
          ),
        );
  }

  void _onGuestLimitToggle(bool value, CreateEventState state) {
    guestLimitController.text = value ? '' : '100';
    context.read<CreateEventBloc>().add(
          GuestLimitChanged(
            guestLimit: value ? null : "100",
          ),
        );
  }

  void _onNoGuestLimitToggle(bool value, CreateEventState state) {
    guestLimitController.text = value ? '' : '100';
    context.read<CreateEventBloc>().add(
          GuestLimitChanged(
            guestLimit: value ? null : "100",
          ),
        );
  }
}
