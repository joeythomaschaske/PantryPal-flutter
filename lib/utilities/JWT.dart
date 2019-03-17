import 'dart:convert';

class JWT {
  static bool refreshTokenActive(String refreshTokenExpiration) {
    return refreshTokenExpiration != null && int.parse(refreshTokenExpiration) > DateTime.now().toUtc().millisecondsSinceEpoch;
  }

  static bool isActive(String token) {
    if (token == null) return false;
    Map<String, dynamic> claims = decode(token);
    double now = DateTime.now().toUtc().millisecondsSinceEpoch / 1000;
    int expiration = claims['exp'];
    bool active = now < expiration;
    return active;
  }

  static Map<String, dynamic> decode(String token) {
    List<String> parts = token.split('.');
    String claims = _decodeBase64(parts[1]);
    return json.decode(claims);
  }

  static String _decodeBase64(String part) {
    String result = part.replaceAll('-', '+').replaceAll('_', '/');

    switch(result.length % 4) {
      case 0:
        break;
      case 2:
        result += '==';
        break;
      case 3:
        result += '=';
        break;
      default:
        break;
    }
    return utf8.decode(base64Url.decode(result));
  }
}