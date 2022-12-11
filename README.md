
This is a proof-of-concept application for analyzing files using types defined in Flutter-specific libraries, including ```dart:ui```.

## Motivation

The suite of Dart analyzer tools rely solely on the Dart SDK. 
When writing custom rules for Flutter-based projects (via tools like ```Sidecar``` and ```analyzer_plugin```),
we cannot directly import Flutter-based packages, as our analyzer does not have awareness of such packages from the Flutter SDK.

Therefore, we're limitted to using more-complex and more-fragile APIs, such as the following:


```dart

// Utility source code from official Dart package:linter.

_Flutter _flutterInstance = _Flutter('flutter', 'package:flutter');

bool isExactWidget(ClassElement element) => _flutter.isExactWidget(element);

class _Flutter {
  static const _nameBuildContext = 'BuildContext';
  static const _nameStatefulWidget = 'StatefulWidget';
  static const _nameWidget = 'Widget';
  static const _nameContainer = 'Container';
  static const _nameSizedBox = 'SizedBox';

  _Flutter(this.packageName, String uriPrefix)
      : widgetsUri = '$uriPrefix/widgets.dart',
        _uriBasic = Uri.parse('$uriPrefix/src/widgets/basic.dart'),
        _uriContainer = Uri.parse('$uriPrefix/src/widgets/container.dart'),
        _uriFramework = Uri.parse('$uriPrefix/src/widgets/framework.dart'),
        _uriFoundation = Uri.parse('$uriPrefix/src/foundation/constants.dart');


  bool isExactWidget(ClassElement element) =>
      _isExactWidget(element, _nameWidget, _uriFramework);
  ...
}
```


```dart

// "use_colored_box" Lint rule definition that uses the above APIs

class _Visitor extends SimpleAstVisitor {
  ...
  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    if (!isExactWidgetTypeContainer(node.staticType)) return;

    var data = _ArgumentData(node.argumentList);

    if (data.additionalArgumentsFound || data.positionalArgumentsFound) return;

    if (data.hasChild && data.hasColor) rule.reportLint(node.constructorName);
  }
}

class _ArgumentData {
  var positionalArgumentsFound = false;
  var additionalArgumentsFound = false;
  var hasColor = false;
  var hasChild = false;

  _ArgumentData(ArgumentList node) {
    for (var argument in node.arguments) {
      if (argument is! NamedExpression) {
        positionalArgumentsFound = true;
        return;
      }
      var label = argument.name.label;
      if (label.name == 'color' &&
          argument.staticType?.nullabilitySuffix !=
              NullabilitySuffix.question) {
        hasColor = true;
      } else if (label.name == 'child') {
        hasChild = true;
      } else if (label.name == 'key') {
        // Ignore key
      } else {
        additionalArgumentsFound = true;
      }
    }
  }
}
```

Note the following issues with the above APIs:

- All third-party packages (Riverpod, Bloc, etc) would have to implement similar APIs, either via automation tools or by hand
- No version control; what would happen if these strings or URIs were to change in a future package version? Packages need to be very carefully monitored for "breaking" changes.
  - additionally, "breaking" changes could be as simple as renaming a file of a particular Type. Regardless of if users are restricted to using ```package:riverpod/riverpod.dart``` for a ```Provider``` type, if the source URI of ```Provider``` was to change from ```package:riverpod/src/framework/providers.dart```, this would be enough for the analyzer to break

Rule Creators:
- They must learn a whole new suite of non-intuitive utilities and APIs, which will likely not be standardized from package to package.
- Creators would not be able to import Flutter-based packages directly

### Objective

Imagine an even simpler API, that does not require Package authors to create a suite of utilities like ```isWidgetType``` and allows developers to more intuitively work with Types and Objects defined in Ecosystem Packages:

```dart

// "use_colored_box" Lint rule definition that uses a theoretical API (sudo code)

import 'package:flutter/material.dart';

// Reflectable-based generated file
import 'flutter.reflectable.dart';

class _Visitor extends SimpleAstVisitor {
  ...
  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    
    if (node.staticType != reflectedType(Container)) return;

    final container = Mirror<Container>.fromNode(node);
    
    if (container.child != null && container.color != null) {
        rule.reportLint(node.constructorName);
    }
  }
}
```

In the above example, we would make a number of improvements:

- A generated utility file allows:
  - Utilities to be generated on-the-fly when imported into a project; so whether you're importing Flutter v2.0 or v3.0, the files will generate based on the source URIs for the current version
  - 0 maintenance from individual Ecosystem Package authors (i.e. Riverpod would not need to create any Analyzer utilities)
- Developers would be able to use a fixed amount of reflection classes like ```reflectedType```; that knowledge would be transferable between any package (Riverpod, BLoC, etc.)
- Rule developers could use APIs that are familiar and type safe

```dart
// new API
final container = ContainerMirror.fromNode(node);

if (container.child != null) {
    ...
}

// old API
var label = argument.name.label;

if (label.name == 'color' &&
  argument.staticType?.nullabilitySuffix !=
    NullabilitySuffix.question) {
        ...
}

```

This application will be used to test out ways we can reach the above goals. Those goals include the following tasks:

- how can we directly depend on Flutter packages to create the generated Utilities?
  - is direct dependency needed? or can we somehow bypass the need to import these classes?
- how can we (if at all) generate mirror APIs for classes like ```container.child``` for Container class?