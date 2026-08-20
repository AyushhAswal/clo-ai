import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/models/message_model.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUserMessage;

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 0.78 * MediaQuery.of(context).size.width,
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: isUser ? const Color(0xFF16161F) : const Color(0xFF20202A),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
              bottomLeft: isUser ? Radius.circular(16.r) : Radius.circular(4.r),
              bottomRight: isUser
                  ? Radius.circular(4.r)
                  : Radius.circular(16.r),
            ),
            border: Border.all(
              color: isUser
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.white.withValues(alpha: 0.12),
              width: 1,
            ),
          ),
          child: Text(
            message.content,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.95),
              fontSize: 14.sp,
              height: 1.4,
            ),
          ),
        ),
      ),
    );
  }
}
