// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:args/command_runner.dart';
import 'package:gg_project_root/gg_project_root.dart';
import 'package:test/test.dart';

void main() {
  final messages = <String>[];

  group('GgProjectRoot()', () {
    // #########################################################################
    group('exec()', () {
      test('description of the test ', () async {
        final ggProjectRoot =
            GgProjectRoot(param: 'foo', log: (msg) => messages.add(msg));

        await ggProjectRoot.exec();
      });
    });

    // #########################################################################
    group('ggProjectRoot', () {
      test('should allow to run the code from command line', () async {
        final ggProjectRoot = GgProjectRootCmd(log: (msg) => messages.add(msg));

        final CommandRunner<void> runner = CommandRunner<void>(
          'ggProjectRoot',
          'Description goes here.',
        )..addCommand(ggProjectRoot);

        await runner.run(['ggProjectRoot', '--param', 'foo']);
      });
    });
  });
}
