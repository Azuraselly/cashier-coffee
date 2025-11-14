import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/constants.dart';
import 'register_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  void _login() async {
    setState(() => _loading = true);
    try {
      await context.read<AuthProvider>().login(
            _emailController.text,
            _passwordController.text,
          );
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
Widget build(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final isLarge = size.width > 480;

  return Scaffold(
    backgroundColor: AppColors.background,
    body: SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // === LINGKARAN DEKORATIF KIRI ATAS ===
              Positioned(
                top: -80,
                left: 60,
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    color: AppColors.azura,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                top: -30,
                left: -30,
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    color: AppColors.selly,
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              // === LINGKARAN DEKORATIF KANAN BAWAH ===
              Positioned(
                bottom: -80,
                right: 60,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: AppColors.azura,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                bottom: -30,
                right: -30,
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    color: AppColors.selly,
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              // === KONTEN UTAMA: Scrollable & Full Height ===
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isLarge ? size.width * 0.15 : 32,
                  vertical: 40,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight, // Pastikan minimal setinggi layar
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // === HEADER ===
                        Column(
                          children: [
                            const SizedBox(height: 24),
                            Text(
                              AppText.appName,
                              style: GoogleFonts.pacifico(
                                fontSize: 48,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              AppText.tagline,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 48),

                        // === CARD FORM ===
                        Container(
                          padding: EdgeInsets.all(isLarge ? 40 : 32),
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // === TABS: Log In / Sign Up ===
                              ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.azura, width: 1.5),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _tabButton('Log In', true),
                                      _tabButton('Sign Up', false, onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (_) => const RegisterScreen()),
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),

                              // === INPUT: Username/Email ===
                              _inputField(
                                controller: _emailController,
                                label: 'Username/email',
                                icon: Icons.person_outline,
                              ),
                              const SizedBox(height: 16),

                              // === INPUT: Password ===
                              _inputField(
                                controller: _passwordController,
                                label: 'Password',
                                icon: Icons.lock_outline,
                                obscure: _obscure,
                                suffix: IconButton(
                                  icon: Icon(
                                    _obscure ? Icons.visibility : Icons.visibility_off,
                                    color: AppColors.textSecondary,
                                  ),
                                  onPressed: () => setState(() => _obscure = !_obscure),
                                ),
                              ),
                              const SizedBox(height: 32),

                              // === BUTTON: Log In ===
                              SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: _loading ? null : _login,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.azura,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(28),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: _loading
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Text(
                                          'Log In',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // === SPASI AKHIR (biar bisa scroll ke bawah) ===
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    ),
  );
}

  // === WIDGET: Tab Button (Log In / Sign Up) ===
  Widget _tabButton(String text, bool active, {VoidCallback? onTap}) {
  final borderRadius = active
      ? const BorderRadius.only(
          topLeft: Radius.circular(30),
          bottomLeft: Radius.circular(30),
        )
      : const BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        );

  return Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        
        height: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? AppColors.azura : Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: active ? Colors.white : AppColors.azura,
          ),
        ),
      ),
    ),
  );
}

  // === WIDGET: Input Field ===
  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.textSecondary),
        suffixIcon: suffix,
        filled: true,
        fillColor: AppColors.inputFill,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.azura, width: 2),
        ),
        labelStyle: TextStyle(color: AppColors.textSecondary),
      ),
    );
  }
}