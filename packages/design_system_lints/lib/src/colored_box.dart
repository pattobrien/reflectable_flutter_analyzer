// "use_colored_box" Lint rule definition that uses a theoretical API (sudo code)

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:flutter/material.dart';

import 'package:reflectable_analyzer/reflectable_analyzer.dart';

// @GlobalQuantifyCapability(r'\.Color$', analyzerReflector)
// import 'package:reflectable/reflectable.dart';

class ColorVisitor extends GeneralizingAstVisitor<int> {
  // @override
  // int? visitNode(AstNode node) {
  //   print('visitNode ${node.runtimeType}: ${node.beginToken}');
  //   return super.visitNode(node);
  // }

  // @override
  // int? visitConstructorName(ConstructorName node) {
  //   node.staticElement?.returnType;
  //   return super.visitConstructorName(node);
  // }

  @override
  int? visitInstanceCreationExpression(InstanceCreationExpression node) {
    final interfaceType = node.constructorName.staticElement?.returnType;
    // final constructorElement = node.constructorName.staticElement;
    if (!node.staticType.isType(Color, analyzerReflector)) {
      print('not a Color instance: ${node.beginToken}');
      return super.visitInstanceCreationExpression(node);
    }

    if (node.staticType.isType(Container, analyzerReflector)) {
      final instance = Container(key: Key('123'));
      final mirror = analyzerReflector.reflect(instance);
      print('got a Container instance: ${node.beginToken}');
      return super.visitInstanceCreationExpression(node);
    }

    print('got a Color instance: ${node.staticType.toString()}');
    print('instanceType ${interfaceType?.name}');
    final value = node.argumentList.arguments.first;
    final intValue = int.parse(value.toSource()).toRadixString(16);
    print(intValue);

    // final valueVariable =
    //     constructorElement?.parameters.firstWhere((p) => p.isPositional);
    // final val = valueVariable.;
    // final valueVariable = interfaceType?.accessors
    //     .firstWhere((element) => element.name == 'value')
    //     .variable;
    // final constantVal = valueVariable?.computeConstantValue();

    print('instanceType accessors ${interfaceType?.accessors}');
    // print('constant value: $valueVariable');
    // final container = Mirror<Container>.fromNode(node);

    // if (container.child != null && container.color != null) {
    //     rule.reportLint(node.constructorName);
    // }
    return super.visitInstanceCreationExpression(node);
  }
}
