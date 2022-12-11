import 'dart:io';
// import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:path/path.dart' as p;
import 'package:reflectable_analyzer/reflectable_analyzer.dart';
import 'package:design_system_lints/design_system_lints.dart';

import 'reflector.reflectable.dart';

void main() async {
  initializeReflectable();
  final file = Directory.current.uri.resolve(p.join('assets', 'colors.dart'));
  final results = await visitFile(file.path, [ColorVisitor()]);
  print('results: $results');
  calculateInstanceValue();
}

void calculateInstanceValue() {
  final color = Color(0xFFFFFF00);
  final instance = analyzerReflector.reflect(color);
  final value = instance.invokeGetter('value') as int;
  print('Color value: ${value.toRadixString(16)}');
}
