part of '../extensions.dart';

extension DoubleExt on double {
  double get toPrecise => double.parse(toStringAsFixed(3));

  double get mod => isNegative ? this * -1 : this;
}

extension ListDoubleExt on List<double> {
  double get sum => fold(0, (p, c) => p + c);
  double get average => sum / length;
  double get max => fold(0, (p, c) => p > c ? p : c);
}

extension IterableDoubleExt on Iterable<double> {
  double get sum => fold(0, (p, c) => p + c);
  double get average => sum / length;
  double get max => fold(0, (p, c) => p > c ? p : c);
}
