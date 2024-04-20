import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lilac_task/core/constant/theme_bool/bloc/theme_bool_bloc.dart';
import 'package:lilac_task/core/constant/video_index/bloc/video_index_bloc.dart';
import 'package:lilac_task/core/utils/secure.dart';
import 'package:lilac_task/features/home/presentation/bloc/home_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/utils/show_snackbar.dart';
import 'core/utils/theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'firebase_options.dart';
import 'init_dependencies.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await securescreen();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,

  );
  await initDependencies();
  runApp(MultiBlocProvider(providers: [
    BlocProvider(
      create: (_) => serviceLocator<AuthBloc>(),
    ),
    BlocProvider(
      create: (_) => serviceLocator<ThemeBoolBloc>(),
    ),
    BlocProvider(
      create: (_) => serviceLocator<HomeBloc>(),
    ),
    BlocProvider(
      create: (_) => serviceLocator<VideoIndexBloc>(),
    )
  ],
  child: const MyApp()));
}

class MyApp extends StatefulWidget {

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context){

    return BlocBuilder<ThemeBoolBloc,bool>(builder: (context, state) {
     return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Lilac Task App',
        theme:  state?lightTheme:darkTheme,
        // darkTheme: darkTheme,
        home: const MyHomePage(),
      );
    },);

  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  keepLogin() async {
    final SharedPreferences local=await SharedPreferences.getInstance();
    String? userId=local.getString("uid");
    context.read<ThemeBoolBloc>().add(ThemeBoolChange(theme: local.getBool("theme")!));


    if(userId==null){
      Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => const LoginPage(),), (route) => false);
    }
    else{
      context.read<AuthBloc>().add(AuthGetUser(authId: userId));
    }
  }
  addData(){
    Future.delayed(const Duration(seconds: 2)).then((value) =>
        keepLogin());
  }
@override
  void initState() {
  addData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthBloc,AuthState>(builder: (context, state) {
      return  Center(child: Image.asset("assets/lilacLogo.png"));
      }, listener: (context, state) {
        if (state is AuthFailure) {
          showSnackBar(context, state.message.toString());
        } else if (state is AuthSuccess2) {
          Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) =>HomePage(user: state.user) ,), (route) => false);
        }
      },)

    );
  }
}
