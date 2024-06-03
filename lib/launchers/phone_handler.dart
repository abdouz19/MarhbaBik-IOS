import 'package:url_launcher/url_launcher.dart';

class PhoneHandler {
  /// Attempts to make a phone call to the given [phoneNumber].
  static Future<void> makeCall(String phoneNumber) async {
    String url = 'tel:$phoneNumber';
    try {
      await launch(url);
    } catch (e) {
      throw 'Could not launch phone call';
    }
  }
}
