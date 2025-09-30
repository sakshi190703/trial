import 'package:flutter/services.dart';
import 'package:Kootumb/main.dart';

class ProxySettings {
  static const channel = MethodChannel('social.kootumb/proxy_settings');

  static Future<String> findProxy(Uri url) async {
    // mobile platforms seem to use the system proxy automatically, so return
    // 'DIRECT' to use defaults
    if (isOnDesktop) {
      return await channel.invokeMethod('findProxy', {'url': url.toString()});
    } else {
      return 'DIRECT';
    }
  }
}
