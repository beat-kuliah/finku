import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('render basic widget', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: Text('FinKu Mobile'))));
    expect(find.text('FinKu Mobile'), findsOneWidget);
  });
}
