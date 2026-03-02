import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:taphoa/core/network/dio_client.dart';
import 'package:taphoa/core/theme/app_colors.dart';
import 'package:taphoa/data/logic/chucvu_logic.dart';
import 'package:taphoa/data/repostories/account_repositories.dart';
import 'package:taphoa/data/repostories/auth_repositories.dart';
import 'package:taphoa/data/repostories/chucvu_repositories.dart';
import 'package:taphoa/data/repostories/hanghoa_repositories.dart';
import 'package:taphoa/data/repostories/khuyenmai_repositories.dart';
import 'package:taphoa/data/repostories/nhanvien_repositories.dart';
import 'package:taphoa/data/repostories/nhaphang_repositories.dart';
import 'package:taphoa/features/account/logic/account_logic.dart';
import 'package:taphoa/features/admin/hanghoa/logic/hanghoa_logic.dart';
import 'package:taphoa/features/admin/khuyenmai/logic/khuyenmai_logic.dart';
import 'package:taphoa/features/admin/nhanvien/logic/NhanVienLogic.dart';
import 'package:taphoa/features/admin/nhaphang/logic/nhaphang_logic.dart';
import 'package:taphoa/features/auth/logic/auth_logic.dart';
import 'package:taphoa/routers/app_router.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  final dioClient = DioClient();

  final authRepository = AuthRepository(dioClient.dio);
  final accountRepo = AccountRepository(dioClient.dio);
  final khuyenmaiRepo = KhuyenMaiRepository(dioClient.dio);
  final hanghoaRepo = HangHoaRepository(dioClient.dio);
  final nhanvienRepo = NhanVienRepository(dioClient.dio);
  final chucvuRepo = ChucVuRepository(dioClient.dio);
  final nhaphangRepo = NhapHangRepository(dioClient.dio);
  final authLogic = AuthLogic(authRepository);
  await authLogic.loadSavedAuth();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authLogic),
        ChangeNotifierProvider(create: (_) => AccountLogic(accountRepo)),
        ChangeNotifierProvider(create: (_) => KhuyenMaiLogic(khuyenmaiRepo)),
        ChangeNotifierProvider(create: (_) => HangHoaLogic(hanghoaRepo)),
        ChangeNotifierProvider(create: (_) => NhanVienLogic(nhanvienRepo)),
        ChangeNotifierProvider(create: (_) => ChucVuLogic(chucvuRepo)),
        ChangeNotifierProvider(create: (_) => NhapHangLogic(nhaphangRepo)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authLogic = context.read<AuthLogic>();
    return MaterialApp.router(
      title: "Tạp hóa",
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('vi', 'VN'), Locale('en', 'US')],
      locale: const Locale('vi', 'VN'),
      routerConfig: AppRouter.createRouter(authLogic),
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.backgroundColor),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {

      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
