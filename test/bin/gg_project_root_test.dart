// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'dart:convert';
import 'dart:io';

import 'package:gg_capture_print/gg_capture_print.dart';
import 'package:test/test.dart';

import '../../bin/gg_project_root.dart';

void main() {
  group('bin/gg_project_root.dart', () {
    // #########################################################################

    test('should be executable', () async {
      // Execute bin/gg_project_root.dart and check if it prints help
      final result = await Process.run(
        './bin/gg_project_root.dart',
        [],
        stdoutEncoding: utf8,
        stderrEncoding: utf8,
      );

      final stdout = result.stdout as String;
      expect(stdout, '.\n');
    });
  });

  // ###########################################################################
  group('run(args, log)', () {
    group('with args=[--path, value]', () {
      test('should print the project dir', () async {
        // Execute bin/gg_project_root.dart and check if it prints "value"
        final messages = <String>[];
        await run(args: ['--path', '.'], ggLog: messages.add);

        expect(hasLog(messages, '.'), isTrue);
      });
    });
  });
}
