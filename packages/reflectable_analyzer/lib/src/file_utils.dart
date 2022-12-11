import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/file_system/file_system.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'dart:io' as io;
import 'package:path/path.dart' as p;

Future<List<T>> visitFile<T>(String path, List<AstVisitor<T>> visitors) async {
  final file = io.File(path);
  if (!file.existsSync()) throw UnimplementedError();
  print('file: ${file.path}');

  final resourceProvider = PhysicalResourceProvider.INSTANCE;
  final collection = AnalysisContextCollection(
    includedPaths: [path],
    resourceProvider: resourceProvider,
    sdkPath: getSdkPath(resourceProvider),
  );

  final context = collection.contextFor(path);
  print('context: ${context.contextRoot.root.path}');
  final unit = await context.currentSession.getResolvedUnit(path);
  if (unit is! ResolvedUnitResult) throw UnimplementedError();
  return visitors.map((e) => unit.unit.accept(e)).whereType<T>().toList();
}

String getSdkPath(ResourceProvider resourceProvider) {
  var dartSdk = p.dirname(p.dirname(io.Platform.resolvedExecutable));
  if (dartSdk.contains('engine')) {
    final dartSdkUri = Uri.parse(dartSdk);
    final dartRoot = resourceProvider.getFile(dartSdkUri.path);
    final actualDart = p.join(dartRoot.parent.parent.path, 'dart-sdk');
    dartSdk = actualDart;
  }
  return dartSdk;
}
