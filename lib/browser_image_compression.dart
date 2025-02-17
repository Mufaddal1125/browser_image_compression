// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:browser_image_compression/browser_image_compression_platform_interface.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/services.dart';

class Options {
  /// @default Number.POSITIVE_INFINITY
  double maxSizeMB = 1;

  /// @default undefined
  double maxWidthOrHeight = 2048;

  /// @default true
  bool useWebWorker = true;

  /// @default 10
  double maxIteration = 10;

  /// Default to be the exif orientation from the image file
  double? exifOrientation;

  /// A function takes one progress argument (progress from 0 to 100)
  Function(double progress)? onProgress;

  /// Default to be the original mime type from the image file
  String? fileType;

  /// @default 1.0
  double initialQuality = 1;

  /// @default false
  bool alwaysKeepResolution = false;
  /** @default undefined */
  // AbortSignal? signal;
  /// @default false
  bool preserveExif = false;

  /// @default https://cdn.jsdelivr.net/npm/browser-image-compression/dist/browser-image-compression.js
  String? libURL;

  Options({
    this.maxSizeMB = 1,
    this.maxWidthOrHeight = 2048,
    this.useWebWorker = true,
    this.maxIteration = 10,
    this.exifOrientation,
    this.onProgress,
    this.fileType,
    this.initialQuality = 1,
    this.alwaysKeepResolution = false,
    this.preserveExif = false,
    this.libURL,
  });
}

class BrowserImageCompression {
  static BrowserImageCompressionPlatform get platform =>
      BrowserImageCompressionPlatform.instance;

  static set platform(BrowserImageCompressionPlatform platform) {
    BrowserImageCompressionPlatform.instance = platform;
  }

  static Future<Uint8List?> compressImage(
    String fileName,
    Uint8List file,
    String mimeType,
    Options options,
  ) async {
    return platform.compressImage(fileName, file, mimeType, options);
  }

  static Future<Uint8List?> compressImageByXFile(
    XFile xfile,
    Options options,
  ) async {
    return platform.compressImageByXFile(xfile, options);
  }
}
