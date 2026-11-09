import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Enforces the layering rules mechanically so they cannot erode.
void main() {
  final files = Directory('lib')
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .where((f) => !f.path.endsWith('.freezed.dart') && !f.path.endsWith('.g.dart'))
      .toList();

  final importPattern = RegExp(r'''^\s*(?:import|export)\s+['"]([^'"]+)['"]''', multiLine: true);

  String norm(String path) => path.replaceAll(r'\', '/');
  List<String> importsOf(File f) =>
      importPattern.allMatches(f.readAsStringSync()).map((m) => m.group(1)!).toList();

  List<String> violations(bool Function(String file) applies, bool Function(String import) forbidden) => [
        for (final f in files)
          if (applies(norm(f.path)))
            for (final i in importsOf(f))
              if (forbidden(norm(i))) '${norm(f.path)} -> $i',
      ];

  test('domain depends on nothing outside domain/core', () {
    final bad = violations(
      (f) => f.contains('/domain/'),
      (i) =>
          i.contains('/data/') ||
          i.contains('/presentation/') ||
          i.startsWith('package:flutter') ||
          i.startsWith('package:supabase') ||
          i.startsWith('package:isar') ||
          i.startsWith('package:get_it'),
    );
    expect(bad, isEmpty, reason: bad.join('\n'));
  });

  test('presentation never touches the data layer or SDKs', () {
    final bad = violations(
      (f) => f.contains('/presentation/'),
      (i) => i.contains('/data/') || i.startsWith('package:supabase') || i.startsWith('package:isar'),
    );
    expect(bad, isEmpty, reason: bad.join('\n'));
  });

  test('data layer never touches presentation', () {
    final bad = violations((f) => f.contains('/data/'), (i) => i.contains('/presentation/'));
    expect(bad, isEmpty, reason: bad.join('\n'));
  });

  // Composition roots are the only files allowed to wire concrete implementations together.
  bool isCompositionRoot(String file) {
    final name = file.split('/').last;
    return name.contains('injection') || name == 'main.dart' || name == 'bootstrap.dart';
  }

  test('only composition roots (and other impl files) may import /impl/ classes', () {
    final bad = violations(
      (f) => !isCompositionRoot(f) && !f.contains('/impl/'),
      (i) => i.contains('/impl/'),
    );
    expect(bad, isEmpty, reason: bad.join('\n'));
  });

  test('SDKs and plugins are only imported inside /impl/ folders (plus composition roots)', () {
    const sdks = [
      'package:supabase',
      'package:isar',
      'package:shared_preferences',
      'package:connectivity_plus',
      'package:http',
    ];
    final bad = violations(
      (f) => !f.contains('/impl/') && !isCompositionRoot(f),
      (i) => sdks.any(i.startsWith),
    );
    expect(bad, isEmpty, reason: bad.join('\n'));
  });

  test('core never depends on features (except the DI root that wires them)', () {
    final bad = violations(
      (f) => f.contains('/core/') && !f.contains('/core/di/'),
      (i) => i.contains('/features/'),
    );
    expect(bad, isEmpty, reason: bad.join('\n'));
  });

  test('features do not import other features presentation/data (only domain or core)', () {
    final bad = violations(
      (f) => f.contains('/features/') && !isCompositionRoot(f),
      (i) {
        final m = RegExp(r'/features/([^/]+)/(data|presentation)/').firstMatch(i);
        return m != null;
      },
    ).where((v) {
      // A feature may import its OWN data/presentation: compare feature names.
      final file = v.split(' -> ').first;
      final imp = v.split(' -> ').last;
      final own = RegExp(r'/features/([^/]+)/').firstMatch(file)?.group(1);
      final other = RegExp(r'/features/([^/]+)/').firstMatch(imp)?.group(1);
      return own != other;
    }).toList();
    expect(bad, isEmpty, reason: bad.join('\n'));
  });
}
