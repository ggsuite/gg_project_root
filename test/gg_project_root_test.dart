// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:gg_capture_print/gg_capture_print.dart';
import 'package:gg_project_root/gg_project_root.dart';
import 'package:test/test.dart';

void main() {
  late Directory rootDir;
  late Directory subDir;
  late File file;
  late File pubspec;

  // ...........................................................................
  void createPubSpec() {
    pubspec.writeAsStringSync('name: gg_project_root_test');
  }

  // ...........................................................................
  String? projectRootSync(FileSystemEntity item, {int depth = 4}) =>
      GgProjectRoot.getSync(item.path, depth: depth);

  Future<String?> projectRoot(FileSystemEntity item, {int depth = 4}) async =>
      GgProjectRoot.get(item.path, depth: depth);

  // ...........................................................................
  setUp(() {
    rootDir = Directory.systemTemp.createTempSync('gg_project_root_test');
    subDir = Directory('${rootDir.path}/a/b/c');
    subDir.createSync(recursive: true);
    file = File('${subDir.path}/file.txt')..writeAsStringSync('Hello, World!');
    pubspec = File('${rootDir.path}/pubspec.yaml');
  });

  group('GgProjectRoot', () {
    // #########################################################################
    group('get(path)', () {
      group(
        'should return the parent path containing a pubspec.yaml file ',
        () {
          test('for a sub directory and file in subdir', () async {
            createPubSpec();
            expect(projectRootSync(subDir), rootDir.path);
            expect(await projectRoot(subDir), rootDir.path);

            expect(projectRootSync(file), rootDir.path);
            expect(await projectRoot(file), rootDir.path);
          });
        },
      );

      // #######################################################################
      group('should return null ', () {
        test(
          'when the parent directory does not contain a pubspec.yaml file',
          () async {
            expect(GgProjectRoot.getSync(subDir.path), null);
            expect(await GgProjectRoot.get(subDir.path), null);
          },
        );
      });
    });
  });

  // #########################################################################
  group('GetProjectRootCmd', () {
    final messages = <String>[];
    final runner = CommandRunner<void>('gg_project_root', 'Test')
      ..addCommand(GgProjectRootCmd(ggLog: messages.add));

    test('should throw if the specified path '
        'does not contain a pubspec.yaml file', () async {
      expect(pubspec.existsSync(), isFalse);

      await expectLater(
        () => runner.run(['ggProjectRoot', '--path', subDir.path]),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'toString()',
            'Exception: No project root found.',
          ),
        ),
      );
    });

    // .........................................................................
    test('should log the project root', () async {
      createPubSpec();
      await runner.run([
        'ggProjectRoot',
        '--path',
        subDir.path,
        '--depth',
        '4',
      ]);
      expect(hasLog(messages, rootDir.path), isTrue);
    });
  });
}
