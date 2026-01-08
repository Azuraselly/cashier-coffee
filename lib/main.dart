import 'package:flutter/material.dart';
import 'package:kasir/screens/auth/login_screen.dart';
import 'package:kasir/screens/cashier/cashier_screen.dart';
import 'package:kasir/screens/splashscreen.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart'; 
import 'providers/auth_provider.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'services/supabase_client.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // INI YANG BIKIN ERROR MERAH HILANG SELAMANYA
  await initializeDateFormatting('id_ID', null);
  // atau kalau mau semua locale sekaligus:
  // await initializeDateFormatting();

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
          create: (_) => AuthProvider()..checkAuthState(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Enjoyy Coffee POS',
        theme: ThemeData(
          primarySwatch: Colors.brown,
          useMaterial3: true,
          fontFamily: 'Inter',
          scaffoldBackgroundColor: const Color(0xFFFAFAFA),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            foregroundColor: Color(0xFF2D1B1B),
          ),
        ),
        home: CashierScreen(), 
        //  home: SplashScreen(),
        // routes: {
        //   '/login': (_) => const LoginScreen(),
        //   '/dashboard': (_) => const DashboardScreen(),
        // },
      ),
    );
  }
}