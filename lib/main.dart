import 'package:dw_delivery_app/app/core/env/env.dart';
import 'package:dw_delivery_app/app/dw_delivery_app.dart';
import 'package:flutter/cupertino.dart';

main() async {
  await Env.i.load();
  runApp(DwDeliveryApp());
}
