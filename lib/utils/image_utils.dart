import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

import 'const.dart';
import 'log_utils.dart';

class ImageUtils {

  static Future<List<int>> compressImage(String path,
      {int minWidth, int minHeight}) async {
    minWidth = minWidth ?? sizeForOcr.width.toInt();
    minHeight = minHeight ?? sizeForOcr.height.toInt();
    return await FlutterImageCompress.compressWithFile(path,
        autoCorrectionAngle: false, minWidth: minWidth, minHeight: minHeight);
  }

  static Future<File> compressImageAndCopyFile(String path, String targetPath,
      {int minWidth, int minHeight}) async {
    LogUtils.i("compressImageAndGetFile targetPath: $targetPath");
    return await FlutterImageCompress.compressAndGetFile(path, targetPath,
        autoCorrectionAngle: false,
        minWidth: minWidth ?? screenSize.width.toInt(),
        minHeight: minHeight ?? screenSize.height.toInt());
  }

  static Future<File> compressImageNative(String path, {int targetWidth = 0}) {
    return FlutterNativeImage.compressImage(path,
        targetWidth: targetWidth, targetHeight: targetWidth);
  }

  static Future<Size> getImagePropertiesNative(String path) async {
    var properties = await FlutterNativeImage.getImageProperties(path);
    return Size(properties.width.toDouble(), properties.height.toDouble());
  }
}
