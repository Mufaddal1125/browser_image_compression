// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'dart:async';
import 'dart:html' as html show window;
import 'dart:html';

import 'package:browser_image_compression/browser_image_compression.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:js/js.dart';

import 'browser_image_compression_platform_interface.dart';

/// A web implementation of the BrowserImageCompressionPlatform of the BrowserImageCompression plugin.
class BrowserImageCompressionWeb extends BrowserImageCompressionPlatform {
  /// Constructs a BrowserImageCompressionWeb
  BrowserImageCompressionWeb();

  static void registerWith(Registrar registrar) {
    BrowserImageCompressionPlatform.instance = BrowserImageCompressionWeb();
  }

  /// Returns a [String] containing the version of the platform.
  @override
  Future<String?> getPlatformVersion() async {
    final version = html.window.navigator.userAgent;
    return version;
  }

  @override
  Future<Uint8List> compressImageByXFile(XFile xfile, Options opts) async {
    var completer = Completer<Uint8List>();
    var optsImpl = OptionsJS(
      maxSizeMB: opts.maxSizeMB,
      maxWidthOrHeight: opts.maxWidthOrHeight,
      useWebWorker: opts.useWebWorker,
      maxIteration: opts.maxIteration,
      exifOrientation: opts.exifOrientation,
      onProgress:
          (opts.onProgress != null) ? allowInterop(opts.onProgress!) : null,
      fileType: opts.fileType,
      initialQuality: opts.initialQuality,
      alwaysKeepResolution: opts.alwaysKeepResolution,
      preserveExif: opts.preserveExif,
      libURL: opts.libURL,
    );
    var file = File(
      [await xfile.readAsBytes()],
      xfile.name,
      {'type': xfile.mimeType},
    );

    var value =
        await completerForPromise(imageCompression(file, optsImpl)).future;

    var r = FileReader();

    r.readAsArrayBuffer(value);

    r.onLoadEnd.listen((data) {
      completer.complete(r.result as Uint8List);
    });

    return completer.future;
  }

  @override
  Future<Uint8List> compressImage(
      String filename, Uint8List data, String mineType, Options opts) async {
    var completer = Completer<Uint8List>();

    var file = File(
      [data],
      filename,
      {'type': mineType},
    );

    var optsImpl = OptionsJS(
      maxSizeMB: opts.maxSizeMB,
      maxWidthOrHeight: opts.maxWidthOrHeight,
      useWebWorker: opts.useWebWorker,
      maxIteration: opts.maxIteration,
      exifOrientation: opts.exifOrientation,
      onProgress:
          (opts.onProgress != null) ? allowInterop(opts.onProgress!) : null,
      fileType: opts.fileType,
      initialQuality: opts.initialQuality,
      alwaysKeepResolution: opts.alwaysKeepResolution,
      preserveExif: opts.preserveExif,
      libURL: opts.libURL,
    );

    var value =
        await completerForPromise(imageCompression(file, optsImpl)).future;

    var r = FileReader();

    r.readAsArrayBuffer(value);

    r.onLoadEnd.listen((data) {
      completer.complete(r.result as Uint8List);
    });

    return completer.future;
  }
}

@JS("Promise")
class Promise {
  external Object then(Function onFulfilled, Function onRejected);
  external static Promise resolve(dynamic value);
}

/// Creates a completer for the given JS promise.
Completer<T> completerForPromise<T>(Promise promise) {
  Completer<T> out = Completer();

  // Create interopts for promise
  promise.then(allowInterop((value) {
    out.complete(value);
  }), allowInterop(([value]) {
    out.completeError(value, StackTrace.current);
  }));

  return out;
}

@JS("imageCompression")
external Promise imageCompression(File file, OptionsJS optionsJS);

@JS()
@anonymous
class OptionsJS {
  external factory OptionsJS({
    /** @default Number.POSITIVE_INFINITY */
    double? maxSizeMB,
    /** @default undefined */
    double? maxWidthOrHeight,
    /** @default true */
    bool? useWebWorker,
    /** @default 10 */
    double? maxIteration,
    /** Default to be the exif orientation from the image file */
    double? exifOrientation,
    /** A function takes one progress argument (progress from 0 to 100) */
    Function(double progress)? onProgress,
    /** Default to be the original mime type from the image file */
    String? fileType,
    /** @default 1.0 */
    double? initialQuality,
    /** @default false */
    bool? alwaysKeepResolution,
    /** @default undefined */
    // AbortSignal? signal,
    /** @default false */
    bool? preserveExif,
    /** @default https://cdn.jsdelivr.net/npm/browser-image-compression/dist/browser-image-compression.js */
    String? libURL,
  });
}
