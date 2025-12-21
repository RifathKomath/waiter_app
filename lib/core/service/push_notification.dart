// import 'package:easyfycare_clinical_app/app/view/home/home_screen.dart';
// import 'package:easyfycare_clinical_app/app/view/patient_detail/sub_screens/teleconsultation/teleconsulation_navigation_screen.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:permission_handler/permission_handler.dart';
// import '../../app/model/teleconsulation/teleconsultation_response.dart';
// import '../../app/model/teleconsulation/training_response.dart';
// import '../../app/view/patient_detail/patient_detail_screen.dart';
// import '../../app/view/training/sub_screen/training_session_navigation_screen.dart';
// import '../../config.dart';
// import '../../shared/utils/screen_utils.dart';

// class NotificationService {
//   static late FirebaseMessaging _firebaseMessaging;
//   static final FlutterLocalNotificationsPlugin
//   _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

//   // Request notification permission + fetch token
//   static Future init() async {
//     _firebaseMessaging = FirebaseMessaging.instance;

//     await _firebaseMessaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );

//     // Always fetch token at startup
//     final gettoken = await _firebaseMessaging.getToken();
//     fcmNewToken = gettoken ?? "";
//     print("👉 App Start FCM Token: $fcmNewToken");

//     // Listen for token refresh
//     FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
//       fcmNewToken = newToken;
//       print("🔄 Refreshed FCM Token: $fcmNewToken");
//     });
//   }

//   static Future localNotiInit() async {
//     print('User granted permissions');

//     const AndroidInitializationSettings androidInitialize =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//     final InitializationSettings initializationSettings =
//         InitializationSettings(android: androidInitialize);

//     await _flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: onNotificationTap,
//     );

//     // Foreground messages
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       _showLocalNotification(message);
//     });

//     // Background tapped
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       _handleNotificationTap(message);
//     });

//     // Print token again
//     String? token = await _firebaseMessaging.getToken();
//     print("Firebase Token (localNotiInit): $token");
//   }

//   static Future<void> _showLocalNotification(RemoteMessage message) async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//           'high_importance_channel',
//           'High Importance Notifications',
//           importance: Importance.max,
//           priority: Priority.high,
//         );

//     const NotificationDetails platformChannelSpecifics = NotificationDetails(
//       android: androidPlatformChannelSpecifics,
//     );

//     await _flutterLocalNotificationsPlugin.show(
//       0,
//       message.notification?.title ?? '',
//       message.notification?.body ?? '',
//       platformChannelSpecifics,
//     );
//   }

//   static void _handleNotificationTap(RemoteMessage message) {
//     print("Notification tapped: ${message.data}");
//     final data = message.data;
//     if (_isTeleconsultationNotification(data)) {
//       _handleTeleconsultationNotification(data);
//     } else if (_isTrainingNotification(data)) {
//       _handleTrainingNotification(data);
//     } else {
//       Screen.open(HomeScreen());
//     }
//   }

//   static bool _isTeleconsultationNotification(Map<String, dynamic> data) {
//     // Method 1: Check for specific key
//     if (data.containsKey('notificationType') &&
//         data['notificationType'] == 'teleconsultation') {
//       return true;
//     }

//     // Method 4: Try parsing to see if it matches the model structure
//     try {
//       final response = TelecallNotificationResponse.fromJson(data);
//       // Add your validation logic here
//       // For example, check if required fields are not null
//       return true; // Adjust based on your model validation
//     } catch (e) {
//       return false;
//     }
//   }

//   static late TelecallNotificationResponse telecallResponse;

//   static void _handleTeleconsultationNotification(Map<String, dynamic> data) {
//     try {
//       // Parse to your model
//       telecallResponse = TelecallNotificationResponse.fromJson(data);

//       // Navigate immediately (app is already open)
//       Screen.open(TeleconsulationNavigationScreen(data: telecallResponse));
//     } catch (e) {
//       print("Error handling teleconsultation notification: $e");
//       Screen.open(HomeScreen());
//     }
//   }

//   static bool _isTrainingNotification(Map<String, dynamic> data) {
//     // Method 1: Check for specific key
//     if (data.containsKey('notificationType') &&
//         data['notificationType'] == 'trainingSession') {
//       return true;
//     }

//     // Method 4: Try parsing to see if it matches the model structure
//     try {
//       final response = TrainingSessionNotificationResponse.fromJson(data);
//       // Add your validation logic here
//       // For example, check if required fields are not null
//       return true; // Adjust based on your model validation
//     } catch (e) {
//       return false;
//     }
//   }

//   static late TrainingSessionNotificationResponse trianingResponse;

//   static void _handleTrainingNotification(Map<String, dynamic> data) {
//     try {
//       // Parse to your model
//       trianingResponse = TrainingSessionNotificationResponse.fromJson(data);

//       // Navigate immediately (app is already open)
//       Screen.open(TrainingSessionNavigationScreen(data: trianingResponse));
//     } catch (e) {
//       print("Error handling training notification: $e");
//       Screen.open(HomeScreen());
//     }
//   }

//   static Future<void> requestNotificationPermission() async {
//     final PermissionStatus status = await Permission.notification.request();
//     if (status.isGranted) {
//       print("Notification permission granted!");
//     } else {
//       print("Notification permission denied!");
//     }
//   }

//   static void onNotificationTap(NotificationResponse notificationResponse) {
//     print("Local notification tapped: ${notificationResponse.payload}");
//   }

//   static Future showSimpleNotification({
//     required String title,
//     required String body,
//     required String payload,
//   }) async {
//     const AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails(
//           'your_channel_id',
//           'your_channel_name',
//           channelDescription: 'your channel description',
//           importance: Importance.max,
//           priority: Priority.high,
//           ticker: 'ticker',
//         );

//     const NotificationDetails notificationDetails = NotificationDetails(
//       android: androidNotificationDetails,
//     );

//     await _flutterLocalNotificationsPlugin.show(
//       0,
//       title,
//       body,
//       notificationDetails,
//       payload: payload,
//     );
//   }
// }
