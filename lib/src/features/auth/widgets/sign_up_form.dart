import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_with_supabase/src/core/utils/extensions/extensions.dart';
import 'package:flutter_with_supabase/src/core/utils/theme/themes.dart';

class SignUpForm extends StatelessWidget {
  final bool isLoading;
  final TextEditingController? nameController;
  final TextEditingController? phoneController;
  final TextEditingController? emailController;
  final TextEditingController? passController;
  final GlobalKey<FormState>? formKey;
  final bool isObsecure;
  final VoidCallback? onTapObsecurePass;
  final VoidCallback? onTapForgetPass;
  final VoidCallback? onTapSignUp;
  final ValueChanged<String>? onFieldSubmitted;
  const SignUpForm({
    super.key,
    this.isLoading = false,
    required this.isObsecure,
    this.onTapObsecurePass,
    this.formKey,
    this.onTapForgetPass,
    this.nameController,
    this.phoneController,
    this.emailController,
    this.passController,
    this.onFieldSubmitted,
    this.onTapSignUp,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        spacing: 16,
        children: [
          TextFormField(
            controller: nameController,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            validator: (v) => v.isNullOrEmpty ? 'Name is required' : null,
            onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
            onFieldSubmitted: onFieldSubmitted,
            decoration: const InputDecoration(
              hintText: "Name",
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFF3F2F2)),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFF3F2F2)),
              ),
            ),
          ),
          TextFormField(
            controller: phoneController,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            validator: (v) => v.isNullOrEmpty
                ? 'Phone number is required'
                : !v!.isPhone
                    ? 'Invalid phone number'
                    : null,
            onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
            onFieldSubmitted: onFieldSubmitted,
            decoration: const InputDecoration(
              hintText: "Phone Number",
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFF3F2F2)),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFF3F2F2)),
              ),
            ),
          ),
          TextFormField(
            controller: emailController,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            validator: (v) => v.isNullOrEmpty
                ? 'Email is required'
                : !v!.isEmail
                    ? 'Invalid email address'
                    : null,
            onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
            onFieldSubmitted: onFieldSubmitted,
            decoration: const InputDecoration(
              hintText: "Email Address",
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFF3F2F2)),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFF3F2F2)),
              ),
            ),
          ),

          // Password Field
          TextFormField(
            controller: passController,
            obscureText: isObsecure,
            validator: (v) => v.isNullOrEmpty ? 'Password is required' : null,
            onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
            onFieldSubmitted: onFieldSubmitted,
            decoration: InputDecoration(
              hintText: "Password",
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFF3F2F2)),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFF3F2F2)),
              ),
              suffixIcon: GestureDetector(
                onTap: onTapObsecurePass,
                child: isObsecure
                    ? const Icon(Icons.visibility_off, color: Color(0xFF868686))
                    : const Icon(Icons.visibility, color: Color(0xFF868686)),
              ),
            ),
          ),

          // Sign Up Button
          ElevatedButton(
            onPressed: () {
              if (isLoading) return;
              if ((formKey?.currentState!.validate() ?? false)) {
                formKey?.currentState?.save();
                onTapSignUp?.call();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF22A45D),
              foregroundColor: white,
              minimumSize: const Size(double.infinity, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: isLoading
                ? SpinKitThreeBounce(
                    color: white,
                    size: 20,
                  )
                : const Text("Sign up"),
          ),
        ],
      ),
    );
  }
}
