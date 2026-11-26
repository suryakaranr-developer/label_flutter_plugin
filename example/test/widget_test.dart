import 'package:flutter_test/flutter_test.dart';

import 'package:label_flutter_plugin_example/main.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('shows the credential fields', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: LabelDemoPage()));

    expect(find.text('Package ID'), findsOneWidget);
    expect(find.text('Client ID'), findsOneWidget);
    expect(find.text('License key'), findsOneWidget);
  });
}
