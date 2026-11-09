import 'package:flutter_test/flutter_test.dart';
import 'package:xchat/app/app.dart';

void main() {
  testWidgets('config error screen explains how to run the app', (tester) async {
    await tester.pumpWidget(const ConfigErrorApp());
    expect(find.textContaining('dart-define-from-file'), findsOneWidget);
  });
}
