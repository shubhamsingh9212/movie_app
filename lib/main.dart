import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:movie_app/app/home/home_binding.dart';
import 'package:movie_app/model/hive_movie_list_model.dart';
import 'package:movie_app/routes/app_pages.dart';
import 'package:movie_app/theme/app_colors.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(MovieListHiveModelAdapter());
  Hive.registerAdapter(ResultHiveModelAdapter());
  Hive.registerAdapter(
    DatesHiveModelAdapter(),
  );
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: AppColors.purple,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: GetMaterialApp(
        initialRoute: Routes.HOME,
        initialBinding: HomeBinding(),
        debugShowCheckedModeBanner: false,
        title: 'My Choice',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: AppColors.black,
          useMaterial3: true,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.purple),
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: AppColors.white,
          ),
        ),
        getPages: AppPages.pages,
      ),
    );
  }
}
