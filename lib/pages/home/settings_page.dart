import 'package:flutter/material.dart';
import 'package:flutter_lime/beans/theme_config_bean.dart';
import 'package:flutter_lime/utils/const.dart';
import 'package:flutter_lime/utils/dialog_utils.dart';
import 'package:flutter_lime/utils/file_utils.dart';
import 'package:flutter_lime/utils/http_utils.dart';
import 'package:flutter_lime/utils/log_utils.dart';
import 'package:flutter_lime/utils/store.dart';
import 'package:flutter_lime/utils/utils.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:package_info/package_info.dart';

//设置页面
class SettingsPage extends StatefulWidget {
  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  List<SettingsBean> _settingsItems;

  @override
  void initState() {
    super.initState();

    getBySP([settings_camera, settings_trans_option, settings_theme])
        .then((kv) async {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      var version = packageInfo.version;

      var cacheSize = await getCacheSize();

      _settingsItems = [
        SettingsBean(settings_camera, SettingsType.switch_,
            desc: "打开软件时自动进入拍照页面", value: currIsAutoCamera),
        SettingsBean(settings_trans_option, SettingsType.click, desc: "desc"),
        SettingsBean(settings_theme, SettingsType.color,
            desc: "选择 Meterial Design 风格的主题", value: currThemeColorIndex),
        SettingsBean(settings_clear_cache, SettingsType.click,
            desc: _getClearCacheDesc(cacheSize)),
        SettingsBean(settings_check_update, SettingsType.click,
            desc: "当前版本 v$version", value: version),
        SettingsBean(settings_update_log, SettingsType.click,
            desc: "查看历次更新的功能"),
        SettingsBean(settings_donation, SettingsType.click,
            desc: "您的支持是我更新的动力"),
        SettingsBean(settings_score, SettingsType.click, desc: "好用的话请给五颗⭐️哦"),
        SettingsBean(settings_feedback, SettingsType.click, desc: "提出您的意见和建议"),
        SettingsBean(settings_about, SettingsType.click),
      ];
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("设置")), body: _generateBody());
  }

  Widget _generateBody() {
    if (_settingsItems == null || _settingsItems.length == 0) {
      return Text("暂无数据");
    }
    return ListView.separated(
      itemCount: _settingsItems.length,
      itemBuilder: (context, index) {
        return _generateSettingsItem(_settingsItems[index], index);
      },
      separatorBuilder: (context, index) {
        return Divider(height: 1);
      },
    );
  }

  Widget _generateSettingsItem(SettingsBean bean, int index) {
    var row = Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <
        Widget>[
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        Text(bean.title, style: TextStyle(fontSize: 16)),
        Padding(padding: EdgeInsets.only(top: 2)),
        Text(bean.desc, style: TextStyle(fontSize: 14, color: Colors.grey))
      ]),
    ]);
    var widget = InkWell(
        onTap: () => _onSettingsItemClicked(bean),
        child:
            Container(padding: EdgeInsets.fromLTRB(12, 8, 12, 8), child: row));
    switch (bean.type) {
      case SettingsType.click:
        //to do nothing.
        break;
      case SettingsType.color:
        row.children.add(Container(
          width: 46,
          height: 24,
          decoration: BoxDecoration(
              shape: BoxShape.circle, color: themeColors[bean.value]),
        ));
        break;
      case SettingsType.switch_:
        row.children.add(Switch(
            value: bean.value,
            onChanged: (isCheck) => _onSwitchChanged(bean, isCheck)));
        break;
    }
    return widget;
  }

  _onSettingsItemClicked(SettingsBean bean) {
    switch (bean.type) {
      case SettingsType.click:
        _processWithType(bean);
        break;
      case SettingsType.color:
        _showThemeColorPicker(bean);
        break;
      case SettingsType.switch_:
        _onSwitchChanged(bean, !bean.value);
        break;
    }
  }

  _onSwitchChanged(SettingsBean bean, bool isCheck) {
    currIsAutoCamera = isCheck;
    bean.value = currIsAutoCamera;
    setState(() {});
    saveBySP(bean.key, currIsAutoCamera);
  }

  _processWithType(SettingsBean bean) {
    switch (bean.title) {
      case settings_about:
        break;
      case settings_camera:
        break;
      case settings_donation:
        break;
      case settings_check_update:
        HttpUtils.checkForUpdate(bean.value);
        break;
      case settings_update_log:
        break;
      case settings_score:
        break;
      case settings_feedback:
        break;
      case settings_clear_cache:
        _showClearCacheDialog(bean);
        break;
      case settings_trans_option:
        break;
    }
  }

  //主题色dialog
  _showThemeColorPicker(SettingsBean bean) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
              title: Text("选择主题色"),
              content: MaterialColorPicker(
                  colors: themeColors,
                  allowShades: false,
                  onColorChange: (Color color) {},
                  onMainColorChange: (ColorSwatch color) {
                    Store.value<ThemeConfigModel>(context).setTheme(color);
                    Navigator.pop(context);
                    currThemeColorIndex =
                        bean.value = themeColors.indexOf(color);
                    saveBySP(bean.key, bean.value);
                  },
                  selectedColor: themeColors[currThemeColorIndex]));
        });
  }

  //清除缓存dialog
  void _showClearCacheDialog(SettingsBean bean) {
    DialogUtils.showAlertDialog(context, "确认要清除缓存吗？", [
      DialogAction("清除", true),
      DialogAction("取消", false),
    ]).then((isClear) {
      if (!isClear) return null;
      return clearCache();
    }).then((isSuccess) {
      if (isSuccess == null) return null;
      showMsg("清除缓存${isSuccess ? "成功" : "失败"}");
      return getCacheSize();
    }).then((size) {
      if (size == null) return;
      bean.desc = _getClearCacheDesc(size);
      setState(() {});
    });
  }

  String _getClearCacheDesc(cacheSize) {
    return "缓存已占用 $cacheSize";
  }
}

class SettingsBean {
  String title; //标题
  String desc; //描述
//  IconData icon; //图标
  dynamic value; //设置的值
  String key; //标签，用来作为SharedPreference的key
  SettingsType type; //设置的类型
  List<dynamic> options; //选项

  SettingsBean(this.title, this.type,
      {this.desc = "", this.value, this.options}) {
    this.key = title;
  }
}

//设置类型
enum SettingsType {
  click, //单击
  color,
  switch_, //选项切换
}
