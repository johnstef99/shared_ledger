import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_ledger/app/router.dart';
import 'package:shared_ledger/main.dart';
import 'package:shared_ledger/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/mock_app.dart';

void main() async {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
    EasyLocalization.logger.enableBuildModes = [];
    prefs = await SharedPreferences.getInstance();
  });

  tearDown(() {
    resetAllMocks();
  });

  testWidgets('Login with correct email and password',
      (WidgetTester tester) async {
    when(() => mockAuth.user).thenReturn(ValueNotifier(const User.empty()));
    when(() => mockAuth.loginWithPassword('john@johnstef.com', 'password'))
        .thenAnswer((i) {
      mockAuth.user.value = const User(
        id: '123',
        email: 'john@johnstef.com',
      );
      return Future<void>.value();
    });

    when(() => mockLedgerRepo.getLedgers()).thenAnswer((i) {
      return Future.value([]);
    });

    when(() => mockLedgerRepo.getSharedWithMeLedgers()).thenAnswer((i) {
      return Future.value([]);
    });

    await tester.runAsync(() async {
      final router = generateRouter();
      await tester.pumpMockApp(
        MyRootWidget(router: router),
      );

      await tester.pumpAndSettle();

      var currentRoute = router.state?.uri.path;
      expect(currentRoute, '/login');

      await tester.enterText(
          find.byKey(const Key('email')), 'john@johnstef.com');
      await tester.testTextInput.receiveAction(TextInputAction.next);
      await tester.pumpAndSettle();

      final passwordLoginButton = find.text('Password Login');
      await tester.tap(passwordLoginButton);
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('password')), 'password');

      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      currentRoute = router.state?.uri.path;
      expect(currentRoute, '/ledgers');
    });
  });

  group('Invalid email', () {
    testWidgets('Empty email', (WidgetTester tester) async {
      when(() => mockAuth.user).thenReturn(ValueNotifier(const User.empty()));

      await tester.runAsync(() async {
        final router = generateRouter();
        await tester.pumpMockApp(MyRootWidget(router: router));
        await tester.pumpAndSettle();
        var currentRoute = router.state?.uri.path;
        expect(currentRoute, '/login');

        await tester.tap(find.text('Password Login'));
        await tester.pumpAndSettle();

        expect(find.text('Invalid email'), findsOneWidget);
      });
    });

    testWidgets('Invalid email', (WidgetTester tester) async {
      when(() => mockAuth.user).thenReturn(ValueNotifier(const User.empty()));

      await tester.runAsync(() async {
        final router = generateRouter();
        await tester.pumpMockApp(MyRootWidget(router: router));
        await tester.pumpAndSettle();
        var currentRoute = router.state?.uri.path;
        expect(currentRoute, '/login');

        await tester.enterText(
            find.byKey(const Key('email')), 'john@johnstef.');

        await tester.tap(find.text('Password Login'));
        await tester.pumpAndSettle();

        expect(find.text('Invalid email'), findsOneWidget);
      });
    });
  });
}
