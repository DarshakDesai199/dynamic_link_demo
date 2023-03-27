import 'package:dynamic_link_demo/view_model/details_view_model.dart';
import 'package:dynamic_link_demo/view_model/product_view_model.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:developer';
import 'package:dynamic_link_demo/view/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DynamicLinksService {
  static Future<String> createDynamicLink({
    final String? userId,
  }) async {
    String _linkMessage;

    var parameters = DynamicLinkParameters(
      uriPrefix: 'https://metrixdata.page.link',
      link: Uri.parse('https://metrixdata.page.link/Product?id=$userId'),
      androidParameters: const AndroidParameters(
        packageName: "com.example.dynamic_link_demo",
        minimumVersion: 0,
      ),
    );

    print("parameters-----$parameters");
    Uri url;
    final ShortDynamicLink shortLink =
        await FirebaseDynamicLinks.instance.buildShortLink(parameters);
    url = shortLink.shortUrl;

    print("url-----$url");
    _linkMessage = url.toString();
    Share.share(_linkMessage);
    return _linkMessage;
  }

  static Future<void> handleDynamicLinks() async {
    // STARTUP FROM DYNAMIC LINK LOGIC
    // Get initial dynamic link if the app is started using the link

    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();

    _handleDeeplinkData(data);

    // IF APP IS IN BACKGROUND AND OPENED FROM DEEP LINKING
    FirebaseDynamicLinks.instance.onLink.listen((event) {
      print('onLink$event');
      _handleDeeplinkData(event);
    });
  }

  static _handleDeeplinkData(PendingDynamicLinkData? data) async {
    final Uri? deepLink = data?.link;

    if (deepLink != null) {
      var id = deepLink.queryParameters['id'];
      print("status---${id}");
      await Get.put(ProductDetailsViewModel()).productDetailsViewModel(id: id);
      await Future.delayed(
        const Duration(milliseconds: 500),
        () {
          Get.to(
            () => ProductDetailScreen(
              productId: id!,
            ),
          );
        },
      );
    }
  }
}
