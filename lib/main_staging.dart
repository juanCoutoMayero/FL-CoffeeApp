import 'package:coffee_app/app/app.dart';
import 'package:coffee_app/bootstrap.dart';

import 'package:coffee_data_sources/coffee_data_sources.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:monitoring_repository/monitoring_repository.dart';
import 'package:path_provider/path_provider.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();

  final analyticsService = FirebaseAnalyticsService();
  final crashlyticsService = FirebaseCrashlyticsService();

  Hive.registerAdapter(CoffeeModelAdapter());
  final coffeeBox = await Hive.openBox<CoffeeModel>('coffee_box');

  final directory = await getApplicationDocumentsDirectory();

  final localDataSource = CoffeeLocalDataSource(
    coffeeBox: coffeeBox,
    storagePath: directory.path,
  );

  final remoteDataSource = CoffeeRemoteDataSource();

  final coffeeRepository = CoffeeRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );

  await bootstrap(
    () => App(
      coffeeRepository: coffeeRepository,
      analyticsService: analyticsService,
      crashlyticsService: crashlyticsService,
    ),
    crashlytics: crashlyticsService,
  );
}
