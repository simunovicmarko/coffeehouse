import 'package:coffeehouse/auth_service.dart';
import 'package:coffeehouse/chatList.dart';
import 'package:coffeehouse/login.dart';
import 'package:coffeehouse/navbar.dart';
import 'package:coffeehouse/post_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MojApp());
}

class MojApp extends StatefulWidget {
  const MojApp({Key? key, this.inputWidget}) : super(key: key);

  final Widget? inputWidget;

  @override
  State<MojApp> createState() => _MojAppState();
}

class _MojAppState extends State<MojApp> {
  final Color bgColor = const Color(0xFFDB8A74);

  int pageIndex = 2;

  Widget displayWidget = const PostList();

  // final Color bgColor = Colors.red[200];
  String title = "CoffeeHouse";

  @override
  Widget build(BuildContext context) {
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
                backgroundColor: const Color(0xFFB14D32),
                actions: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: IconButton(
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                        },
                        icon: const Icon(
                          Icons.logout,
                          size: 40,
                        )),
                  )
                ],
              ),
              body: Center(child: AuthenticationWrapper(widget: displayWidget)),
              bottomNavigationBar: NavBar(
                setWidget: (widget) {
                  setState(() {
                    displayWidget = widget;
                  });
                },
              ),
              backgroundColor: bgColor)),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({Key? key, required this.widget})
      : super(key: key);

  // final int index;
  final Widget widget;
  @override
  Widget build(BuildContext context) {
    final firebaseuser = context.watch<User?>();
    if (firebaseuser != null) {
      // return widget;
      return widget;
    }
    return const Login();
  }
}
