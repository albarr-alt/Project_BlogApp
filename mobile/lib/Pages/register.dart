import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool obscurePassword = true;
  bool isLoading = false;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    // 1. Validasi Nama
    if (name.isEmpty) {
      _showError("Mohon masukkan nama lengkap");
      return;
    }

    // 2. Validasi Email
    if (email.isEmpty || !email.contains('@')) {
      _showError("Mohon masukkan alamat email yang valid");
      return;
    }

    // 3. Validasi Password
    if (password.length < 6) {
      _showError("Password minimal harus 6 karakter");
      return;
    }

    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    setState(() => isLoading = true);

    // 5. Panggil API Register Backend
    final result = await AuthService.register(
      username: name,
      email: email,
      password: password,
    );

    if (!mounted) return;
    setState(() => isLoading = false);

    // 6. Tangani Respon Backend
    if (result['success'] == true) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? "Registrasi berhasil! Silakan login."),
          backgroundColor: Colors.green,
        ),
      );
      navigator.pop(); // Kembali ke halaman Login
    } else {
      messenger.showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? "Terjadi kesalahan saat registrasi"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 25),



              const SizedBox(height: 15),

              // Judul & Subjudul
              const Text(
                "Create Account",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff222222),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Sign up to get started with your account",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),

              const SizedBox(height: 30),

              // Input: Nama Lengkap
              _buildInputLabel("Full Name"),
              const SizedBox(height: 8),
              _buildTextField(
                controller: nameController,
                hintText: "Enter your full name",
                prefixIcon: Icons.person_outline,
              ),

              const SizedBox(height: 18),

              // Input: Email
              _buildInputLabel("Email Address"),
              const SizedBox(height: 8),
              _buildTextField(
                controller: emailController,
                hintText: "Enter your email",
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 18),

              // Input: Password
              _buildInputLabel("Password"),
              const SizedBox(height: 8),
              _buildTextField(
                controller: passwordController,
                hintText: "Create a password (min. 6 characters)",
                prefixIcon: Icons.lock_outline,
                obscureText: obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() => obscurePassword = !obscurePassword);
                  },
                ),
              ),

              const SizedBox(height: 15),



              const SizedBox(height: 25),

              // Tombol Create Account
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _handleRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text(
                          "Create Account",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 25),

              // Divider "or continue with"
              Row(
                children: [
                  const Expanded(child: Divider(color: Color(0xffdddddd))),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      "or continue with",
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                    ),
                  ),
                  const Expanded(child: Divider(color: Color(0xffdddddd))),
                ],
              ),

              const SizedBox(height: 20),

              // Tombol Google
              Center(
                child: SizedBox(
                  width: 80,
                  height: 54,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xffdddddd)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text(
                      "G",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff4285F4),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // Link Kembali ke Login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account? ",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Widget untuk Label Input
  Widget _buildInputLabel(String label) {
    return Text(
      label,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
    );
  }

  // Helper Widget untuk TextField
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
        prefixIcon: Icon(prefixIcon, size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0xfff8f8f8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }
}