// "use_colored_box" Lint rule definition that uses a theoretical API (sudo code)

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:flutter/material.dart';

import 'package:reflectable_analyzer/reflectable_analyzer.dart';

class ColorVisitor extends GeneralizingAstVisitor<int> {
  @override
  int? visitInstanceCreationExpression(InstanceCreationExpression node) {
    // the below line works for Color, since we're able to reflect the library namespace of Color
    if (node.staticType.isType(Color, analyzerReflector)) {
      print('AstNode staticType is Color: ${node.staticType.toString()}');
    }

    // the below line fails, because we cant reflect the source uri of Container
    if (node.staticType.isType(Container, analyzerReflector)) {
      print('AstNode staticType is Container: ${node.staticType.toString()}');
    }

    return super.visitInstanceCreationExpression(node);
  }
}
