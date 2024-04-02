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
  /// Returns the project root
  static String? getSync(String path) {
    // Is path directory? If not, use parent directory
    final dir =
        FileSystemEntity.isFileSync(path) ? File(path).parent : Directory(path);

    // Iterate directory and its parent until pubspec.yaml is found
    var parent = dir;
    while (parent.path != '/') {
      final pubspec = File('${parent.path}/pubspec.yaml');
      if (pubspec.existsSync()) {
        return parent.path;
      }
      parent = parent.parent;
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
    final result = GgProjectRoot.getSync(path);
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
  }
}
