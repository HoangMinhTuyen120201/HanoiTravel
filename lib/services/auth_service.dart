class AuthService {
  // Dummy login
  Future<bool> login(String username, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    return username == 'user' && password == 'pass';
  }
}
