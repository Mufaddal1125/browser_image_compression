import 'package:cross_file/cross_file.dart';
import 'package:flutter/services.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'browser_image_compression.dart';
import 'browser_image_compression_method_channel.dart';

abstract class BrowserImageCompressionPlatform extends PlatformInterface {
  /// Constructs a BrowserImageCompressionPlatform.
  BrowserImageCompressionPlatform() : super(token: _token);

  static final Object _token = Object();

  static BrowserImageCompressionPlatform _instance =
      MethodChannelBrowserImageCompression();

  /// The default instance of [BrowserImageCompressionPlatform] to use.
  ///
  /// Defaults to [MethodChannelBrowserImageCompression].
  static BrowserImageCompressionPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BrowserImageCompressionPlatform] when
  /// they register themselves.
  static set instance(BrowserImageCompressionPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<Uint8List> compressImageByXFile(XFile xfile, Options opts) {
    // to be implemented by the platform-specific implementation
    throw UnimplementedError(
        'compressImageByXFile() has not been implemented.');
  }

  Future<Uint8List> compressImage(
      String filename, Uint8List data, String mineType, Options opts) {
    // to be implemented by the platform-specific implementation
    throw UnimplementedError('compressImageByFile() has not been implemented.');
  }
}
