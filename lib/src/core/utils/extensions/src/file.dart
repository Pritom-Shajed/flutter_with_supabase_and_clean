part of '../extensions.dart';

extension FileExt on File {
  Future<String> get base64 async => base64Encode(await readAsBytes());

  String get name => path.split('/').last;
}
