import 'package:app/core/application/event/event_datetime_settings_bloc/event_datetime_settings_bloc.dart';
import 'package:app/core/constants/event/event_constants.dart';
import 'package:app/core/presentation/widgets/common/appbar/lemon_appbar_widget.dart';
import 'package:app/core/presentation/widgets/common/button/linear_gradient_button_widget.dart';
import 'package:app/i18n/i18n.g.dart';
import 'package:app/theme/color.dart';
import 'package:app/theme/sizing.dart';
import 'package:app/theme/spacing.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:wheel_picker/wheel_picker.dart';

const double timezoneWheelSize = 225;

class TimezoneSelectBottomSheet extends StatefulWidget {
  const TimezoneSelectBottomSheet({super.key});

  @override
  State<TimezoneSelectBottomSheet> createState() =>
      _TimezoneSelectBottomSheetState();
}

class _TimezoneSelectBottomSheetState extends State<TimezoneSelectBottomSheet> {
  late String? selectedTimezone = '';
  @override
  void initState() {
    super.initState();
    final timezone = context.read<EventDateTimeSettingsBloc>().state.timezone;
    setState(() {
      selectedTimezone = timezone;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final timezone = context.read<EventDateTimeSettingsBloc>().state.timezone;
    final index = EventConstants.timezoneOptions
        .indexWhere((element) => element['value'] == timezone);
    late final timezoneWheelController = WheelPickerController(
      itemCount: EventConstants.timezoneOptions.length,
      initialIndex: index,
    );
    const textStyle = TextStyle(fontSize: 10.0, height: 3, color: Colors.white);
    final wheelStyle = WheelPickerStyle(
      size: timezoneWheelSize,
      itemExtent: textStyle.fontSize! * textStyle.height!,
      squeeze: 1.25,
      diameterRatio: 1,
      surroundingOpacity: .25,
      magnification: 1.2,
    );

    return SingleChildScrollView(
      controller: ModalScrollController.of(context),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: LemonColor.atomicBlack,
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              LemonAppBar(
                backgroundColor: LemonColor.atomicBlack,
                title: t.event.timezoneSetting.chooseTimezone,
              ),
              Stack(
                children: [
                  _centerBar(context),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: BlocBuilder<EventDateTimeSettingsBloc,
                        EventDateTimeSettingsState>(
                      builder: (context, state) {
                        return WheelPicker(
                          style: wheelStyle,
                          controller: timezoneWheelController,
                          builder: (BuildContext context, int index) {
                            String? textDisplay = EventConstants.timezoneOptions
                                    .toList()[index]['text'] ??
                                '';
                            return Text(
                              textDisplay,
                              style: textStyle,
                            );
                          },
                          selectedIndexColor: colorScheme.onPrimary,
                          onIndexChanged: (index) {
                            final element =
                                EventConstants.timezoneOptions.elementAt(index);
                            setState(() {
                              selectedTimezone = element['value'];
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: Spacing.smMedium,
                  horizontal: Spacing.xSmall,
                ),
                child: LinearGradientButton.primaryButton(
                  onTap: () {
                    context.read<EventDateTimeSettingsBloc>().add(
                          EventDateTimeSettingsEvent.timezoneChanged(
                            timezone: selectedTimezone ?? '',
                          ),
                        );
                    AutoRouter.of(context).pop();
                  },
                  label: t.common.actions.saveChanges,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _centerBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: timezoneWheelSize,
      padding: EdgeInsets.symmetric(horizontal: Spacing.smMedium),
      child: Center(
        child: Container(
          height: Sizing.medium,
          decoration: BoxDecoration(
            color: colorScheme.secondary,
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }
}
