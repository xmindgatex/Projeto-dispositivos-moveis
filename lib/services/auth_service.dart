// ================================================================
// Aluno   : Kaio Cesar de Sousa Pinheiro
// Curso   : DIM0524 - Desenvolvimento de Sistemas para Dispositivos Móveis
// Inst.   : Universidade Federal do Rio Grande do Norte (UFRN)
// ================================================================
// =============================================================
// ETAPA 3: Persistência local com SharedPreferences
// =============================================================
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const _keyToken = 'auth_token';
  static const _keyUsername = 'saved_username';
  static const _keyPassword = 'saved_password';

  /// Salva token e credenciais no dispositivo
  static Future<void> saveSession({
    required String token,
    required String username,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
    await prefs.setString(_keyUsername, username);
    await prefs.setString(_keyPassword, password);
  }

  /// Verifica se existe sessão ativa salva
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_keyToken);
  }

  /// Remove todos os dados de sessão (logout)
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
    await prefs.remove(_keyUsername);
    await prefs.remove(_keyPassword);
  }
}
