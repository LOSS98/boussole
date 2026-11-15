import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Phone only: portrait.
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    // No automatic retry: errors are shown with an explicit "Retry" button.
    ProviderScope(retry: (_, _) => null, child: const BoussoleApp()),
  );
}
