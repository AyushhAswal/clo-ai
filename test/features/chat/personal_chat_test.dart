import 'package:clo_ai/features/ai/presentation/screens/personal_ai_vent_screen.dart';
import 'package:clo_ai/features/chat/cubit/personal_chat_cubit.dart';
import 'package:clo_ai/features/chat/cubit/personal_chat_state.dart';
import 'package:clo_ai/features/chat/data/repositories/personal_chat_repository.dart';
import 'package:clo_ai/features/chat/domain/models/message_model.dart';
import 'package:clo_ai/features/chat/domain/models/personal_chat_model.dart';
import 'package:clo_ai/features/chat/presentation/screens/personal_chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

class MockPersonalChatRepository implements PersonalChatRepository {
  PersonalChatModel personalChat = PersonalChatModel(
    id: 'pchat-123',
    userId: 'user-456',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    messages: [
      MessageModel(
        id: 'msg-1',
        chatId: 'pchat-123',
        role: 'USER',
        content: 'Hello CLO AI',
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      MessageModel(
        id: 'msg-2',
        chatId: 'pchat-123',
        role: 'ASSISTANT',
        content: 'Hello! How was your day?',
        createdAt: DateTime.now().subtract(const Duration(minutes: 4)),
      ),
    ],
  );

  @override
  Future<PersonalChatModel> getOrCreatePersonalChat() async {
    return personalChat;
  }

  @override
  Future<List<MessageModel>> getMessages() async {
    return personalChat.messages;
  }

  @override
  Future<MessageModel> sendMessage(String content) async {
    final newAssistantMsg = MessageModel(
      id: 'msg-${DateTime.now().millisecondsSinceEpoch}',
      chatId: personalChat.id,
      role: 'ASSISTANT',
      content: 'I am here for you.',
      createdAt: DateTime.now(),
    );
    return newAssistantMsg;
  }

  @override
  Future<void> deletePersonalChat() async {
    personalChat = PersonalChatModel(
      id: 'pchat-123',
      userId: 'user-456',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      messages: [],
    );
  }
}

void main() {
  group('PersonalChat Unit and Widget Tests', () {
    test('PersonalChatCubit loads persistent chat session cleanly', () async {
      final mockRepo = MockPersonalChatRepository();
      final cubit = PersonalChatCubit(repository: mockRepo);

      expect(cubit.state.status, equals(PersonalChatStatus.initial));

      await cubit.loadPersonalChat();

      expect(cubit.state.status, equals(PersonalChatStatus.loaded));
      expect(cubit.state.personalChat?.id, equals('pchat-123'));
      expect(cubit.state.messages.length, equals(2));
      expect(cubit.state.messages.first.content, equals('Hello CLO AI'));
    });

    testWidgets(
      'PersonalAIVentScreen renders personal companion space and navigates to PersonalChatScreen',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1170, 2532);
        tester.view.devicePixelRatio = 3.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(
          ScreenUtilInit(
            designSize: const Size(390, 844),
            builder: (context, child) => MaterialApp(home: child),
            child: const PersonalAIVentScreen(),
          ),
        );
        await tester.pump(const Duration(milliseconds: 300));

        // Verify Personal AI Vent Elements
        expect(find.text('CLO AI'), findsOneWidget);
        expect(find.text('Personal Companion'), findsOneWidget);
        expect(find.text('Share Your Personal Space ✨'), findsOneWidget);
        expect(find.byIcon(Icons.sms_outlined), findsOneWidget);

        // Tap Chat Control Button
        await tester.tap(find.byIcon(Icons.sms_outlined));
        await tester.pump(const Duration(milliseconds: 300));
        await tester.pump(const Duration(milliseconds: 300));

        // Verify transition to PersonalChatScreen
        expect(find.byType(PersonalChatScreen), findsOneWidget);
      },
    );

    testWidgets(
      'PersonalChatScreen renders messages and sends new personal message',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1170, 2532);
        tester.view.devicePixelRatio = 3.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        final mockRepo = MockPersonalChatRepository();

        await tester.pumpWidget(
          ScreenUtilInit(
            designSize: const Size(390, 844),
            builder: (context, child) => MaterialApp(home: child),
            child: PersonalChatScreen(repository: mockRepo),
          ),
        );
        await tester.pump(const Duration(milliseconds: 300));
        await tester.pump(const Duration(milliseconds: 300));

        // Verify Header & Initial Messages
        expect(find.text('CLO AI'), findsOneWidget);
        expect(find.text('Personal Companion'), findsOneWidget);
        expect(find.text('Hello CLO AI'), findsOneWidget);
        expect(find.text('Hello! How was your day?'), findsOneWidget);

        // Enter message and tap send
        final sendButton = find.byKey(
          const Key('send_personal_message_button'),
        );
        await tester.enterText(find.byType(TextField), 'Talking about my day');
        await tester.pump();
        await tester.tap(sendButton);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        // Scroll to bottom to view new messages
        await tester.drag(find.byType(ListView), const Offset(0, -600));
        await tester.pumpAndSettle();

        expect(find.text('Talking about my day'), findsOneWidget);
        expect(find.text('I am here for you.'), findsOneWidget);
      },
    );
  });
}
