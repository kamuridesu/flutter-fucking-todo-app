import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_todo_app/globals.dart';

import 'package:my_todo_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  SharedPreferences.setMockInitialValues({});
  await App.init();

  testWidgets('Main test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Mock Item'), findsNothing);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    await tester.enterText(
      find.widgetWithText(TextField, "Item Name"),
      "Mock Item",
    );
    await tester.tap(find.widgetWithText(TextButton, "Save"));
    await tester.pump();
    expect(find.text('Mock Item'), findsAtLeast(1));

    var mockItem = find.widgetWithText(ListTile, "Mock Item");
    await tester.tap(find.byType(Switch));
    expect(mockItem, findsOneWidget);
    await tester.tap(mockItem);
    expect(mockItem, findsAny);

    await tester.longPress(mockItem);
    await tester.pump();

    await tester.enterText(
      find.widgetWithText(TextField, "Item Name"),
      "New Mock Item",
    );
    await tester.tap(find.widgetWithText(TextButton, "Save"));
    await tester.pump();
    expect(find.text("New Mock Item"), findsAtLeast(1));
  });
}
