import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../cubit/personal_chat_cubit.dart';
import '../../cubit/personal_chat_state.dart';
import '../../data/repositories/personal_chat_repository.dart';
import '../widgets/message_bubble.dart';

class PersonalChatScreen extends StatelessWidget {
  final PersonalChatRepository? repository;

  const PersonalChatScreen({super.key, this.repository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PersonalChatCubit(repository: repository)..loadPersonalChat(),
      child: const _PersonalChatScreenView(),
    );
  }
}

class _PersonalChatScreenView extends StatefulWidget {
  const _PersonalChatScreenView();

  @override
  State<_PersonalChatScreenView> createState() =>
      _PersonalChatScreenViewState();
}

class _PersonalChatScreenViewState extends State<_PersonalChatScreenView> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    _textController.clear();
    context.read<PersonalChatCubit>().sendMessage(text);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundDark,
        elevation: 0,
        leading: IconButton(
          icon: Icon(AppIcons.back, color: Colors.white, size: 22.r),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CLO AI',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Personal Companion',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11.5.sp,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<PersonalChatCubit, PersonalChatState>(
          listener: (context, state) {
            WidgetsBinding.instance.addPostFrameCallback(
              (_) => _scrollToBottom(),
            );
          },
          builder: (context, state) {
            if (state.status == PersonalChatStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryAccent,
                ),
              );
            }

            return Column(
              children: [
                // Messages List
                Expanded(
                  child: state.messages.isEmpty
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 32.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 64.r,
                                  height: 64.r,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withValues(alpha: 0.05),
                                  ),
                                  child: Icon(
                                    AppIcons.heart,
                                    color: AppColors.primaryAccent,
                                    size: 30.r,
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  'Your Personal Space',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  'Share your thoughts, feelings, ideas, or daily reflections with CLO AI.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 13.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 12.h,
                          ),
                          itemCount: state.messages.length,
                          itemBuilder: (context, index) {
                            final message = state.messages[index];
                            return MessageBubble(message: message);
                          },
                        ),
                ),

                if (state.isSending)
                  Padding(
                    padding: EdgeInsets.only(left: 20.w, bottom: 8.h),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 14.r,
                          height: 14.r,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primaryAccent,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'CLO AI is thinking...',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Input Bar
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF161622),
                    border: Border(
                      top: BorderSide(
                        color: Colors.white.withValues(alpha: 0.08),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                          ),
                          cursorColor: AppColors.primaryAccent,
                          decoration: InputDecoration(
                            hintText: 'Share what\'s on your mind...',
                            hintStyle: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13.5.sp,
                            ),
                            border: InputBorder.none,
                          ),
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      GestureDetector(
                        key: const Key('send_personal_message_button'),
                        onTap: _sendMessage,
                        child: Container(
                          width: 42.r,
                          height: 42.r,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [Color(0xFFC451A4), Color(0xFFBA42A2)],
                            ),
                          ),
                          child: Icon(
                            AppIcons.send,
                            color: Colors.white,
                            size: 18.r,
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
