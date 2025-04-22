import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoping_app/providers.dart';
import 'package:shoping_app/ui/product_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: Builder(
        builder: (context) {
          // Access CartProvider here, after it has been created
          final cartProvider = Provider.of<CartProvider>(context);

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            themeMode: cartProvider.themeMode, // Accessing themeMode here
            theme: ThemeData(
              brightness: Brightness.light,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
              scaffoldBackgroundColor: Colors.grey.shade100,
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.green.shade500,
                foregroundColor: Colors.white,
              ),
              cardTheme: CardTheme(
                color: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              textTheme: const TextTheme(
                bodyMedium: TextStyle(color: Colors.black87),
              ),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.green, brightness: Brightness.dark),
              scaffoldBackgroundColor: const Color(0xFF121212),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFF1F1F1F),
                foregroundColor: Colors.white,
              ),
              cardTheme: CardTheme(
                color: const Color(0xFF1E1E1E),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              textTheme: const TextTheme(
                bodyMedium: TextStyle(color: Colors.white70),
              ),
            ),
            home: const ProductList(),
          );
        },
      ),
    );
  }
}
