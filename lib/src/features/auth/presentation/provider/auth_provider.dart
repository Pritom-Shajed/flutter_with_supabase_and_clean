import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_with_supabase/src/core/router/go_router.dart';
import 'package:flutter_with_supabase/src/core/shared/snackbar/snackbar.dart';
import 'package:flutter_with_supabase/src/core/utils/logger/logger.dart';
import 'package:flutter_with_supabase/src/features/auth/data/models/request/forget_password.dart';
import 'package:flutter_with_supabase/src/features/auth/data/models/request/signin.dart';
import 'package:flutter_with_supabase/src/features/auth/data/models/request/signup.dart';
import 'package:flutter_with_supabase/src/features/auth/domain/use_case/forget_pass.dart';
import 'package:flutter_with_supabase/src/features/auth/domain/use_case/signin.dart';
import 'package:flutter_with_supabase/src/features/auth/domain/use_case/signout.dart';
import 'package:flutter_with_supabase/src/features/auth/domain/use_case/signup.dart';
import 'package:flutter_with_supabase/src/service_locator.dart';

typedef AuthNotifer = NotifierProvider<AuthProvider, void>;

final authProvider = AuthNotifer(AuthProvider.new);

class AuthProvider extends Notifier {
  final signinFormKey = GlobalKey<FormState>();
  final signupFormKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final nameController = TextEditingController();
  final passController = TextEditingController();

  bool obscureText = true;
  bool isLoading = false;

  @override
  build() {
    emailController.text = 'pritom@gmail.com';
    phoneController.text = '01700000000';
    nameController.text = 'Pritom';
    passController.text = '123456';
  }

  toggleObsecureText() {
    obscureText = !obscureText;
    ref.notifyListeners();
  }

  Future<void> signIn(BuildContext context) async {
    if (!(signinFormKey.currentState?.validate() ?? false)) return;

    isLoading = true;
    ref.notifyListeners();

    final response = await sl<SigninUseCase>().call(
      params: SigninParams(
        email: emailController.text,
        password: passController.text,
      ),
    );

    isLoading = false;
    ref.notifyListeners();

    response.fold(
      (error) {
        KSnackbar.show(context, error.toString(), isError: true);
      },
      (success) {
        goRouter.refresh();
      },
    );
  }

  Future<void> signUp(BuildContext context) async {
    if (!(signupFormKey.currentState?.validate() ?? false)) return;

    isLoading = true;
    ref.notifyListeners();

    final response = await sl<SignupUseCase>().call(
      params: SignupParams(
        email: emailController.text,
        password: passController.text,
        phone: phoneController.text,
        name: nameController.text,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

    isLoading = false;
    ref.notifyListeners();

    response.fold(
      (error) {
        KSnackbar.show(context, error.toString(), isError: true);
      },
      (success) {
        goRouter.refresh();
      },
    );
  }

  Future<void> forgetPassword(BuildContext context) async {
    EasyLoading.show();

    final response = await sl<ForgetPassUseCase>().call(
      params: ForgetPasswordParams(
        email: emailController.text,
      ),
    );

    EasyLoading.dismiss();

    response.fold(
      (error) {
        KSnackbar.show(context, error.toString(), isError: true);
      },
      (success) {
        KSnackbar.show(context, 'Check your email for reset password link');
      },
    );
  }

  Future<void> signOut(BuildContext context) async {
    EasyLoading.show();

    final response = await sl<SignoutUseCase>().call();

    EasyLoading.dismiss();

    response.fold(
      (error) {
        KSnackbar.show(context, error.toString(), isError: true);
      },
      (success) {
        goRouter.refresh();
      },
    );
  }
}
