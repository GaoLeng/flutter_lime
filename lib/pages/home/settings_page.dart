import 'package:flutter/material.dart';
import 'package:flutter_lime/utils/const.dart';
import 'package:flutter_lime/utils/utils.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

//设置页面
class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List<SettingsBean> _settingsItems;

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance()
        .then((value) {
          var autoCamera = value.getString(settings_camera);
//      PackageInfo packageInfo = await PackageInfo.fromPlatform();
          var version = "";

          _settingsItems = [
            SettingsBean(settings_camera, SettingsType.switch_,
                desc: "打开软件时自动进入拍照页面", value: autoCamera),
            SettingsBean(settings_trans_option, SettingsType.click,
                desc: "desc"),
            SettingsBean(settings_theme, SettingsType.click, desc: "当前"),
            SettingsBean(settings_clear_cache, SettingsType.click,
                desc: "40.45 M"),
            SettingsBean(settings_update_log, SettingsType.click,
                desc: "查看历次更新的功能"),
            SettingsBean(settings_donation, SettingsType.click,
                desc: "您的支持是我更新的动力"),
            SettingsBean(settings_score, SettingsType.click,
                desc: "好用的话请给五颗⭐️哦"),
            SettingsBean(settings_feedback, SettingsType.click,
                desc: "提出您的意见和建议"),
            SettingsBean(settings_check_update, SettingsType.click,
                desc: "当前版本 v$version"),
            SettingsBean(settings_about, SettingsType.normal),
          ];
          setState(() {});
        })
        .then((value) {})
        .then((value) {});
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
      case SettingsType.normal:
        //to do nothing.
        break;
      case SettingsType.click:
        //to do nothing.
        break;
      case SettingsType.switch_:
        final bool isCheck = value2Bool(bean.value);
        row.children.add(Switch(
            value: isCheck,
            onChanged: (isCheck) => _onSwitchChanged(bean, isCheck)));
        break;
    }
    return widget;
  }

  _onSettingsItemClicked(SettingsBean bean) {
    showMsg(bean.title);
    switch (bean.type) {
      case SettingsType.normal:
        return;
      case SettingsType.click:
        _processWithType(bean);
        break;
      case SettingsType.switch_:
        _onSwitchChanged(bean, !value2Bool(bean.value));
        break;
    }
  }

  _onSwitchChanged(SettingsBean bean, bool isCheck) {
    bean.value = bool2Value(isCheck);
    setState(() {});
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
        break;
      case settings_update_log:
        break;
      case settings_score:
        break;
      case settings_feedback:
        break;
      case settings_theme:
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                  content: MaterialColorPicker(
                      onColorChange: (Color color) {
                        showMsg("onColorChange: ${color.toString()}");
                      },
                      onMainColorChange: (ColorSwatch color) {
                        showMsg("onMainColorChange: ${color.toString()}");
                      },
                      selectedColor: Colors.red));
            });
        break;
      case settings_clear_cache:
        break;
      case settings_trans_option:
        break;
    }
  }
}

class SettingsBean {
  String title; //标题
  String desc; //描述
//  IconData icon; //图标
  String value; //设置的值
  String tag; //标签，用来作为SharedPreference的key
  SettingsType type; //设置的类型
  List<dynamic> options; //选项

  SettingsBean(this.title, this.type,
      {this.desc = "", this.value, this.options}) {
    this.tag = title;
  }
}

//设置类型
enum SettingsType {
  normal, //普通
  click, //单击
  switch_, //选项切换
}
