import 'package:app/core/application/chat/new_chat_bloc/new_chat_bloc.dart';
import 'package:app/core/presentation/pages/chat/new_chat/widgets/search_user_input.dart';
import 'package:app/core/presentation/pages/chat/new_chat/widgets/search_user_item.dart';
import 'package:app/core/presentation/widgets/common/appbar/lemon_appbar_widget.dart';
import 'package:app/core/presentation/widgets/loading_widget.dart';
import 'package:app/core/utils/debouncer.dart';
import 'package:app/i18n/i18n.g.dart';
import 'package:app/theme/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:matrix/matrix.dart' as sdk;
import 'package:matrix/matrix.dart';

class NewChatView extends StatelessWidget {
  final debouncer = Debouncer(milliseconds: 300);

  NewChatView({super.key});

  void onSearchChanged(BuildContext context, String value) {
    debouncer.run(() {
      context.read<NewChatBloc>().add(NewChatEvent.searchUsers(text: value));
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final t = Translations.of(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context)
            .unfocus(); // Dismiss keyboard when tapped outside
      },
      child: Scaffold(
        appBar: LemonAppBar(
          backgroundColor: colorScheme.onPrimaryContainer,
          title: t.chat.newMessage,
          actions: [
            StartButton(
              onTap: () async {
                context.read<NewChatBloc>().startChat(context);
              },
            ),
          ],
        ),
        backgroundColor: colorScheme.onPrimaryContainer,
        body: BlocBuilder<NewChatBloc, NewChatState>(
          builder: (context, newChatState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: 6.h,
                    bottom: 12.h,
                    left: 18.w,
                    right: 18.w,
                  ),
                  child: SearchUserInput(
                    selectedUsers: newChatState.selectedUsers,
                    onChanged: (value) => onSearchChanged(context, value),
                  ),
                ),
                if (newChatState.isSearching) ...[
                  Padding(
                    padding: EdgeInsets.only(top: Spacing.medium),
                    child: Loading.defaultLoading(context),
                  )
                ] else if (newChatState.userSearchResult != null) ...[
                  Expanded(
                    child: _buildUserList(newChatState, context),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildUserList(NewChatState newChatState, BuildContext context) {
    final t = Translations.of(context);

    return ListView.builder(
      itemCount: newChatState.userSearchResult?.results.length,
      itemBuilder: (context, i) {
        final userResult = newChatState.userSearchResult?.results[i];
        final userId = userResult?.userId ?? '';
        final isSelected = newChatState.selectedUsers.isNotEmpty &&
            newChatState.selectedUsers
                .any((profile) => profile.userId == userId);

        return SearchUserItem(
          isSelected: isSelected,
          name: userResult?.displayName ??
              userId.localpart ??
              t.chat.unknownDevice,
          avatarUrl: userResult?.avatarUrl,
          onTap: () {
            if (isSelected) {
              context.read<NewChatBloc>().add(
                    NewChatEvent.deselectUser(user: userResult!),
                  );
            } else {
              context.read<NewChatBloc>().add(
                    NewChatEvent.selectUser(user: userResult!),
                  );
            }
          },
        );
      },
    );
  }
}

class StartButton extends StatelessWidget {
  final Function() onTap;

  const StartButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        alignment: Alignment.centerRight,
        child: Text(
          t.common.start,
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 16.0, // Adjust the font size as needed
          ),
        ),
      ),
    );
  }
}
