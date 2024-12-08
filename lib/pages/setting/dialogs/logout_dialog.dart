import 'package:dsm_helper/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:sp_util/sp_util.dart';

class LogoutDialog {
  static Future<bool?> show({required BuildContext context}) async {
    Utils.vibrate(FeedbackType.warning);
    return await showCupertinoDialog<bool>(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            "退出登录",
            textAlign: TextAlign.center,
          ),
          content: Text("确定要退出登录吗？"),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: CupertinoButton(
                    onPressed: () async {
                      SpUtil.remove("user_token");
                      SpUtil.remove("no_ad_time");
                      Utils.toast("已退出登录");
                      Navigator.of(context).pop(true);
                    },
                    color: Theme.of(context).colorScheme.error,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "退出登录",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: CupertinoButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    color: Theme.of(context).disabledColor,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "取消",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
