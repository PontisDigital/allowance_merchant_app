import 'package:allowance_merchant/dashboard.dart';
import 'package:allowance_merchant/login_page.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'; import '../firebase_options.dart';

void main() async
{
	WidgetsFlutterBinding.ensureInitialized();
	  await Firebase.initializeApp(
		options: DefaultFirebaseOptions.currentPlatform,
	  );
	FirebaseAuth.instance.setPersistence(Persistence.LOCAL);

	runApp(MyApp());
}

class UserHomeData
{
  final String data;
  UserHomeData({required this.data});
}

class UserHomeDataProvider extends ChangeNotifier {
  UserHomeData _userHomeData = UserHomeData(data: "");

  UserHomeData get userHomeData => _userHomeData;

  void updateHomeData(String newData) {
    _userHomeData = UserHomeData(data: newData);
    notifyListeners();
  }
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			title: 'Allowance Business Portal',
			debugShowCheckedModeBanner: false,
			theme: ThemeData(
			primarySwatch: Colors.blue,
			),
			home: StreamBuilder<User?>(
				stream: FirebaseAuth.instance.authStateChanges(),
				builder: (context, snapshot)
				{
					if (snapshot.connectionState == ConnectionState.waiting)
					{
						return const CircularProgressIndicator();
					}
					else if (snapshot.hasData)
					{
						var email = FirebaseAuth.instance.currentUser!.email;
						return ChangeNotifierProvider(
								create: (context) => UserHomeDataProvider(),
									child: Dashboard(minPosFlow: email == "gtvapes0@gmail.com", isHop: email == "hopcask@gmail.com"),
						);
					}
					else
					{
						return LoginPage();
					}
				},
			),
		);
	}
}

