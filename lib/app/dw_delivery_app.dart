import 'package:dw_delivery_app/app/core/global/global_context.dart';
import 'package:dw_delivery_app/app/core/provider/application_binding.dart';
import 'package:dw_delivery_app/app/core/ui/theme/theme_config.dart';
import 'package:dw_delivery_app/app/pages/auth/login/login_router.dart';
import 'package:dw_delivery_app/app/pages/home/home_router.dart';
import 'package:dw_delivery_app/app/pages/order/order_router.dart';
import 'package:dw_delivery_app/app/pages/product_detail/product_detail_router.dart';
import 'package:flutter/material.dart';
import 'pages/auth/register/register_router.dart';
import 'pages/order/order_completed_page.dart';
import 'pages/splash/splash_page.dart';

class DwDeliveryApp extends StatelessWidget {
  final _navKey = GlobalKey<NavigatorState>();

  DwDeliveryApp({super.key}) {
    GlobalContext.i.navigatorKey = _navKey;
  }

  @override
  Widget build(BuildContext context) {
    return ApplicationBinding(
      key: _navKey,
      child: MaterialApp(
          title: 'Delivery App',
          routes: {
            '/': (context) => const SplashPage(),
            '/home': (context) => HomeRouter.page,
            '/productDetail': (context) => ProductDetailRouter.page,
            '/auth/login': ((context) => LoginRouter.page),
            '/auth/register': ((context) => RegisterRouter.page),
            '/order': ((context) => OrderRouter.page),
            '/order/completed': ((context) => const OrderCompletedPage())
          },
          theme: ThemeConfig.theme),
    );
  }
}
