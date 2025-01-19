part of '../extensions.dart';

extension BoolCompareExt on bool? {
  bool get isFalse => this == false;
  bool get isTrue => this == true;
}
