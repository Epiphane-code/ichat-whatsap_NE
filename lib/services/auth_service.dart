class AuthService {
  // Simulated authentication service
  Future<bool> authenticate(String phone, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    // Simple authentication logic
    return phone == '9696' && password == '1234';
  }
}