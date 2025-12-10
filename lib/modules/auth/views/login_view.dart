import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AuthController());

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  context.theme.colorScheme.primary,
                  context.theme.colorScheme.secondary,
                ],
              ),
            ),
          ),

          const Positioned(
            top: 150,
            left: 0,
            right: 0,
            child: Icon(Icons.menu_book, size: 100, color: Colors.white),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: 400,
              decoration: BoxDecoration(
                color: context.theme.scaffoldBackgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Welcome", style: context.textTheme.headlineLarge),
                  const SizedBox(height: 8),
                  Text(
                    "Sign in to your account",
                    style: context.textTheme.titleMedium?.copyWith(
                      color: context.theme.hintColor,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const Spacer(),

                  Obx(
                    () => controller.isLoading.value
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : Column(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: FilledButton(
                                  onPressed: () =>
                                      controller.signInWithGoogle(),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: context.theme.cardColor,
                                    foregroundColor: context
                                        .theme
                                        .textTheme
                                        .bodyLarge
                                        ?.color,
                                    side: BorderSide(
                                      color: context.theme.dividerColor,
                                      width: 0.5,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        'assets/images/google_logo.png',
                                        height: 24.0,
                                      ),
                                      SizedBox(width: 8.0),
                                      Text(
                                        'Sign in with Google',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 16),

                              Center(
                                child: TextButton(
                                  onPressed: () => controller.signInAsGuest(),
                                  child: Text(
                                    "Continue as guest",
                                    style: TextStyle(
                                      color: context.theme.colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
