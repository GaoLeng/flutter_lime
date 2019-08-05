import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'const.dart';
import 'log_utils.dart';

///获取缓存大小
Future getCacheSize() async {
  try {
    double value = 0;
    Directory tempDir = await getTemporaryDirectory();
    if (await tempDir.exists()) {
      value = await _getTotalSizeOfFilesInDir(tempDir);
    }
    LogUtils.i('临时目录大小: ' + value.toString());
    return _renderSize(value);
  } catch (e) {
    LogUtils.e(e);
  }
}

/// 递归方式 计算文件的大小
Future<double> _getTotalSizeOfFilesInDir(final FileSystemEntity file) async {
  try {
    if (file is File) {
      int length = await file.length();
      return double.parse(length.toString());
    }
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();
      double total = 0;
      if (children != null)
        for (final FileSystemEntity child in children)
          total += await _getTotalSizeOfFilesInDir(child);
      return total;
    }
    return 0;
  } catch (e) {
    LogUtils.e(e);
    return 0;
  }
}

Future<bool> clearCache() async {
  try {
    Directory tempDir = await getTemporaryDirectory();
    if (!await tempDir.exists()) return true;
    await _delDir(tempDir);
    return true;
  } catch (e) {
    LogUtils.e(e);
    return false;
  }
}

///递归方式删除目录
Future<Null> _delDir(FileSystemEntity file) async {
  try {
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();
      for (final FileSystemEntity child in children) {
        await _delDir(child);
      }
    }
    await file.delete();
  } catch (e) {
    LogUtils.e(e);
  }
}

///格式化文件大小
_renderSize(double value) {
  if (null == value) {
    return 0;
  }
  List<String> unitArr = List()..add('B')..add('K')..add('M')..add('G');
  int index = 0;
  while (value > 1024) {
    index++;
    value = value / 1024;
  }
  String size = value.toStringAsFixed(2);
  return "$size ${unitArr[index]}";
}

saveFile(String path, List<int> fileBytes) async {
  File(path)
    ..writeAsBytes(fileBytes).then((file) {
      file.create();
    });
  LogUtils.i("copyFile: $path");
}

//转换路径 isSave是否保存 保存则转换为短路径 反之为全路径
String convertPath(bool isSave, String path) {
  //android路径固定，不需要转换
  if (Platform.isAndroid) {
    return path;
  } else if (Platform.isIOS) {
    if (isSave) {
      return path.substring(path.lastIndexOf("/"));
    } else {
      return rootDir + path;
    }
  } else {
    throw Exception("Unsupported OS!");
  }
}

//ios的tmp文件夹
bool isIOSTmpDir(String path) {
  var paths = path.split("/");
  return Platform.isIOS && paths.contains("tmp");
}
