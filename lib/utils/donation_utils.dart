//捐赠工具类
import 'package:flutter/services.dart';
import 'package:flutter_lime/utils/dialog_utils.dart';
import 'package:flutter_lime/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

import 'const.dart';

//捐赠工具类
class DonationUtils {
//支付宝转账
  static void openAlipayTransfer() {
    launch("https://qr.alipay.com/fkx07821pved0tunxbrzzc2");
  }

  //微信赞赏码
  static void openWechatAppreciates(context) {
    //  weixin://
    //  mqqzone://
    DialogUtils.showAlertDialog(
        context, Image.asset("images/wechat_appreciates.jpg"), [
      AlertDialogAction("保存到相册并打开微信", () {
        launch("weixin://");
        Navigator.pop(context);
        //TODO  保存图片
        showMsg("图片已保存到相册中，请打开微信选择图片扫描");
      }),
      AlertDialogAction("关闭", () => Navigator.pop(context)),
    ]);
  }

  //支付宝红包搜索码
  static void openAlipayRedPacketCode(context) {
    const msg = "已成功复制红包搜索码 “$alipay_red_packet_code”，打开支付宝首页搜索领红包";
    copy2Clipboard(alipay_red_packet_code);
    showMsg(msg);
    launch("https://render.alipay.com/p/s/i?scheme");

//    DialogUtils.showAlertDialog(context, Text(msg), [
//      AlertDialogAction("复制红包搜索码", () {
//        Navigator.pop(context);
//        copy2Clipboard(alipay_red_packet_code);
//        showMsg(msg);
//      }),
//      AlertDialogAction("关闭", () => Navigator.pop(context))
//    ]);
  }

  static copy2Clipboard(text) {
    Clipboard.setData(ClipboardData(text: text));
  }
}
