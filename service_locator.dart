import 'package:chat_app_flutter/data/repositories/auth_repository.dart';
import 'package:chat_app_flutter/logic/cubits/auth/auth_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:chat_app_flutter/router/app_router.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:chat_app_flutter/firebase_options.dart'; // Make sure this file exists

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Lazy singletons
  getIt.registerLazySingleton(() => AppRouter());
  getIt.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepository());

  // AuthCubit needs AuthRepository injected
  getIt.registerFactory<AuthCubit>(() => AuthCubit(authRepository: getIt<AuthRepository>()));
  
}
