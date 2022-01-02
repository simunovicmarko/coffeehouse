import 'package:coffeehouse/auth_service.dart';
import 'package:coffeehouse/chat.dart';
import 'package:coffeehouse/login.dart';
import 'package:coffeehouse/navbar.dart';
import 'package:coffeehouse/post_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'post.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MojApp());
}

class MojApp extends StatefulWidget {
  const MojApp({Key? key}) : super(key: key);

  @override
  State<MojApp> createState() => _MojAppState();
}

class _MojAppState extends State<MojApp> {
  final Color bgColor = const Color(0xFFDB8A74);

  // final Color bgColor = Colors.red[200];
  String title = "CoffeeHouse";

  @override
  Widget build(BuildContext) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(FirebaseAuth.instance),
        ),
        StreamProvider(
            create: (context) => context.read<AuthService>().authStateChanges,
            initialData: null)
      ],
      child: MaterialApp(
          home: Scaffold(
              appBar: AppBar(
                title: Text(title),
                centerTitle: true,
              ),
              body: const Center(child: AuthenticationWrapper()),
              bottomNavigationBar: const NavBar(),
              backgroundColor: bgColor)),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseuser = context.watch<User?>();
    if (firebaseuser != null) {
      // firebaseuser.updateDisplayName("User1");
      return const Chat();
    }
    return const Login();
  }
}
