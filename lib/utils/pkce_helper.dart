import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

class PkcePair {
  final String codeVerifier;
  final String codeChallenge;

  PkcePair(this.codeVerifier, this.codeChallenge);
}

class PkceUtil {
  static PkcePair generate() {
    final verifier = _generateCodeVerifier();
    final challenge = _generateCodeChallenge(verifier);
    return PkcePair(verifier, challenge);
  }

  static String _generateCodeVerifier() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~';
    final rand = Random.secure();
    return List.generate(128, (_) => chars[rand.nextInt(chars.length)]).join();
  }

  static String _generateCodeChallenge(String verifier) {
    final bytes = utf8.encode(verifier);
    final digest = sha256.convert(bytes);
    return base64UrlEncode(digest.bytes).replaceAll('=', '');
  }
}
