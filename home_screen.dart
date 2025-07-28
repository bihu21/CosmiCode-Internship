import 'package:chat_app_flutter/data/services/service_locator.dart';
import 'package:chat_app_flutter/logic/cubits/auth/auth_cubit.dart';
import 'package:chat_app_flutter/presentation/screens/authorization/login_screen.dart';
import 'package:chat_app_flutter/router/app_router.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          InkWell(
            onTap: () async {
              await getIt<AuthCubit>().signOut();
              getIt<AppRouter>().pushAndRemoveUntil(const LoginScreen());
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.logout),
            ),
          ),
        ],
      ),
      body: const Center(
        child: Text("User is authenticated"),
      ),
    );
  }
}
