import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasir/screens/auth/login_screen.dart';
import '../../utils/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _rotateController;
  late AnimationController _fadeController;
  late AnimationController _steamController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _steamAnimation;

  @override
  void initState() {
    super.initState();

    // Scale + Rotate untuk gambar kopi
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    );
    _rotateController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _rotateAnimation = Tween<double>(begin: 0.0, end: 0.15).animate(
      CurvedAnimation(parent: _rotateController, curve: Curves.easeInOutSine)
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            _rotateController.reverse();
          } else if (status == AnimationStatus.dismissed) {
            _rotateController.forward();
          }
        }),
    );

    // Fade teks
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    // Uap kopi
    _steamController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _steamAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _steamController, curve: Curves.easeOut));

    // Mulai animasi
    _startAnimation();
  }

  void _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _scaleController.forward();
    _rotateController.forward();
    await Future.delayed(const Duration(milliseconds: 800));
    _fadeController.forward();

    await Future.delayed(const Duration(milliseconds: 2800));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 800),
          pageBuilder: (_, __, ___) => const LoginScreen(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rotateController.dispose();
    _fadeController.dispose();
    _steamController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // === LINGKARAN DEKORATIF ===
          _buildDecorativeCircle(top: -100, left: -100, size: 250, color: AppColors.azura.withOpacity(0.2)),
          _buildDecorativeCircle(top: -50, left: -50, size: 180, color: AppColors.selly.withOpacity(0.4)),
          _buildDecorativeCircle(bottom: -120, right: -120, size: 280, color: AppColors.azura.withOpacity(0.15)),
          _buildDecorativeCircle(bottom: -60, right: -60, size: 200, color: AppColors.selly.withOpacity(0.3)),

          // === KONTEN UTAMA ===
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // === GAMBAR KOPI + ANIMASI ===
                AnimatedBuilder(
                  animation: Listenable.merge([_scaleController, _rotateController]),
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Transform.rotate(
                        angle: _rotateAnimation.value,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Gambar kopi
                            Container(
                              width: 200,
                              height: 200,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFFD6ACAC),
                                    blurRadius: 30,
                                    offset: Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  'images/coffee.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),

                            // Uap kopi (steam effect)
                           
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 40),

                // === TEKS ===
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      Text(
                        AppText.appName,
                        style: GoogleFonts.pacifico(
                          fontSize: 54,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textPrimary,
                          letterSpacing: 1.5,
                          shadows: const [
                            Shadow(
                              offset: Offset(2, 2),
                              blurRadius: 6,
                              color: Colors.black12,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppText.tagline,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 80),

                // Loading halus
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: const SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(AppColors.azura),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDecorativeCircle({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required double size,
    required Color color,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}