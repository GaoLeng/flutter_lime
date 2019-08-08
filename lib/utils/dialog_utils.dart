import 'package:flutter/material.dart';

class DialogUtils {
  static showLoading(context, {content = "加载中..."}) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return Dialog(
              child: Container(
            padding: EdgeInsets.only(left: 20),
            width: 180,
            height: 80,
            child: Row(
              children: <Widget>[
                CircularProgressIndicator(),
                Padding(padding: EdgeInsets.only(left: 20)),
                Text(content,
                    style: TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
          ));
        });
  }

  static Future<dynamic> showAlertDialog(
      context, child, List<AlertDialogAction> actions) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("提示"),
            content: child,
            actions: actions.map((action) {
              return FlatButton(
                  onPressed: () => action.onPress(), child: Text(action.name));
            }).toList(),
          );
        });
  }

  static showOptionDialog(context, title, List<AlertDialogAction> items) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
              title: Text(title),
              children: items.map((item) {
                return SimpleDialogOption(
                    child: Text(item.name, style: TextStyle(fontSize: 16)),
                    onPressed: () {
                      Navigator.pop(context);
                      item.onPress();
                    });
              }).toList());
        });
  }

  static showGeneralDialog(context, child, List<AlertDialogAction> actions) {
    return showDialog(
      context: context,
      child: AlertDialog(
        title: Text("提示"),
        content: child,
        actions: actions.map((action) {
          return FlatButton(
            child: Text(action.name),
            onPressed: action.onPress,
          );
        }).toList(),
      ),
    );
  }

  static void dismiss(context) {
    Navigator.pop(context);
  }
}

class AlertDialogAction {
  String name;
  Function onPress;

  AlertDialogAction(this.name, this.onPress);
}
