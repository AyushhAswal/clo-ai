import 'package:clo_ai/core/network/api_client.dart';
import 'package:clo_ai/features/auth/cubit/auth_cubit.dart';
import 'package:clo_ai/features/auth/cubit/auth_state.dart';
import 'package:clo_ai/features/auth/data/repositories/auth_repository.dart';
import 'package:clo_ai/features/auth/domain/models/user_auth_model.dart';
import 'package:clo_ai/features/login/presentation/screens/login_screen.dart';
import 'package:clo_ai/features/profile/presentation/screens/profile_screen.dart';
import 'package:clo_ai/main.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'auth_cubit_test.dart';

void main() {
  group('Auth & Logout Widget Tests', () {
    late ApiClient apiClient;
    late FakeAdapter fakeAdapter;
    late MockTokenStorage mockTokenStorage;
    late AuthRepository authRepository;

    setUp(() {
      fakeAdapter = FakeAdapter();
      final dio = Dio(BaseOptions(baseUrl: 'http://localhost:3000'));
      dio.httpClientAdapter = fakeAdapter;
      apiClient = ApiClient(dio: dio);
      mockTokenStorage = MockTokenStorage();
      authRepository = AuthRepository(
        apiClient: apiClient,
        tokenStorage: mockTokenStorage,
      );
    });

    testWidgets(
      'RootAuthWrapper displays loading and transitions to HomeScreen when authenticated',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1170, 2532);
        tester.view.devicePixelRatio = 3.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await mockTokenStorage.saveToken('valid-jwt-token');

        fakeAdapter.onRequest = (options) {
          if (options.path == '/auth/me') {
            return ResponsePayload(
              200,
              '{"id":"u1","name":"ayush aswal","email":"ayush@example.com"}',
            );
          }
          return ResponsePayload(404, '{}');
        };

        final authCubit = AuthCubit(repository: authRepository);

        await tester.pumpWidget(CloApp(authCubit: authCubit));
        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        await tester.pump(const Duration(milliseconds: 300));
        await tester.pump(const Duration(milliseconds: 500));

        expect(authCubit.state, isA<AuthAuthenticated>());
        expect(
          find.textContaining('Ayush Aswal', findRichText: true),
          findsOneWidget,
        );
      },
    );

    testWidgets('Logout dialog appears and cancel button retains session', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await mockTokenStorage.saveToken('valid-jwt-token');
      apiClient.setAuthToken('valid-jwt-token');

      final authCubit = AuthCubit(repository: authRepository);
      authCubit.emit(
        const AuthAuthenticated(
          UserAuthModel(
            id: 'u1',
            name: 'ayush aswal',
            email: 'ayush@example.com',
          ),
        ),
      );

      await tester.pumpWidget(
        BlocProvider<AuthCubit>.value(
          value: authCubit,
          child: ScreenUtilInit(
            designSize: const Size(390, 844),
            builder: (context, child) =>
                const MaterialApp(home: ProfileScreen()),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));

      // Tap Logout tile
      await tester.tap(find.text('Logout'));
      await tester.pump(const Duration(milliseconds: 300));

      // Verify AlertDialog opens
      expect(find.text('Are you sure?'), findsOneWidget);
      expect(find.text('Are you sure you want to logout?'), findsOneWidget);

      // Tap Cancel
      await tester.tap(find.text('Cancel'));
      await tester.pump(const Duration(milliseconds: 300));

      // Dialog closed and user still authenticated
      expect(find.text('Are you sure?'), findsNothing);
      expect(authCubit.state, isA<AuthAuthenticated>());
      expect(apiClient.isAuthenticated, isTrue);
    });

    testWidgets(
      'Logout confirm clears token, interceptor, and navigates to LoginScreen',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1170, 2532);
        tester.view.devicePixelRatio = 3.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await mockTokenStorage.saveToken('valid-jwt-token');
        apiClient.setAuthToken('valid-jwt-token');

        final authCubit = AuthCubit(repository: authRepository);
        authCubit.emit(
          const AuthAuthenticated(
            UserAuthModel(
              id: 'u1',
              name: 'ayush aswal',
              email: 'ayush@example.com',
            ),
          ),
        );

        await tester.pumpWidget(
          BlocProvider<AuthCubit>.value(
            value: authCubit,
            child: ScreenUtilInit(
              designSize: const Size(390, 844),
              builder: (context, child) =>
                  const MaterialApp(home: ProfileScreen()),
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 300));

        // Tap Logout tile
        await tester.tap(find.text('Logout'));
        await tester.pump(const Duration(milliseconds: 300));

        // Tap Confirm Logout in Dialog
        await tester.tap(find.widgetWithText(ElevatedButton, 'Logout'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 500));

        // Verified state cleared
        expect(authCubit.state, isA<AuthUnauthenticated>());
        expect(await mockTokenStorage.getToken(), isNull);
        expect(apiClient.isAuthenticated, isFalse);
        expect(find.byType(LoginScreen), findsOneWidget);
      },
    );
  });
}
