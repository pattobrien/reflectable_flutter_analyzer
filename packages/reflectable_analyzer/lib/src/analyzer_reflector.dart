import 'package:reflectable/reflectable.dart';

class AnalyzerReflector extends Reflectable {
  const AnalyzerReflector()
      : super(
          uriCapability,
          libraryDependenciesCapability,
          libraryCapability,
          declarationsCapability,
          reflectedTypeCapability,
          typeCapability,
          typeRelationsCapability,
          metadataCapability,
          invokingCapability,
          typingCapability,
        );
}

const analyzerReflector = AnalyzerReflector();
