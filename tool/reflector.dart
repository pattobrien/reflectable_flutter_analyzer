import 'dart:io';
// import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:reflectable_analyzer/reflectable_analyzer.dart';

@GlobalQuantifyCapability(r'\.Color$', analyzerReflector)
@GlobalQuantifyCapability(r'\.Container$', analyzerReflector)
import 'package:reflectable/reflectable.dart' hide SourceLocation;

import 'reflector.reflectable.dart';

void main() {
  initializeReflectable();
  // reflect Color type
  final typeChecker = TypeChecker.fromRuntime(Color, analyzerReflector);
  // reflect Color instance
  final color = Color(0xFFFFFF00);
  final instance = analyzerReflector.reflect(color);
  final value = instance.invokeGetter('value') as int;
  print('Color value: ${value.toRadixString(16)}');
  exit(0);
}
