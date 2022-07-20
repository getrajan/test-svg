import 'dart:convert';

import 'package:crypto/crypto.dart';

void main() {
  String msg =
      "MERCHANTID=510,APPID=MER-510-APP-1,APPNAME=Jay Media Management Pvt Ltd.,TXNID=8024,TXNDATE=17-03-2022,TXNCRNCY=NPR,TXNAMT=1000,REFERENCEID=1.2.4,REMARKS=123455,PARTICULARS=12345,TOKEN=TOKEN";
  var bytes = utf8.encode(msg);
  Digest sha256Result = sha256.convert(bytes);
  print(sha256Result);
}
