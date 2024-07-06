import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cryptafri/screens/admin/AddMessageScreen.dart';
import 'package:cryptafri/screens/admin/distributionScreen.dart';
import 'package:cryptafri/screens/forms/Invest_formScreen.dart';
import 'package:cryptafri/screens/InvestissementScreen.dart';
import 'package:cryptafri/screens/forms/Retrait_formScreen.dart';
import 'package:cryptafri/screens/Splash/Splash_screen_info.dart';
import 'package:cryptafri/screens/Splash/Splash_screen_info2.dart';
import 'package:cryptafri/screens/Splash/Splash_screen_invest.dart';
import 'package:cryptafri/screens/Splash/Splash_screen_retrait.dart';
import 'package:cryptafri/screens/Splash/Splash_screen_validerInvest.dart';
import 'package:cryptafri/screens/ViewMessageScreen.dart';
import 'package:cryptafri/screens/services/firebase_api.dart';
import 'package:cryptafri/screens/admin/transactionsScreen.dart';
import 'package:cryptafri/screens/services/fonctions.utiles.dart';
import 'package:firebase_admin/firebase_admin.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cryptafri/screens/forms/AddProductScreen.dart';
import 'package:cryptafri/screens/Auth/ForgotScreen.dart';
import 'package:cryptafri/screens/SellsScreen.dart';
import 'package:cryptafri/screens/home/HomeScreen.dart';
import 'package:cryptafri/screens/onboarding_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:url_launcher/url_launcher.dart';
import 'screens/forms/ProductPage.dart';
import 'screens/Splash_screen.dart';
import 'screens/SearchPage.dart';
import 'screens/InfosScreen.dart';
import 'screens/Auth/sign-in_screen.dart';
import 'screens/Auth/sign-up_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseApi().initNotifications();
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("contenuuuuuuuuuuuuuu : " + message.data['link']);
    if (getUserEmail() == InfosPage.email) {
      // launchUrl(Uri.parse(message.data['link']),
      //     mode: LaunchMode.externalApplication);
    }
  });
  await initNotifications(); // Fonction que j'ai ajoutée
  try {
    await AwesomeNotifications().initialize(
        null, // Default icon
        [
          NotificationChannel(
              channelKey: 'basic_channel',
              channelName: 'Basic notifications',
              playSound: true,
              onlyAlertOnce: true,
              channelDescription: 'Notification channel for basic tests',
              importance: NotificationImportance.High,
              defaultPrivacy: NotificationPrivacy.Private,
              defaultColor: Color(0xFF9D50DD),
              ledColor: Colors.white)
        ]);
  } on Exception catch (e) {
    print("\n\n CA NA PAS MARCHE \n");
  }
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    showNotification();
    sendLocalNotification(
        1,
        "NOUVELLE ACTION SUR CRYPTAFRI",
        "VERIFIEZ CE QU'IL SE PASSE SUR CRYPTAFRI SUR CRYPTAFRI",
        ""); // Fonction que j'ai ajoutée
  });
  runApp(const MainApp());
}

void showNotification() {
  AwesomeNotifications().createNotification(
      content: NotificationContent(
    id: 10,
    channelKey: 'basic_channel',
    title: 'NOUVELLE ACTION SUR CRYPTAFRI',
    body: 'UN CLIENT A EFFECTUE UNE NOUVELLE ACTION SUR CRYPTAFRI',
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CategoryModel(),
      child: MaterialApp(
        title: "Cryptafri",
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
          useMaterial3: true,
        ),
        routes: {
          Splash_screen.routeName: (context) => const Splash_screen(),
          Splash_screen_info.routeName: (context) => const Splash_screen_info(),
          Splash_screen_valider_invest.routeName: (context) =>
              const Splash_screen_valider_invest(),
          Splash_screen_info2.routeName: (context) =>
              const Splash_screen_info2(),
          OnboardingScreen.routeName: (context) => const OnboardingScreen(),
          SignInScreen.routeName: (context) => const SignInScreen(),
          SignUpScreen.routeName: (context) => const SignUpScreen(),
          ProductPage.routeName: (context) => const ProductPage(),
          SellsScreen.routeName: (context) => SellsScreen(),
          AddProductScreen.routeName: (context) => const AddProductScreen(),
          InfosPage.routeName: (context) => InfosPage(),
          InvestissementScreen.routeName: (context) =>
              const InvestissementScreen(),
          ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
          RetraitFormScreen.routeName: (context) => const RetraitFormScreen(),
          Splash_screen_retrait.routeName: (context) => Splash_screen_retrait(),
          Splash_screen_invest.routeName: (context) => Splash_screen_invest(),
          InvestFormScreen.routeName: (context) => InvestFormScreen(),
          TransactionsPage.routeName: (context) => TransactionsPage(),
          SendMessagePage.routeName: (context) => SendMessagePage(),
          MessageFeedPage.routeName: (context) => MessageFeedPage(),
          DistributionPage.routeName: (context) => DistributionPage(),
        },
        initialRoute: Splash_screen.routeName,
      ),
    );
  }
}

// Créer une instance du plugin de notification locale
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Initialiser le plugin avec des paramètres spécifiques pour Android
Future<void> initNotifications() async {
  // Créer un objet de paramètres d'initialisation pour Android
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');

  // Initialiser le plugin avec les paramètres d'initialisation pour Android
  await flutterLocalNotificationsPlugin.initialize(
    InitializationSettings(android: initializationSettingsAndroid),
  );
}

// Créer une fonction qui peut envoyer une notification locale à l'utilisateur
Future<void> sendLocalNotification(
    int id, String title, String body, String? payload) async {
  // Créer un objet de détails de notification pour Android
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'your_channel_id',
    'your_channel_name',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: false,
  );

  // Envoyer la notification locale en utilisant le plugin
  await flutterLocalNotificationsPlugin.show(id, title, body,
      NotificationDetails(android: androidPlatformChannelSpecifics),
      payload: payload);
}
