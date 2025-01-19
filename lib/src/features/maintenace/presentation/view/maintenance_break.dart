import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_with_supabase/src/core/config/constants.dart';
import 'package:flutter_with_supabase/src/core/utils/extensions/extensions.dart';

class MaintenanceBreakView extends StatelessWidget {
  const MaintenanceBreakView({super.key});

  static const String name = 'maintenancebreak';

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
                'Maintenance Break',
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
