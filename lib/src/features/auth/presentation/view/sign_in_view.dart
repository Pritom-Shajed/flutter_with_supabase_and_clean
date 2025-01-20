import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_with_supabase/src/core/router/app_routes.dart';
import 'package:flutter_with_supabase/src/core/shared/buttons/social_button.dart';
import 'package:flutter_with_supabase/src/core/shared/snackbar/snackbar.dart';
import 'package:flutter_with_supabase/src/features/auth/presentation/provider/auth_provider.dart';
import 'package:flutter_with_supabase/src/features/auth/widgets/sign_in_form.dart';
import 'package:flutter_with_supabase/src/features/auth/widgets/welcome_text.dart';
import 'package:go_router/go_router.dart';

class SignInView extends ConsumerWidget {
  const SignInView({super.key});

  static const String name = 'signin';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(authProvider);
    final notifier = ref.watch(authProvider.notifier);
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
              SignInForm(
                formKey: notifier.signinFormKey,
                isLoading: notifier.isLoading,
                isObsecure: notifier.obscureText,
                onTapObsecurePass: notifier.toggleObsecureText,
                emailController: notifier.emailController,
                passController: notifier.passController,
                onFieldSubmitted: (_) async => await notifier.signIn(context),
                onTapForgetPass: () {},
                onTapSignIn: () async => await notifier.signIn(context),
              ),

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
                            context.push(AppRoutes.signupRoute);
                          },
                      )
                    ],
                  ),
                ),
              ),

              // Google
              SocalButton(
                press: () => KSnackbar.show(context, 'Will update soon!'),
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
