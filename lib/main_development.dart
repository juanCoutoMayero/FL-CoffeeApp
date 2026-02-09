import 'package:coffee_app/app/app.dart';
import 'package:coffee_app/bootstrap.dart';

import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(CoffeeModelAdapter());
  final coffeeBox = await Hive.openBox<CoffeeModel>('coffee_box');

  final coffeeRepository = CoffeeRepository(
    remoteDataSource: CoffeeRemoteDataSource(),
    localDataSource: CoffeeLocalDataSource(coffeeBox: coffeeBox),
  );

  await bootstrap(() => App(coffeeRepository: coffeeRepository));
}
