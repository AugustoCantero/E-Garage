import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/router/app_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/preferencias/pref_usuarios.dart';
import 'package:flutter_application_1/services/bloc/notifications_bloc.dart';
import 'package:flutter_application_1/services/localNotification/local_notification.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferenciasUsuario.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await LocalNotification.initializeLocalNotifications();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => NotificationsBloc()),
      ],
      child: ProviderScope(child: EGarajeApp()),
    )
  );
}

class EGarajeApp extends StatelessWidget {
  const EGarajeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
    );
  }
}
