import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_with_supabase/src/core/config/constants.dart';
import 'package:flutter_with_supabase/src/core/config/size.dart';
import 'package:flutter_with_supabase/src/core/utils/extensions/extensions.dart';
import 'package:flutter_with_supabase/src/features/internet/providers/internet.dart';

class InternetBarView extends ConsumerWidget {
  const InternetBarView({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConnected = ref.watch(isConnectedPd);
    return isConnected
        ? const SizedBox()
        : _NoInternetBarWidget(message ?? 'No internet connection');
  }
}

class _NoInternetBarWidget extends StatelessWidget {
  const _NoInternetBarWidget(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 25.0,
      color: Colors.red[100],
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: mainCenter,
        children: [
          Icon(
            Icons.wifi_off,
            color: Colors.red[900],
            size: 15.0,
          ),
          const SizedBox(width: 5.0),
          Text(
            message,
            style: context.text.labelMedium!.copyWith(
              color: Colors.red[900],
            ),
          ),
        ],
      ),
    );
  }
}

class InternetView extends ConsumerWidget {
  const InternetView({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConnected = ref.watch(isConnectedPd);
    return isConnected
        ? child
        : Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(defaultPadding / 2),
                child: SizedBox(
                  width: 500.0,
                  child: Column(
                    spacing: 20,
                    mainAxisSize: mainMin,
                    children: [
                      const Icon(Icons.wifi_off,
                          color: Colors.red, size: 150.0),
                      Text(
                        'No Internet',
                        style: context.text.titleLarge,
                      ),
                      Text(
                        'Your device is not connected to the internet. Please check your connection! Will automatically reconnect when the internet is available.',
                        style: context.text.bodyLarge!.copyWith(
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
