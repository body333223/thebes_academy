import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thebes_academy/core/localization/locale_provider.dart';
import 'package:thebes_academy/core/di/service_locator.dart';
import 'package:thebes_academy/features/student/presentation/controllers/student_controller.dart';
import 'package:thebes_academy/screens/student/qr_attendance_screen.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    if (!sl.isRegistered<StudentController>()) {
      await initServiceLocator();
    }
  });

  testWidgets('QR Attendance Screen Renders and Handles Doctor QR Scan', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final controller = sl<StudentController>();
    await controller.loadInitialData();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LocaleProvider()),
          ChangeNotifierProvider.value(value: controller),
        ],
        child: const MaterialApp(
          home: QrAttendanceScreen(),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Verify Scanner Viewfinder and demo chips
    expect(find.byType(QrAttendanceScreen), findsOneWidget);
    expect(find.byIcon(Icons.keyboard_rounded), findsOneWidget);

    // Test scanning a valid lecture code via controller
    final success = await controller.scanDoctorQr('THEBES-CS301-2026');
    expect(success, isTrue);
    expect(controller.lastScannedRecord, isNotNull);
    expect(controller.lastScannedRecord!.courseCode, equals('CS301'));

    // Test scanning an invalid code
    final failed = await controller.scanDoctorQr('INVALID-CODE');
    expect(failed, isFalse);
    expect(controller.scanErrorMessage, isNotNull);
  });
}
