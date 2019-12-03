import 'package:flutter/material.dart';
import 'package:flutter_lime/beans/db_ocr_history_bean.dart';
import 'package:flutter_lime/beans/db_search_history_bean.dart';
import 'package:flutter_lime/db/database_helper.dart';
import 'package:flutter_lime/utils/const.dart';
import 'package:flutter_lime/utils/dialog_utils.dart';
import 'package:flutter_lime/utils/log_utils.dart';
import 'package:flutter_lime/utils/utils.dart';
import 'package:flutter_lime/widgets/history_item.dart';
import 'package:flutter_lime/widgets/status_view.dart';

//历史搜索页
class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<DBOcrHistoryBean> _histories;
  List<DBSearchHistoryBean> _searchHistories;
  TextEditingController _controller;
  ThemeData _theme;

  //在搜索历史页面
  SearchType type = SearchType.SUGGESTION;

  //加载状态
  Status status = Status.LOADING;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(() {
      final originType = type;
      if (_controller.text.length == 0) {
        type = SearchType.SUGGESTION;
      }
      if (type != originType) {
        setState(() {});
      }
    });
    querySearchHistory();
  }

  @override
  Widget build(BuildContext context) {
    _generateTheme();
    var actions = <Widget>[];
    if (type == SearchType.RESULT) {
      actions.add(IconButton(
          icon: Icon(Icons.clear),
          onPressed: () => setState(() {
                type = SearchType.SUGGESTION;
                _controller.text = "";
              })));
    }
    return Scaffold(
        appBar: AppBar(
          backgroundColor: _theme.primaryColor,
          iconTheme: _theme.primaryIconTheme,
          textTheme: _theme.primaryTextTheme,
          brightness: _theme.primaryColorBrightness,
          title: TextField(
            controller: _controller,
            cursorColor: themeColors[currThemeColorIndex],
            style: TextStyle(fontSize: 18),
            onSubmitted: _search,
            autofocus: true,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "搜索识别历史",
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 18)),
          ),
          actions: actions,
        ),
        body: type == SearchType.SUGGESTION
            ? _generateSuggestions()
            : _generateResults());
  }

  void _generateTheme() {
    final theme = Theme.of(context);
    _theme = theme.copyWith(
      primaryColor: Colors.white,
      primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.grey),
      primaryColorBrightness: Brightness.light,
      primaryTextTheme: theme.textTheme,
    );
  }

  //结果列表
  Widget _generateResults() {
    Widget generate() {
      return ListView.separated(
        itemCount: _histories == null ? 0 : _histories.length,
        itemBuilder: (context, index) {
          return HistoryItem(
            bean: _histories[index],
            context: context,
          );
        },
        separatorBuilder: (context, index) {
          return Divider(height: 1);
        },
      );
    }

    return StatusView(status, generateContent: generate);
  }

  //搜索建议-历史
  Widget _generateSuggestions() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("搜索历史", style: TextStyle(color: Colors.grey[700])),
                IconButton(
                    icon: Icon(Icons.delete, color: Colors.grey[700]),
                    onPressed: _onClearSearchHistoryClicked),
              ]),
          Flexible(
            child: _generateSearchHistory(),
          )
        ],
      ),
    );
  }

  //生成搜索历史列表
  Widget _generateSearchHistory() {
    var status = Status.NORMAL;
    if (_searchHistories == null) {
      status = Status.LOADING;
    } else if (_searchHistories.length == 0) {
      status = Status.EMPTY;
    }

    List<Widget> list = [];
    if (_searchHistories != null) {
      list = _searchHistories.map((value) {
        return InkWell(
            onTap: () => _controller.text = value.text,
            child: Chip(
              onDeleted: () => _deleteSearchHistoryById(value),
              deleteIcon: Icon(Icons.close, size: 14, color: Colors.grey),
              label: Text(value.text),
            ));
      }).toList();
    }
    Widget generate() {
      return Container(
        width: screenSize.width,
        child: Wrap(
          spacing: 8,
          direction: Axis.horizontal,
          children: list,
        ),
      );
    }

    return StatusView(status, generateContent: generate);
  }

  //查询搜索历史
  void querySearchHistory() {
    DataBaseHelper.getInstance().querySearchHistory().then((value) {
      if (value == null) {
        value = List<DBSearchHistoryBean>();
      }
      LogUtils.i("querySearchHistory result: $value");
      setState(() {
        _searchHistories = value;
      });
    });
  }

  void _search(q) {
    setState(() {
      type = SearchType.RESULT;
      status = Status.LOADING;
    });
    DataBaseHelper.getInstance().queryOcrHistory(q).then((value) {
      _histories = value;

      setState(() {
        if (_histories == null || _histories.length == 0) {
          status = Status.EMPTY;
        } else {
          status = Status.NORMAL;
        }
      });

      final bean =
          DBSearchHistoryBean(text: _controller.text, time: getDateTime());
      DataBaseHelper.getInstance().insertSearchHistory(bean).then((id) {
        bean.id = id;
        _searchHistories.insert(0, bean);
        setState(() {});
      });
    });
  }

  void _onClearSearchHistoryClicked() {
    DialogUtils.showAlertDialog(context, Text("确定要清除所有搜索历史吗？"), [
      AlertDialogAction("清除", () {
        DataBaseHelper.getInstance().clearSearchHistory().then((value) {
          showMsg("清除成功");
          _searchHistories = [];
          setState(() {});
          Navigator.pop(context);
        });
      }),
      AlertDialogAction("取消", () => Navigator.pop(context)),
    ]);
  }

  void _deleteSearchHistoryById(DBSearchHistoryBean bean) {
    _searchHistories.remove(bean);
    DataBaseHelper.getInstance().deleteSearchHistoryByID(bean.id);
    setState(() {});
  }
}

enum SearchType {
  SUGGESTION, //建议
  RESULT //结果
}
