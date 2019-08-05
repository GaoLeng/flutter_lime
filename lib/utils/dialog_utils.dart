import 'package:flutter/material.dart';

class DialogUtils {
  static Future<dynamic> showAlertDialog(
      context, content, List<DialogAction> actions) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("提示"),
            content: Text(content),
            actions: actions.map((action) {
              return FlatButton(
                  onPressed: () => Navigator.pop(context, action.value),
                  child: Text(action.name));
            }).toList(),
          );
        });
  }
}

class DialogAction {
  String name;
  dynamic value;

  DialogAction(this.name, this.value);
}
