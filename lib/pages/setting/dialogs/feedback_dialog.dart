import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dsm_helper/utils/utils.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedbackDialog {
  static Future<bool?> show({required BuildContext context}) async {
    Utils.vibrate(FeedbackType.warning);
    return await showCupertinoDialog<bool>(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text(
            "意见反馈",
            textAlign: TextAlign.center,
          ),
          content: const Text('您将进入"阿派派软件"反馈页面。是否确定要继续？'),
          actions: [
            CupertinoDialogAction(
              child: const Text('取消'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () async {
                final Uri url = Uri.parse('https://support.qq.com/product/350509');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                } else {
                  Utils.toast("无法打开反馈页面");
                }
                Navigator.of(context).pop(true);
              },
              child: const Text('进入反馈页面'),
            ),
          ],
        );
      },
    );
  }
}
