

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ir_mobile_app/app/routes/app_pages.dart';
import 'package:ir_mobile_app/config/network_service_config/network_service_config.dart';
import 'package:ir_mobile_app/config/theme/theme.dart';
import 'package:ir_mobile_app/services/cached_service/shared_pref_service.dart';
import 'package:ir_mobile_app/widgets/dio_interceptor/src/ui/views/fancy_dio_inspector_view.dart';
import 'package:ir_mobile_app/widgets/moveable_widget.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefService.init();
  NetworkServiceConfig.initNetworkService();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'IR Search Engine',
      theme: darkTheme,
      themeMode: ThemeMode.dark,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.fadeIn,
      // Disable system font scaling — same as gym_mobile_app
         builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.noScaling,
              boldText: false,
            ),
            child: Directionality(
              textDirection:.ltr,
              child: Stack(
                children: [
                  ?child,
                  MoveableWidget(
                    child: FloatingActionButton(
                      onPressed: () => Get.to(const FancyDioInspectorView()),
                      child: const Icon(Icons.network_cell),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
    );
  }
}
