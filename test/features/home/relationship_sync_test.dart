import 'package:clo_ai/features/home/cubit/my_circle_cubit.dart';
import 'package:clo_ai/features/home/cubit/my_circle_state.dart';
import 'package:clo_ai/features/home/domain/models/relationship_model.dart';
import 'package:clo_ai/features/home/presentation/screens/home_screen.dart';
import 'package:clo_ai/features/home/presentation/screens/my_circle_screen.dart';
import 'package:clo_ai/features/home/presentation/widgets/my_circle_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'cubit/my_circle_cubit_test.dart';

void main() {
  group('Relationship Synchronization across Home & My Circle', () {
    testWidgets(
      'HomeScreen and MyCircleScreen share single MyCircleCubit state source of truth',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1170, 2532);
        tester.view.devicePixelRatio = 3.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        final mockRepo = MockRelationshipRepository();
        final myCircleCubit = MyCircleCubit(repository: mockRepo);

        await tester.pumpWidget(
          ScreenUtilInit(
            designSize: const Size(390, 844),
            builder: (context, child) =>
                MaterialApp(home: HomeScreen(myCircleCubit: myCircleCubit)),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        // 1. Initial State: MyCircleSection renders
        expect(find.byType(MyCircleSection), findsOneWidget);

        // 2. Switch tab to My Circle Screen (Tab 1)
        await tester.tap(find.byIcon(Icons.bubble_chart_outlined));
        await tester.pump(const Duration(milliseconds: 300));

        // 3. Verify MyCircleScreen renders from shared MyCircleCubit
        expect(find.byType(MyCircleScreen), findsOneWidget);

        // 4. Emit a newly created relationship "Priya"
        myCircleCubit.emit(
          const MyCircleState(
            status: MyCircleStatus.loaded,
            relationships: [
              RelationshipModel(
                id: 'r1',
                name: 'Rahul',
                category: 'Friends',
                relationshipType: 'Friendship',
              ),
              RelationshipModel(
                id: 'r2',
                name: 'Priya',
                category: 'Friends',
                relationshipType: 'Friendship',
              ),
            ],
          ),
        );
        await tester.pump();

        // 5. Verify MyCircleScreen displays newly added "Priya"
        expect(find.text('Priya'), findsOneWidget);

        // 6. Switch back to Home Tab (Tab 0)
        await tester.tap(find.byIcon(Icons.home_outlined));
        await tester.pump(const Duration(milliseconds: 300));

        // 7. Verify HomeScreen displays newly added "Priya" synchronously
        expect(find.text('Priya'), findsOneWidget);
      },
    );
  });
}
