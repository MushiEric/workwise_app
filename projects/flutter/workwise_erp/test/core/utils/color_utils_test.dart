import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workwise_erp/core/utils/color_utils.dart';

void main() {
  test('hexToColor parses #RRGGBB', () {
    final c = hexToColor('#457af7');
    expect(c, const Color(0xFF457AF7));
  });

  test('hexToColor parses RRGGBB', () {
    final c = hexToColor('457af7');
    expect(c, const Color(0xFF457AF7));
  });

  test('hexToColor parses 0xAARRGGBB', () {
    final c = hexToColor('0x88457af7');
    expect(c, const Color(0x88457AF7));
  });

  test('hexToColor returns fallback on invalid input', () {
    final fb = Colors.pink;
    expect(hexToColor(null, fallback: fb), fb);
    expect(hexToColor('', fallback: fb), fb);
    expect(hexToColor('zzz', fallback: fb), fb);
  });

  test('hexToColor expands short hex', () {
    final c = hexToColor('#0f8');
    // '#0f8' -> '00ff88' -> 0xFF00FF88
    expect(c, const Color(0xFF00FF88));
  });
}
