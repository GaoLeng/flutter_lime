import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_lime/utils/utils.dart';

//历史识别页面
class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListView.builder(
        itemCount: 50,
        itemBuilder: ((context, index) {
          return generateItem(index);
        }),
      ),
    );
  }

  Widget generateItem(int index) {
    return InkWell(
      onTap: () => _onItemClick(index),
      child: Container(
        padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
        child: Row(
          children: <Widget>[
            Image.asset(
              "images/logo.png",
              width: 100,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text(
                    "历史：$index, w详情详情详情详情详情详情详情详情情详情详情详情详情详情详情详情详情详情",
                    textAlign: TextAlign.start,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text("07-29 22:17")
              ],
            )
          ],
        ),
      ),
    );
  }

  void _onItemClick(int index) {
    Utils.showMsg("it's index $index.");
  }
}
