import 'package:flutter/material.dart';
import 'package:flutter_3d/threed_page.dart';

import 'example.dart';

void main() {
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    home: ThreedPage()/*ExampleAnimation()*/,
  ));
}
