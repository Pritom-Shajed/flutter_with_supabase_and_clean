import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_with_supabase/src/core/utils/logger/logger.dart';

final internetStreamPd =
    StreamProvider((ref) => Connectivity().onConnectivityChanged);

final internetFuturePd = FutureProvider<bool>((ref) async {
  ref.watch(internetStreamPd).value;
  final connectivity = await (Connectivity().checkConnectivity());
  log.f('Connectivity: $connectivity');
  if (connectivity.contains(ConnectivityResult.ethernet) ||
      connectivity.contains(ConnectivityResult.wifi) ||
      connectivity.contains(ConnectivityResult.mobile)) {
    return true;
  }
  return false;
});

final isConnectedPd =
    StateProvider<bool>((ref) => ref.watch(internetFuturePd).value ?? false);
