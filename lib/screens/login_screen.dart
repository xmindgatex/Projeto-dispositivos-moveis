// ================================================================
// Aluno   : Kaio Cesar de Sousa Pinheiro
// Curso   : DIM0524 - Desenvolvimento de Sistemas para Dispositivos Móveis
// Inst.   : Universidade Federal do Rio Grande do Norte (UFRN)
// ================================================================
// =============================================================
// ETAPA 3: Login via API (async/await) + persistência de sessão
// =============================================================
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import 'product_list_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false;

  Future<void> _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'Preencha todos os campos');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final token = await ApiService.login(username, password);

      if (token != null) {
        await AuthService.saveSession(
          token: token,
          username: username,
          password: password,
        );

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const ProductListScreen()),
          );
        }
      } else {
        setState(() => _errorMessage = 'Credenciais inválidas');
      }
    } catch (_) {
      setState(
          () => _errorMessage = 'Erro de conexão. Verifique sua internet.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F8),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Minha aplicação',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'usuário',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'senha',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onSubmitted: (_) => _login(),
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 8),
                Text(_errorMessage!,
                    style: const TextStyle(
                        color: Colors.red, fontWeight: FontWeight.w500)),
              ],
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                      : const Text('Login', style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Esqueceu a senha?',
                  style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 8),
              const Text('Não tem uma conta? Cadastre-se',
                  style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: const Column(
                  children: [
                    Text('Credenciais de teste (fakestoreapi):',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12)),
                    SizedBox(height: 4),
                    Text(
                      'Usuário: mor_2314\nSenha: 83r5^_',
                      style: TextStyle(fontSize: 12, fontFamily: 'monospace'),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
