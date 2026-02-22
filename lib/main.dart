import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pretty_chopper_logger/pretty_chopper_logger.dart';
import 'package:provider/provider.dart';

import 'constants.dart';
import 'controllers/menu_app_controller.dart';
import 'core/custom_scroll.dart';
import 'core/loading/global_loader_widget.dart';
import 'core/notification/notification_service.dart';
import 'core/router/app_routes.dart';
import 'features/customers/provider/customer_notifier.dart';
import 'features/customers/provider/file_uploader_notifier.dart';
import 'features/equipments/data/api_service.dart';
import 'features/equipments/ui/providers/repository_provider.dart';
import 'network/api_constants.dart';
import 'network/auth_iterceptor.dart';
import 'network/result_converter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MenuAppController(),
        ),
        ChangeNotifierProvider(
          create: (context) => GlobalLoadingProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => NotificationProvider(AppRoutes.rootNavigatorKey),
        ),
        Provider<ChopperClient>(
          create: (_) => ChopperClient(
            baseUrl: Uri.parse(ApiConstants.baseUrl),
            services: [
              ApiService.create(), // Sizning generatsiya qilingan servisingiz
            ],
            converter: ResultConverter(), // Kelayotgan JSON-ni modelga o'giradi
            interceptors: [
              AuthInterceptor(),
              PrettyChopperLogger(),
            ],
          ),
        ),
        ProxyProvider<ChopperClient, ApiService>(
          update: (context, client, previous) =>
              client.getService<ApiService>(),
        ),
        ProxyProvider<ApiService, FileUploaderNotifier>(
          update: (context, client, previous) =>previous??FileUploaderNotifier(api:client ) ,
        ),

        ChangeNotifierProxyProvider3<ApiService, GlobalLoadingProvider,
            NotificationProvider, EquipmentProvider>(
          create: (context) => EquipmentProvider(
            api: context.read<ApiService>(),
            loader: context.read<GlobalLoadingProvider>(),
            notify: context.read<NotificationProvider>(),
          ),
          update: (context, api, loader, notify, previous) =>
              previous ??
              EquipmentProvider(api: api, loader: loader, notify: notify),
        ),
        ChangeNotifierProxyProvider3<ApiService, GlobalLoadingProvider,
            NotificationProvider, CustomerNotifierProvider>(
          create: (context) => CustomerNotifierProvider(
            api: context.read<ApiService>(),
            loader: context.read<GlobalLoadingProvider>(),
            notify: context.read<NotificationProvider>(),
          ),
          update: (context, api, loader, notify, previous) =>
              previous ??
              CustomerNotifierProvider(
                  api: api, loader: loader, notify: notify),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // final rootNavigatorKeyProvider = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        scrollBehavior: CustomScrollBehavior(),
        debugShowCheckedModeBanner: false,
        title: 'Flutter Admin Panel',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: bgColor,
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
              .apply(bodyColor: Colors.white),
          canvasColor: secondaryColor,
        ),
        routerConfig: AppRoutes.goRouter,
        builder: (context, child) {
          return GlobalLoader(
            child: child!,
          );
        });
  }
}
