import 'package:chat_app_flutter/data/services/service_locator.dart';
import 'package:chat_app_flutter/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_flutter/presentation/screens/authorization/login_screen.dart';

void main() async {
  
  await setupServiceLocator();
   runApp(const MyApp());
 
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Messenger App',
      navigatorKey: getIt<AppRouter>().navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const LoginScreen(),
    );
  }
}


//base repository
//getit -- service locator
//cubit