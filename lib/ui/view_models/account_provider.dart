import 'package:al_ameen_employer_app/data/models/api_status.dart';
import 'package:al_ameen_employer_app/data/models/data.dart';
import 'package:al_ameen_employer_app/data/repositories/firebase_repository.dart';
import 'package:al_ameen_employer_app/ui/views/add_details_page/add_details_page.dart';
import 'package:al_ameen_employer_app/utils/shared_preference.dart';
import 'package:al_ameen_employer_app/utils/style.dart';
import 'package:flutter/material.dart';

class AccountProvider extends ChangeNotifier {
  final FirebaseRepositoryImplementation firebase;
  final SharedPreferencesServices sharedPref;

  AccountProvider(this.firebase, this.sharedPref);

  // loading variable
  bool _loading = false;
  bool get loading => _loading;

  // fetch data variable
  List<Data> _getData = [];
  List<Data> get getData => _getData;

  // add details page variable
  bool _onlinePayment = false;
  CategoryType _categoryType = CategoryType.income;
  bool get onlinePayment => _onlinePayment;
  CategoryType get categoryType => _categoryType;
   String? _selectedChair;
  String? get selectedChair => _selectedChair;
  
  String? _menuError;
  String? get menuError => _menuError;
  String? _dropDownValue;
  String? get dropDownValue => _dropDownValue;

  //profile page name
  String? _username;
  String? get username => _username;

  String? _role;
  String? get role => _role;

  // error handle variable
  late String _errorText;
  String get errorText => _errorText;

  // display chair variable
  List<String> _chairs = [];
  List<String> get chairs => _chairs;

  // functions to assign data from  different functions to  respective variables
  setLoading(bool isLoading) {
    _loading = isLoading;
    notifyListeners();
  }

  setAccountDataList(List<Data> data) {
    _getData = data;
  }

  void setHasPaidOnline(bool isEnabled) {
    _onlinePayment = isEnabled;
    notifyListeners();
  }

  void setCategoryType(CategoryType type) {
    _categoryType = type;
    notifyListeners();
  }

  

  setDropDownValue(String? value) {
    _dropDownValue = value;

    notifyListeners();
  }

  void setDropdownMenuError(String? error) {
    _menuError = error;
    notifyListeners();
  }

  void setUsername(String name, String role) {
    _username = name;
    _role = role;
  }

  void setChair(String? selectedEmp) {
    _selectedChair = selectedEmp;
    notifyListeners();
  }

  void setChairsList(List<String> data) {
    data.sort((a, b) {
      int aNumber = int.tryParse(a.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      int bNumber = int.tryParse(b.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      return aNumber.compareTo(bNumber);
    });
    _chairs = data;
  }

  // firebase connection

  void connectFirebase() async {
    await firebase.connect();
    notifyListeners();
  }

  // get data

  Future<void> getAccountsData() async {
    setLoading(true);
    final result = await firebase.getData();
    if (result is Success) {
      setAccountDataList(result.response as List<Data>);
    } else if (result is Failure) {
      _errorText = '';
      _errorText = result.response.toString();
    }
    setLoading(false);
  }

  // add data

  Future<void> addAccountsData(Data dataModel) async {
    await firebase.insert(dataModel);
    notifyListeners();
  }

  // delete data

  Future<void> deleteAccountsData(String id) async {
    await firebase.deleteData(id);
    getAccountsData();
  }

  // get profile username
  Future<void> getUsername() async {
    final name = await sharedPref.checkLoginStatus();
    late String formattedRole;

    if (name != null && name.isNotEmpty) {
      final formattedName = name[0].toCapitalized();
      if (name[0].contains('muees')) {
        formattedRole = 'Developer';
      } else if (name[0].contains('jaleel')) {
        formattedRole = 'Admin';
      } else {
        formattedRole = 'Staff Member';
      }
      setUsername(formattedName, formattedRole);
      notifyListeners();
    }
  }

  // display chairs
  Future<void> displayChairs() async {
    final result = await firebase.getChairs();
    if (result is Success) {
      setChairsList(result.response as List<String>);
    } else if (result is Failure) {
      _errorText = '';
      _errorText = result.response.toString();
    }
    notifyListeners();
  }
}
