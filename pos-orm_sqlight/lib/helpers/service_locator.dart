import 'package:get_it/get_it.dart';
import 'package:points_of_sale/providers/auth.dart';
import 'package:points_of_sale/providers/mainprovider.dart';
import 'package:points_of_sale/services/navigationService.dart';

GetIt getIt = GetIt.instance;
void setupLocator() {
  getIt.registerLazySingleton(() => NavigationService());
  getIt.registerLazySingleton(() => MainProvider());
  getIt.registerLazySingleton(() => Auth());

}
