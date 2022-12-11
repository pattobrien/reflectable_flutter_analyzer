// "use_colored_box" Lint rule definition that uses a theoretical API (sudo code)

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:flutter/material.dart';

import 'package:reflectable_analyzer/reflectable_analyzer.dart';

// @GlobalQuantifyCapability(r'\.Color$', analyzerReflector)
// import 'package:reflectable/reflectable.dart';

class ColorVisitor extends GeneralizingAstVisitor<int> {
  @override
  int? visitNode(AstNode node) {
    // print('visitNode: ${node.beginToken}');
    return super.visitNode(node);
  }

  @override
  int? visitInstanceCreationExpression(InstanceCreationExpression node) {
    if (!node.staticType.isType<Color>(analyzerReflector)) {
      print('not a Color instance: ${node.beginToken}');
      return super.visitInstanceCreationExpression(node);
    }
    print('got a Color instance: ${node.staticType.toString()}');

    // final container = Mirror<Container>.fromNode(node);

    // if (container.child != null && container.color != null) {
    //     rule.reportLint(node.constructorName);
    // }
    return super.visitInstanceCreationExpression(node);
  }
}
