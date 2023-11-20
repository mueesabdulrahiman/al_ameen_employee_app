import 'package:al_ameen_employer_app/data/repositories/firebase_repository.dart';
import 'package:al_ameen_employer_app/utils/shared_preference.dart';
import 'package:get_it/get_it.dart';

void setupLocator() {
  GetIt.instance.registerSingleton<FirebaseRepositoryImplementation>(
      FirebaseRepositoryImplementation());
  GetIt.instance.registerSingleton<SharedPreferencesServices>(
      SharedPreferencesServices());
}

FirebaseRepositoryImplementation firebaseRepo =
    GetIt.instance<FirebaseRepositoryImplementation>();
SharedPreferencesServices sharedPreferencesServices =
    GetIt.instance<SharedPreferencesServices>();
