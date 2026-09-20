import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thebes_academy/core/localization/locale_provider.dart';
import 'package:thebes_academy/core/di/service_locator.dart';
import 'package:thebes_academy/features/student/presentation/controllers/student_controller.dart';
import 'package:thebes_academy/features/app/presentation/screens/main_screen.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    if (!sl.isRegistered<StudentController>()) {
      await initServiceLocator();
    }
  });

  Future<void> testScreenSize(WidgetTester tester, Size size, String deviceLabel) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LocaleProvider()),
          ChangeNotifierProvider(create: (_) => sl<StudentController>()),
        ],
        child: const MaterialApp(
          home: MainScreen(),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byType(MainScreen), findsOneWidget);
  }

  testWidgets('Responsive Test: Small Phone (320x568)', (WidgetTester tester) async {
    await testScreenSize(tester, const Size(320, 568), 'Small Phone');
  });

  testWidgets('Responsive Test: Standard Phone (390x844)', (WidgetTester tester) async {
    await testScreenSize(tester, const Size(390, 844), 'Standard Phone');
  });

  testWidgets('Responsive Test: Tablet / iPad (820x1180)', (WidgetTester tester) async {
    await testScreenSize(tester, const Size(820, 1180), 'Tablet');
    // On tablet, NavigationRail should be present
    expect(find.byType(NavigationRail), findsOneWidget);
  });

  testWidgets('Responsive Test: Desktop / Web (1280x800)', (WidgetTester tester) async {
    await testScreenSize(tester, const Size(1280, 800), 'Desktop');
    expect(find.byType(NavigationRail), findsOneWidget);
  });
}
