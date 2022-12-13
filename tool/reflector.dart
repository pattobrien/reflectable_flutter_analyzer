import 'dart:io';
// import 'dart:ui';
import 'package:riverpod/riverpod.dart';
import 'package:flutter/material.dart';

import 'package:reflectable_analyzer/reflectable_analyzer.dart';

@GlobalQuantifyCapability(r'\.Color$', analyzerReflector)
@GlobalQuantifyCapability(r'\.Provider$', analyzerReflector)
@GlobalQuantifyCapability(r'\.Directory$', analyzerReflector)
import 'package:reflectable/reflectable.dart' hide SourceLocation;

import 'reflector.reflectable.dart';

void main() {
  initializeReflectable();
  // reflect Color type
  final colorType = Color;
  final typeChecker = TypeChecker.fromRuntime(colorType, analyzerReflector);

  final providerType = Provider;
  final directoryType = Directory;
  // reflect Color instance
  final color = Color(0xFFFFFF00);
  final instance = analyzerReflector.reflect(color);
  final value = instance.invokeGetter('value') as int;
  print('Color value: ${value.toRadixString(16)}');
  exit(0);
}
