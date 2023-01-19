import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:page_transition/page_transition.dart';

import 'package:notes_app_bloc/data/blocs/bloc_observer.dart';
import 'package:notes_app_bloc/data/blocs/main_cubit/main_cubit.dart';
import 'package:notes_app_bloc/preferences/cache.dart';
import 'package:notes_app_bloc/screen/pages/login.dart';

import 'data/blocs/notes_cubit/cubit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  CacheHelper.init();
  runApp(const HomeScreen());
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => MainCubit()..createDatabase(),
          ),
          BlocProvider(create: (context) => NotesCubit())
        ],
        child: BlocConsumer<NotesCubit, NotesState>(
          builder: (context, state) => MaterialApp(
              title: 'Notes App',
              theme: ThemeData(primarySwatch: Colors.indigo),
              debugShowCheckedModeBanner: false,
              home: const SplashScreen()),
          listener: (context, state) {},
        ));
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        splash: Column(children: [
          Expanded(child: Image.asset('assets/pencil.png')),
          const Text(
            'Notes App',
            style: TextStyle(
                color: Color(0xffA0C8FF),
                fontStyle: FontStyle.italic,
                fontSize: 30,
                fontWeight: FontWeight.bold),
          )
        ]),
        backgroundColor: const Color(0xffffdbed),
        splashIconSize: 150,
        duration: 2000,
        splashTransition: SplashTransition.fadeTransition,
        pageTransitionType: PageTransitionType.bottomToTop,
        animationDuration: const Duration(seconds: 1),
        nextScreen: LoginScreen());
  }
}
