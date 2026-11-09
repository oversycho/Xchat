import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:xchat/app/app.dart';
import 'package:xchat/app/app_config.dart';
import 'package:xchat/app/bootstrap.dart';
import 'package:xchat/core/di/injection_container.dart';

Future<void> main() => bootstrap((reporter) async {
      if (!AppConfig.isValid) return const ConfigErrorApp();

      await Supabase.initialize(url: AppConfig.supabaseUrl, anonKey: AppConfig.supabaseAnonKey);
      await configureDependencies(supabase: Supabase.instance.client, errorReporter: reporter);
      return const XchatApp();
    });
