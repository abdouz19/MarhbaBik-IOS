import 'package:url_launcher/url_launcher.dart';
import 'dart:developer';

class UrlHandler {
  /// Attempts to open the given [url] in in-app browser. Returns `true` after successful opening, `false` otherwise.
  static Future<bool> open(String url) async {
    try {
      await launch(
        url,
        enableJavaScript: true,
        forceWebView: true,  // To open URL within the app
        enableDomStorage: true,  // To enable DOM storage in the web view
      );
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }
}
