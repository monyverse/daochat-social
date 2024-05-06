import 'package:app/core/presentation/widgets/bottomsheet_grabber/bottomsheet_grabber.dart';
import 'package:app/core/presentation/widgets/common/appbar/lemon_appbar_widget.dart';
import 'package:app/core/presentation/widgets/common/button/linear_gradient_button_widget.dart';
import 'package:app/core/presentation/widgets/lemon_text_field.dart';
import 'package:app/gen/assets.gen.dart';
import 'package:app/i18n/i18n.g.dart';
import 'package:app/theme/color.dart';
import 'package:app/theme/spacing.dart';
import 'package:app/theme/typo.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:slang/builder/utils/string_extensions.dart';

List<String> expertiseList = [
  "Artist",
  "Copy Writer",
  "Data Analyst",
  "Designer",
  "Digital Marketing",
  "Product Management",
  "Product Development",
  "Rapper",
  "Researcher",
  "Sales Consultant",
];

class CollaboratorEditExpertiseBottomSheet extends StatefulWidget {
  const CollaboratorEditExpertiseBottomSheet({super.key});

  @override
  CollaboratorEditExpertiseBottomSheetState createState() =>
      CollaboratorEditExpertiseBottomSheetState();
}

class CollaboratorEditExpertiseBottomSheetState
    extends State<CollaboratorEditExpertiseBottomSheet> {
  List<String> selectedExpertises = [];
  String searchValue = '';

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      color: LemonColor.atomicBlack,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const BottomSheetGrabber(),
          LemonAppBar(
            title: t.collaborator.expertise,
            backgroundColor: LemonColor.atomicBlack,
          ),
          Padding(
            padding: EdgeInsets.only(
              left: Spacing.smMedium,
              right: Spacing.smMedium,
              top: Spacing.xSmall,
              bottom: Spacing.smMedium,
            ),
            child: LemonTextField(
              hintText: t.common.search.capitalize(),
              contentPadding: EdgeInsets.all(Spacing.small),
              onChange: (value) {
                setState(() {
                  searchValue = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Spacing.smMedium),
              child: ListView.builder(
                itemCount: expertiseList.length,
                padding: EdgeInsets.only(bottom: Spacing.large),
                itemBuilder: (BuildContext context, int index) {
                  final expertise = expertiseList[index];
                  final expertiseLower = expertise.toLowerCase();
                  if (expertiseLower.contains(searchValue)) {
                    final isChecked = selectedExpertises.contains(expertise);
                    return _ExpertiseItem(
                      expertise: expertise,
                      isChecked: isChecked,
                      onChecked: (isChecked) {
                        setState(() {
                          if (isChecked) {
                            selectedExpertises.add(expertise);
                          } else {
                            selectedExpertises.remove(expertise);
                          }
                        });
                      },
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                color: LemonColor.atomicBlack,
                border: Border(top: BorderSide(color: colorScheme.outline)),
              ),
              padding: EdgeInsets.all(Spacing.smMedium),
              child: SafeArea(
                child: Opacity(
                  opacity: selectedExpertises.isNotEmpty ? 1 : 0.5,
                  child: LinearGradientButton.primaryButton(
                    onTap: () {
                      if (kDebugMode) {
                        print('selectedExpertises : $selectedExpertises');
                      }
                      Vibrate.feedback(FeedbackType.light);
                      FocusManager.instance.primaryFocus?.unfocus();
                      AutoRouter.of(context).pop();
                    },
                    label: t.common.apply,
                    textColor: colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpertiseItem extends StatelessWidget {
  final String expertise;
  final bool isChecked;
  final Function(bool) onChecked;

  const _ExpertiseItem({
    required this.expertise,
    required this.isChecked,
    required this.onChecked,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () {
        onChecked(!isChecked);
      },
      child: Container(
        padding: EdgeInsets.all(Spacing.small),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expertise,
                    style: Typo.mediumPlus.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            isChecked
                ? Assets.icons.icChecked.svg()
                : Assets.icons.icUncheck.svg(),
          ],
        ),
      ),
    );
  }
}
