import 'package:chat_app_flutter/core/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app_flutter/core/common/custom_button.dart';
import 'package:chat_app_flutter/core/common/custom_text_field.dart';
import 'package:chat_app_flutter/data/services/service_locator.dart';
import 'package:chat_app_flutter/logic/cubits/auth/auth_cubit.dart';
import 'package:chat_app_flutter/logic/cubits/auth/auth_state.dart';
import 'package:chat_app_flutter/presentation/home/home_screen.dart'; // ✅ Correct import
import 'package:chat_app_flutter/router/app_router.dart'; // ✅ Ensure this file exists and configured correctly

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  final _nameFocus = FocusNode();
  final _usernameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _passwordFocus = FocusNode();

  bool _isPasswordVisible = false;

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) return 'Name is required';
    return null;
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) return 'Username is required';
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) return 'Contact is required';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.length < 6) return 'Password too short';
    return null;
  }

  void handleSignUp() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().signUp(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
            username: usernameController.text.trim(),
            fullName: nameController.text.trim(),
            phoneNumber: phoneController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      bloc: getIt<AuthCubit>(),
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          getIt<AppRouter>().pushAndRemoveUntil(const HomeScreen()); // ✅ No need for Routes.home
        } else if (state.status == AuthStatus.error) {
          UiUtils.showSnackBar(context: context, message: state.error);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(),
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    CustomButton(
                      onPressed: () {},
                      text: "Continue with Google",
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Create Account",
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Please fill in the details to continue",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: Colors.grey),
                    ),
                    const SizedBox(height: 30),
                    CustomTextField(
                      controller: nameController,
                      focusNode: _nameFocus,
                      validator: _validateName,
                      hintText: "Full Name",
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                    const SizedBox(height: 30),
                    CustomTextField(
                      controller: usernameController,
                      focusNode: _usernameFocus,
                      validator: _validateUsername,
                      hintText: "Username",
                      prefixIcon: const Icon(Icons.alternate_email_outlined),
                    ),
                    const SizedBox(height: 30),
                    CustomTextField(
                      controller: emailController,
                      hintText: "Email",
                      focusNode: _emailFocus,
                      validator: _validateEmail,
                      prefixIcon: const Icon(Icons.email_outlined),
                    ),
                    const SizedBox(height: 30),
                    CustomTextField(
                      controller: phoneController,
                      hintText: "Contact",
                      focusNode: _phoneFocus,
                      validator: _validatePhone,
                      prefixIcon: const Icon(Icons.phone_outlined),
                    ),
                    const SizedBox(height: 30),
                    CustomTextField(
                      controller: passwordController,
                      obscureText: !_isPasswordVisible,
                      hintText: "Password",
                      focusNode: _passwordFocus,
                      validator: _validatePassword,
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    CustomButton(onPressed: handleSignUp, text: "Create Account"),
                    const SizedBox(height: 20),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: "Already have an account? ",
                          style: TextStyle(color: Colors.grey[600]),
                          children: [
                            TextSpan(
                              text: "Login",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pop(context);
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
