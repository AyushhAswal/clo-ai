import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clo_ai/features/home/presentation/screens/my_circle_screen.dart';
import 'package:clo_ai/features/home/presentation/widgets/relationship_card.dart';
import '../../cubit/my_circle_cubit_test.dart';

void main() {
  testWidgets(
    'MyCircleScreen renders tabs, initial cards, search, and tab filters',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final mockRepo = MockRelationshipRepository();

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (context, child) =>
              MaterialApp(home: MyCircleScreen(repository: mockRepo)),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Verify Title & Visible Category Tabs
      expect(find.text('My Circle'), findsOneWidget);
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Romantic'), findsWidgets);
      expect(find.text('Professional'), findsWidgets);

      // Verify initial cards from mock repository (Ayush, Rahul, Neha, Someone)
      expect(find.text('Ayush'), findsOneWidget);
      expect(find.text('Rahul'), findsOneWidget);

      // Scroll horizontal category tabs list to reveal 'Friends' and 'Family'
      await tester.drag(find.byType(ListView).first, const Offset(-400, 0));
      await tester.pumpAndSettle();

      expect(find.text('Friends'), findsOneWidget);
      expect(find.text('Family'), findsWidgets);

      // Tap "Friends" tab
      await tester.tap(find.text('Friends'));
      await tester.pump(const Duration(milliseconds: 300));

      // Only Rahul should be visible
      expect(find.text('Rahul'), findsOneWidget);
      expect(find.text('Ayush'), findsNothing);
      expect(find.text('Neha'), findsNothing);
      expect(find.text('Someone'), findsNothing);

      // Scroll back left and tap "All" tab
      await tester.drag(find.byType(ListView).first, const Offset(400, 0));
      await tester.pumpAndSettle();

      await tester.tap(find.text('All'));
      await tester.pump(const Duration(milliseconds: 300));

      // Search functionality test
      await tester.tap(find.byIcon(Icons.search_rounded));
      await tester.pump(const Duration(milliseconds: 300));

      // Search bar input - partial & case-insensitive matching
      expect(find.byType(TextField), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'rah');
      await tester.pump(const Duration(milliseconds: 300));

      expect(
        find.widgetWithText(ExistingRelationshipItem, 'Rahul'),
        findsOneWidget,
      );
      expect(find.text('Ayush'), findsNothing);

      // Close search
      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Ayush'), findsOneWidget);
    },
  );
}
