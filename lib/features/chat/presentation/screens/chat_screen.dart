import 'package:clo_ai/core/constants/app_colors.dart';
import 'package:clo_ai/features/chat/cubit/chat_cubit.dart';
import 'package:clo_ai/features/chat/cubit/chat_state.dart';
import 'package:clo_ai/features/chat/data/repositories/chat_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatScreen extends StatelessWidget {
  final String relationshipId;
  final String personName;
  final String relationshipType;
  final ChatRepository? repository;
  final ChatCubit? cubit;

  const ChatScreen({
    super.key,
    required this.relationshipId,
    this.personName = 'Relationship',
    this.relationshipType = 'Friendship',
    this.repository,
    this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    if (cubit != null) {
      return BlocProvider.value(
        value: cubit!..loadChat(relationshipId),
        child: _ChatScreenView(
          personName: personName,
          relationshipType: relationshipType,
        ),
      );
    }

    return BlocProvider(
      create: (context) =>
          ChatCubit(repository: repository)..loadChat(relationshipId),
      child: _ChatScreenView(
        personName: personName,
        relationshipType: relationshipType,
      ),
    );
  }
}

class _ChatScreenView extends StatefulWidget {
  final String personName;
  final String relationshipType;

  const _ChatScreenView({
    required this.personName,
    required this.relationshipType,
  });

  @override
  State<_ChatScreenView> createState() => _ChatScreenViewState();
}

class _ChatScreenViewState extends State<_ChatScreenView> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _onSendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();
    context.read<ChatCubit>().sendMessage(text);
    _scrollToBottom();
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF161622),
          title: Text(
            'Delete Chat?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to delete this chat?',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14.sp),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14.sp,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<ChatCubit>().deleteChat();
              },
              child: Text(
                'Delete',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: BlocConsumer<ChatCubit, ChatState>(
          listener: (context, state) {
            if (state.errorMessage != null &&
                state.status != ChatStatus.error) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
            }
            if (state.messages.isNotEmpty) {
              _scrollToBottom();
            }
          },
          builder: (context, state) {
            final String displayName =
                state.chat?.context?.name.isNotEmpty == true
                ? state.chat!.context!.name
                : widget.personName;
            final String displayType =
                state.chat?.context?.relationshipType.isNotEmpty == true
                ? state.chat!.context!.relationshipType
                : widget.relationshipType;
            final String initial = displayName.isNotEmpty
                ? displayName[0].toUpperCase()
                : 'A';

            return Column(
              children: [
                // Top App Bar
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 10.h,
                  ),
                  child: Row(
                    children: [
                      // Back Arrow Button
                      GestureDetector(
                        onTap: () => Navigator.of(context).maybePop(),
                        child: Container(
                          width: 36.r,
                          height: 36.r,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.transparent,
                          ),
                          child: Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.white,
                            size: 24.r,
                          ),
                        ),
                      ),

                      const Spacer(),

                      // Title with Dropdown Chevron
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Chat',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Colors.white,
                            size: 22.r,
                          ),
                        ],
                      ),

                      const Spacer(),

                      // Glowing CLO Circular Icon Badge
                      Container(
                        width: 36.r,
                        height: 36.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF9B3B83), Color(0xFFE86B5A)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.smart_toy_rounded,
                            color: Colors.white,
                            size: 20.r,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),

                      // Three-Dot Overflow Menu Icon for Deleting Chat
                      PopupMenuButton<String>(
                        icon: Icon(
                          Icons.more_vert_rounded,
                          color: Colors.white,
                          size: 22.r,
                        ),
                        color: const Color(0xFF1C1C28),
                        onSelected: (value) {
                          if (value == 'delete') {
                            _showDeleteConfirmationDialog(context);
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.delete_outline_rounded,
                                  color: Colors.redAccent,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'Delete Chat',
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Relationship Header Card
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF14141D),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.08),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Avatar Circle Initial
                        Container(
                          width: 44.r,
                          height: 44.r,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF222230),
                          ),
                          child: Center(
                            child: Text(
                              initial,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 14.w),

                        // Relationship Text Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Analyzing your Relationship',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 13.sp,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: Text(
                                      displayName,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.w,
                                      vertical: 3.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF22222E),
                                      borderRadius: BorderRadius.circular(12.r),
                                      border: Border.all(
                                        color: Colors.white.withValues(
                                          alpha: 0.15,
                                        ),
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      displayType,
                                      style: TextStyle(
                                        color: Colors.white.withValues(
                                          alpha: 0.9,
                                        ),
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Chevron Right Dropdown Arrow
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AppColors.textSecondary,
                          size: 22.r,
                        ),
                      ],
                    ),
                  ),
                ),

                // Content View based on ChatStatus
                Expanded(
                  child: Builder(
                    builder: (context) {
                      if (state.status == ChatStatus.loading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryAccent,
                          ),
                        );
                      }

                      if (state.status == ChatStatus.error) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline_rounded,
                                  color: Colors.white70,
                                  size: 48.r,
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  state.errorMessage ??
                                      'Failed to load conversation',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                  ),
                                ),
                                SizedBox(height: 20.h),
                                ElevatedButton(
                                  onPressed: () {
                                    if (state.relationshipId != null) {
                                      context.read<ChatCubit>().loadChat(
                                        state.relationshipId!,
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                  ),
                                  child: const Text(
                                    'Retry',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      if (state.messages.isEmpty) {
                        return Center(
                          child: Text(
                            'No messages yet. Send a message to start conversing!',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14.sp,
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        itemCount: state.messages.length,
                        itemBuilder: (context, index) {
                          final message = state.messages[index];
                          final isUser = message.isUserMessage;

                          return Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: Align(
                              alignment: isUser
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      0.78 * MediaQuery.of(context).size.width,
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 14.h,
                                ),
                                decoration: BoxDecoration(
                                  color: isUser
                                      ? const Color(0xFF16161F)
                                      : const Color(0xFF20202A),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16.r),
                                    topRight: Radius.circular(16.r),
                                    bottomLeft: isUser
                                        ? Radius.circular(16.r)
                                        : Radius.circular(4.r),
                                    bottomRight: isUser
                                        ? Radius.circular(4.r)
                                        : Radius.circular(16.r),
                                  ),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.05),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  message.content,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w400,
                                    height: 1.35,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                // Bottom Message Composer
                Padding(
                  padding: EdgeInsets.only(
                    left: 16.w,
                    right: 16.w,
                    bottom: 12.h,
                    top: 6.h,
                  ),
                  child: Row(
                    children: [
                      // Small CLO Orb Avatar Thumbnail
                      Container(
                        width: 44.r,
                        height: 44.r,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14.r),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF9B3B83), Color(0xFFE86B5A)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Center(
                          child: Container(
                            width: 24.r,
                            height: 24.r,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.25),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),

                      // Message Input Field Pill Container
                      Expanded(
                        child: Container(
                          height: 50.h,
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFF181824),
                            borderRadius: BorderRadius.circular(25.r),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.1),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _messageController,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.sp,
                                  ),
                                  cursorColor: AppColors.primaryAccent,
                                  onSubmitted: (_) => _onSendMessage(),
                                  decoration: InputDecoration(
                                    hintText: 'Ask anything',
                                    hintStyle: TextStyle(
                                      color: AppColors.textSecondary.withValues(
                                        alpha: 0.65,
                                      ),
                                      fontSize: 15.sp,
                                    ),
                                    border: InputBorder.none,
                                    isDense: true,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                key: const Key('send_message_button'),
                                behavior: HitTestBehavior.opaque,
                                onTap: state.isSending ? null : _onSendMessage,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                    vertical: 8.h,
                                  ),
                                  child: state.isSending
                                      ? SizedBox(
                                          width: 18.r,
                                          height: 18.r,
                                          child:
                                              const CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                      Color
                                                    >(Colors.white),
                                              ),
                                        )
                                      : Icon(
                                          Icons.send_rounded,
                                          color: Colors.white,
                                          size: 20.r,
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
