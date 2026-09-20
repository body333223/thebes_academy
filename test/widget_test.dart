import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:thebes_academy/core/localization/locale_provider.dart';
import 'package:thebes_academy/core/di/service_locator.dart';
import 'package:thebes_academy/features/student/presentation/controllers/student_controller.dart';
import 'package:thebes_academy/main.dart';
import 'package:thebes_academy/screens/auth/login_screen.dart';

void main() {
  setUpAll(() async {
    if (!sl.isRegistered<StudentController>()) {
      await initServiceLocator();
    }
  });

  testWidgets('Thebes Academy App Smoke Test & Responsive Flow', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LocaleProvider()),
          ChangeNotifierProvider(create: (_) => sl<StudentController>()),
        ],
        child: const ThebesAcademyApp(),
      ),
    );

    // Initial pump
    expect(find.byType(ThebesAcademyApp), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 3000));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    // Verify LoginScreen is shown
    expect(find.byType(LoginScreen), findsOneWidget);
  });
}
