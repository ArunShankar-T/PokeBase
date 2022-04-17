import 'package:flutter_test/flutter_test.dart';
import 'package:poke_base/main.dart';
import 'package:poke_base/utils/view_utils.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    expect(find.byWidget(ViewUtils.loader()), findsOneWidget);
    await tester.pump();
  });
}
