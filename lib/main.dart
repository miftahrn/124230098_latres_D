import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/app_config.dart';
import 'models/cart_item.dart';
import 'screens/login_screen.dart';
import 'screens/main_screen.dart';
import 'services/auth_service.dart';
import 'services/cart_service.dart';
import 'utils/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final preferences = await SharedPreferences.getInstance();
  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(CartItemAdapter.adapterTypeId)) {
    Hive.registerAdapter(CartItemAdapter());
  }
  await Hive.openBox<CartItem>(AppConfig.cartBoxName);

  final authService = AuthService(preferences);
  runApp(
    MyApp(
      authService: authService,
      cartService: CartService(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.authService,
    this.cartService,
  });

  final AuthService authService;
  final CartService? cartService;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: authService.isLoggedIn
          ? MainScreen(
              authService: authService,
              cartService: cartService!,
            )
          : LoginScreen(
              authService: authService,
              cartService: cartService,
            ),
    );
  }
}
