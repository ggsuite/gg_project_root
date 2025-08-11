// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

// #############################################################################
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:gg_log/gg_log.dart';

/// Gg Project Root
class GgProjectRoot {
  /// Returns the project root for path.
  /// Goes maximum [depth] directories up.
  static String? getSync(String path, {int depth = 2}) {
    // Is path directory? If not, use parent directory
    final dir = FileSystemEntity.isFileSync(path)
        ? File(path).parent
        : Directory(path);

    // Iterate directory and its parent until pubspec.yaml is found
    var parent = dir;
    var restDepth = depth;
    while (parent.path != '/' && restDepth > 0) {
      final pubspec = File('${parent.path}/pubspec.yaml');
      if (pubspec.existsSync()) {
        return parent.path;
      }
      parent = parent.parent;
      restDepth--;
    }

    return null;
  }

  /// Returns the project root for path.
  /// Goes maximum [depth] directories up.
  static Future<String?> get(String path, {int depth = 2}) async {
    // Is path directory? If not, use parent directory
    final dir = await FileSystemEntity.isFile(path)
        ? File(path).parent
        : Directory(path);

    // Iterate directory and its parent until pubspec.yaml is found
    var parent = dir;
    var restDepth = depth;
    while (parent.path != '/' && restDepth > 0) {
      final pubspec = File('${parent.path}/pubspec.yaml');
      if (await pubspec.exists()) {
        return parent.path;
      }
      parent = parent.parent;
      restDepth--;
    }

    return null;
  }
}

// #############################################################################
/// The command line interface for GgProjectRoot
class GgProjectRootCmd extends Command<dynamic> {
  /// Constructor
  GgProjectRootCmd({required this.ggLog}) {
    _addArgs();
  }

  /// The log function
  final GgLog ggLog;

  // ...........................................................................
  @override
  final name = 'ggProjectRoot';
  @override
  final description = 'Outputs the dart or flutter project root';

  // ...........................................................................
  @override
  Future<void> run() async {
    var path = argResults?['path'] as String;
    final depth = int.parse(argResults?['depth'] as String);
    final result = await GgProjectRoot.get(path, depth: depth);
    if (result != null) {
      ggLog(result);
      exitCode = 0;
    } else {
      throw Exception('No project root found.');
    }
  }

  // ...........................................................................
  void _addArgs() {
    argParser.addOption(
      'path',
      abbr: 'p',
      help: 'The path the project root is searched for.',
      mandatory: false,
      defaultsTo: '.',
    );

    argParser.addOption(
      'depth',
      abbr: 'd',
      help: 'Goes maximum [depth] directories up.',
      mandatory: false,
      defaultsTo: '2',
      allowed: ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'],
    );
  }
}
