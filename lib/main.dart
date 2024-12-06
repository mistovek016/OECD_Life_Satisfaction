import 'package:flutter/material.dart';
import 'package:oecd_app_dir/providers/chat_provider.dart';
import 'package:oecd_app_dir/screens/home.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ChatProvider.initHive();

  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => ChatProvider())],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      title: "OECD App HomeScreen",
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
