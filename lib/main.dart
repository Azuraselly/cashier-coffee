import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
import 'providers/auth_provider.dart';
import 'services/supabase_client.dart';
// import 'screens/auth/login_screen.dart';
// import 'screens/splashscreen.dart';   
import 'screens/produk/ProdukManagementScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Supabase
  await SupabaseClientService.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
  return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider()..checkAuthState(), // Cek status login saat start
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Enjoyy Coffee POS',
        theme: ThemeData(
          primarySwatch: Colors.brown, // Ganti ke coklat biar cocok tema kopi
          useMaterial3: true,
          fontFamily: 'Inter',
          scaffoldBackgroundColor: const Color(0xFFFAFAFA),
        ),
        home: const ProdukManagementScreen(), 
        // debugShowCheckedModeBanner: false,
        // routes: {
        //   '/login': (_) => const LoginScreen(),
        //   '/dashboard': (_) => const DashboardScreen(),
        // },
      ),
    );
  }
}