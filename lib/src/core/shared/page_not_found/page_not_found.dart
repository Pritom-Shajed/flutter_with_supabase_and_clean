import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_with_supabase/src/core/shared/snackbar/snackbar.dart';
import 'package:flutter_with_supabase/src/core/utils/extensions/extensions.dart';
import 'package:flutter_with_supabase/src/core/utils/theme/themes.dart';
import 'package:flutter_with_supabase/src/service_locator.dart';
import 'package:flutter_svg/flutter_svg.dart' show SvgPicture;

import '../../config/constants.dart';
import '../../config/get_platform.dart';

class KPageNotFound extends StatelessWidget {
  const KPageNotFound({super.key, required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: mainMin,
            mainAxisAlignment: mainCenter,
            children: [
              SvgPicture.asset(
                'assets/svgs/error.svg',
                height: context.width * 0.35,
                width: context.width * 0.35,
              ),
              Text(
                'Error: $error',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class KServerNotRunning extends StatelessWidget {
  const KServerNotRunning({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: mainMin,
              mainAxisAlignment: mainCenter,
              children: [
                SvgPicture.asset(
                  'assets/svgs/server-error.svg',
                  height: context.width * 0.35,
                  width: context.width * 0.35,
                ),
                const Text(
                  'Server is not running! We are working on it. Sorry for the inconvenience.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                OutlinedButton.icon(
                  style: ButtonStyle(
                    minimumSize: WidgetStateProperty.all(const Size(150, 42)),
                  ),
                  onPressed: () {
                    if (sl<PT>().isNotWeb) {
                      exit(0);
                    } else {
                      KSnackbar.show(
                        context,
                        'Please close the browser tab and visit again.',
                        isError: true,
                      );
                    }
                  },
                  label: const Text('Exit'),
                  icon: const Icon(Icons.exit_to_app),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class KDataNotFound extends StatelessWidget {
  const KDataNotFound({super.key, this.msg});

  final String? msg;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: mainMin,
            mainAxisAlignment: mainCenter,
            children: [
              SvgPicture.asset(
                'assets/svgs/no-data.svg',
                height: context.width * 0.15,
                width: context.width * 0.15,
              ),
              Text(
                msg ?? 'No data found!',
                textAlign: TextAlign.center,
                style: context.text.labelLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AccesDeniedPage extends StatelessWidget {
  const AccesDeniedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: mainMin,
            mainAxisAlignment: mainCenter,
            children: [
              Center(
                child: SvgPicture.asset(
                  'assets/svgs/access-denied.svg',
                  height: context.width * 0.15,
                  width: context.width * 0.15,
                  colorFilter: context.theme.primaryColor.toColorFilter,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'You are not authorized to access this page!\nIf you think this is a mistake, please contact your administrator.',
                textAlign: TextAlign.center,
                style: context.text.labelLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
