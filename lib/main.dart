import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fl_products/services/services.dart';

import 'package:fl_products/screens/screens.dart';
import 'package:fl_products/providers/login_form_provider.dart';

void main() => runApp(const AppState());

class AppState extends StatelessWidget {
  const AppState({super.key});
  
  @override
  Widget build (BuildContext context) { 
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: ( _ ) => AuthService()),
      ChangeNotifierProvider(create: ( _ ) => LoginFormProvider()),
      ChangeNotifierProvider(create: ( _ ) => ProductsService()),
    ],

    child: const MyApp(),
    );
  }}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'login',
      routes: {
        'login'    :(_) => const LoginScreen(),
        'home'     :(_) => const HomeScreen(), 
        'product'  :(_) => const ProductScreen(), 
        'register' :(_) => const RegisterScreen(),
        'checking' :(_) => const CheckAuthScreen(),
      },
      scaffoldMessengerKey: NotificationsService.messengerKey,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.grey[300],
        appBarTheme: const AppBarTheme(color: Colors.indigo),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: Colors.indigo)
      ),
    );
  }
}
