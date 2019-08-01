import 'package:flutter/material.dart';
import 'package:flutter_lime/beans/theme_config_bean.dart';
import 'package:provide/provide.dart';

class Store {
  static init(Widget child) {
    Providers providers = Providers()
      ..provide(Provider<ThemeConfigModel>.value(ThemeConfigModel()));
    return ProviderNode(
      child: child,
      providers: providers,
      dispose: true,
    );
  }

  //接收状态
  static connect<T>({builder, child, scope}) {
    return Provide<T>(builder: builder, child: child, scope: scope);
  }

  //发送状态
  static value<T>(context, {scope}) {
    return Provide.value<T>(context, scope: scope);
  }
}
