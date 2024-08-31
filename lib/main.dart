import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/app/ui/routes/pages.dart';
import 'package:app/app/ui/routes/routes.dart';
import 'package:app/app/ui/pages/home/home_page.dart';
import 'package:app/app/ui/pages/home/home_controller.dart';
void main() {
 runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => homecontroller()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      theme: ThemeData(
    
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
          initialRoute: Routes.SPLASH,
          routes: appRoutes(),
    );
  }
}