import 'package:flutter/material.dart';
import 'package:flutter_lime/utils/const.dart';

//设置页面
class SettingsPage extends StatelessWidget {
  List<SettingsBean> _settingsItems = [
    SettingsBean("关于$app_name", "", Icons.sentiment_satisfied),
    SettingsBean("自动进入拍照", "打开软件时自动进入拍照页面", Icons.sentiment_satisfied),
    SettingsBean("捐赠", "desc", Icons.sentiment_satisfied),
    SettingsBean("检查更新", "当前版本 v1.0", Icons.sentiment_satisfied),
    SettingsBean("更新日志", "", Icons.sentiment_satisfied),
    SettingsBean("评分", "desc", Icons.sentiment_satisfied),
    SettingsBean("关于", "desc", Icons.sentiment_satisfied),
    SettingsBean("关于", "desc", Icons.sentiment_satisfied),
    SettingsBean("关于", "desc", Icons.sentiment_satisfied),
    SettingsBean("关于", "desc", Icons.sentiment_satisfied),
    SettingsBean("关于", "desc", Icons.sentiment_satisfied),
    SettingsBean("关于", "desc", Icons.sentiment_satisfied),
    SettingsBean("关于", "desc", Icons.sentiment_satisfied),
    SettingsBean("关于", "desc", Icons.sentiment_satisfied),
    SettingsBean("关于", "desc", Icons.sentiment_satisfied),
    SettingsBean("关于", "desc", Icons.sentiment_satisfied),
    SettingsBean("关于", "desc", Icons.sentiment_satisfied),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("设置")),
      body: ListView.separated(
        itemCount: _settingsItems.length,
        itemBuilder: (context, index) {
          return _generateSettingsItem(_settingsItems[index], index);
        },
        separatorBuilder: (context, index) {
          return Divider(height: 1);
        },
      ),
    );
  }

  //生成设置项
  Widget _generateSettingsItem(SettingsBean bean, int index) {
    return ListTile(
      title: Text(bean.title),
      subtitle: Text(bean.desc),
    );
  }
}

class SettingsBean {
  String title;
  String desc;
  IconData icon;
  String value;
  SettingsBean(this.title, this.desc, this.icon, {this.value});
}
