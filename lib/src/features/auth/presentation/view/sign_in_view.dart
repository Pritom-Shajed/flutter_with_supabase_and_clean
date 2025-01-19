import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_with_supabase/src/core/router/app_routes.dart';
import 'package:flutter_with_supabase/src/core/shared/buttons/social_button.dart';
import 'package:flutter_with_supabase/src/features/auth/widgets/sign_in_form.dart';
import 'package:flutter_with_supabase/src/features/auth/widgets/welcome_text.dart';
import 'package:go_router/go_router.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  static const String name = 'signin';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Sign In"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const WelcomeText(
                title: "Welcome!",
                text: "Enter your credentials to sign in.",
              ),
              const SignInForm(),

              Center(
                child: Text.rich(
                  TextSpan(
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(fontWeight: FontWeight.w600),
                    text: "Don’t have account? ",
                    children: <TextSpan>[
                      TextSpan(
                        text: "Create new account.",
                        style: const TextStyle(color: Color(0xFF22A45D)),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            context.push(AppRoutes.maintenanceBreakRoute);
                          },
                      )
                    ],
                  ),
                ),
              ),

              // Google
              SocalButton(
                press: () {},
                text: "Connect with Google",
                color: const Color(0xFF4285F4),
                icon: SvgPicture.asset(
                  'assets/svgs/google.svg',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
