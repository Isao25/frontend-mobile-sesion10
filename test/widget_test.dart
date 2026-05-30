import 'package:flutter_test/flutter_test.dart';
import 'package:techstore_app/main.dart';

void main() {
  testWidgets('App arranca y muestra LoginPage', (WidgetTester tester) async {
    await tester.pumpWidget(const TechStoreApp());
    expect(find.text('TechStore S.A.C.'), findsOneWidget);
  });
}
