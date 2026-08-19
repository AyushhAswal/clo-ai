import 'package:clo_ai/core/constants/app_colors.dart';
import 'package:clo_ai/features/chat/domain/models/chat_message_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatScreen extends StatefulWidget {
  final String personName;
  final String relationshipType;

  const ChatScreen({
    super.key,
    required this.personName,
    required this.relationshipType,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late List<ChatMessageModel> _messages;

  @override
  void initState() {
    super.initState();
    _initDummyMessages();
  }

  void _initDummyMessages() {
    final String name = widget.personName;
    _messages = [
      ChatMessageModel(
        id: '1',
        text: 'What do you want most from this relationship?',
        isUser: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
      ),
      ChatMessageModel(
        id: '2',
        text: 'Access, opportunity, or support.',
        isUser: true,
        timestamp: DateTime.now().subtract(const Duration(minutes: 8)),
      ),
      ChatMessageModel(
        id: '3',
        text: "What have you wanted to say to $name, but haven't?",
        isUser: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 6)),
      ),
      ChatMessageModel(
        id: '4',
        text: 'yo',
        isUser: true,
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      ChatMessageModel(
        id: '5',
        text: "What's your biggest question mark about $name?",
        isUser: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
      ),
      ChatMessageModel(
        id: '6',
        text: 'yo',
        isUser: true,
        timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
      ),
      ChatMessageModel(
        id: '7',
        text: 'What specific steps will you take to address this?',
        isUser: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
      ),
    ];
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessageModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: text,
          isUser: true,
          timestamp: DateTime.now(),
        ),
      );
      _messageController.clear();
    });

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

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String initial = widget.personName.isNotEmpty
        ? widget.personName[0].toUpperCase()
        : 'A';

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
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
                  SizedBox(width: 12.w),

                  // Three-Dot Overflow Menu Icon
                  Icon(
                    Icons.more_vert_rounded,
                    color: Colors.white,
                    size: 22.r,
                  ),
                ],
              ),
            ),

            // Relationship Header Card
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
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
                                  widget.personName,
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
                                    color: Colors.white.withValues(alpha: 0.15),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  widget.relationshipType,
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.9),
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

            // Scrollable Conversation Message List
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: Align(
                      alignment: message.isUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: 0.78 * MediaQuery.of(context).size.width,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 14.h,
                        ),
                        decoration: BoxDecoration(
                          color: message.isUser
                              ? const Color(0xFF16161F)
                              : const Color(0xFF20202A),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16.r),
                            topRight: Radius.circular(16.r),
                            bottomLeft: message.isUser
                                ? Radius.circular(16.r)
                                : Radius.circular(4.r),
                            bottomRight: message.isUser
                                ? Radius.circular(4.r)
                                : Radius.circular(16.r),
                          ),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.05),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          message.text,
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
                              onSubmitted: (_) => _sendMessage(),
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
                            onTap: _sendMessage,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 8.h,
                              ),
                              child: Icon(
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
        ),
      ),
    );
  }
}
