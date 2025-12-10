import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/primary_button.dart';
import '../../auth/controllers/auth_controller.dart';

class ProfileView extends GetView<AuthController> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: context.theme.colorScheme.primary.withOpacity(0.2),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 70,
                  backgroundColor: context.theme.disabledColor.withOpacity(0.1),
                  backgroundImage: user?.photoURL != null
                      ? NetworkImage(user!.photoURL!)
                      : null,
                  child: user?.photoURL == null
                      ? Icon(
                          Icons.person,
                          size: 70,
                          color: context.theme.disabledColor,
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 32),

              Text(
                "Hello, ${user?.displayName?.isEmpty == true ? 'Guest' : (user?.displayName ?? 'Guest')}!",
                textAlign: TextAlign.center,
                style: context.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              if (user?.email != null && user?.email?.isEmpty == false)
                Text(
                  user?.email ?? "",
                  textAlign: TextAlign.center,
                  style: context.textTheme.titleMedium?.copyWith(
                    color: context.theme.textTheme.bodyMedium?.color,
                  ),
                ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  onPressed: () {
                    Get.defaultDialog(
                      title: "Logout",
                      titleStyle: context.theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      titlePadding: EdgeInsets.only(top: 20),
                      contentPadding: EdgeInsets.all(20),
                      middleText: "Are you sure you want to log out?",
                      middleTextStyle: context.theme.textTheme.bodyMedium,
                      backgroundColor: context.theme.scaffoldBackgroundColor,
                      textConfirm: "Yes",
                      textCancel: "No",
                      confirmTextColor: Colors.white,
                      cancelTextColor: context.theme.colorScheme.error,
                      buttonColor: context.theme.colorScheme.error,
                      onConfirm: () {
                        controller.logout();
                      },
                    );
                  },
                  icon: Icons.logout,
                  text: "Logout",
                  colors: [
                    context.theme.colorScheme.error.withOpacity(0.8),
                    context.theme.colorScheme.error,
                    context.theme.colorScheme.secondary,
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
