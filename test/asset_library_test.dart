import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:chorejar/assets/library.dart';

void main() {
  test('Asset library stays complete, unique and below 500 KiB', () {
    expect(goalImageIds.length, 18);
    final assets = AssetLibrary.all.toList();
    expect(assets.map((a) => a.path).toSet().length, assets.length);
    var total = 0;
    for (final asset in assets) {
      final file = File(asset.path);
      expect(file.existsSync(), isTrue, reason: asset.id);
      final bytes = file.readAsBytesSync();
      expect(String.fromCharCodes(bytes.sublist(8, 12)), 'WEBP');
      total += bytes.length;
    }
    expect(total, lessThan(500 * 1024));
    expect(
      goalImageIds.where((id) => id != 'gift'),
      everyElement(isIn(AssetLibrary.goals.keys)),
    );
  });
}
