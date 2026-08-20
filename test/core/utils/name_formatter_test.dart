import 'package:flutter_test/flutter_test.dart';
import 'package:clo_ai/core/utils/name_formatter.dart';

void main() {
  group('StringNameFormatter toTitleCase Tests', () {
    test('Formats lowercase full name preserving spaces', () {
      expect('ayush aswal'.toTitleCase(), equals('Ayush Aswal'));
    });

    test('Formats uppercase full name preserving spaces', () {
      expect('AYUSH ASWAL'.toTitleCase(), equals('Ayush Aswal'));
    });

    test('Formats single name', () {
      expect('ayush'.toTitleCase(), equals('Ayush'));
    });

    test('Handles extra spaces between first and last name cleanly', () {
      expect('  john   doe  '.toTitleCase(), equals('John Doe'));
    });

    test('Handles empty string', () {
      expect(''.toTitleCase(), equals(''));
    });
  });
}
