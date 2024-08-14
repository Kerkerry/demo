import 'package:demo/core/services/injection_container.dart';
import 'package:demo/src/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:demo/src/authentication/presentation/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// https://mockapi.io/projects -->For server data testing very important

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthenticationCubit>(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bloc demo',
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
