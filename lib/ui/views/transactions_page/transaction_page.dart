import 'package:al_ameen_employer_app/data/models/data.dart';
import 'package:al_ameen_employer_app/ui/view_models/account_provider.dart';
import 'package:al_ameen_employer_app/ui/views/transactions_page/components/dashboard_widget.dart';
import 'package:al_ameen_employer_app/ui/views/transactions_page/components/fab_button.dart';
import 'package:al_ameen_employer_app/ui/views/transactions_page/components/logout_alertbox.dart';
import 'package:al_ameen_employer_app/ui/views/transactions_page/components/scrollview_widget.dart';
import 'package:al_ameen_employer_app/utils/locator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class TransactionPage extends StatelessWidget {
  const TransactionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AccountProvider>();
    provider.getUsername();
    return Scaffold(
      key: key,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(2.w, 0.h, 2.w, 0.5.h),
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(provider.username ?? '',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontFamily: 'RobotoCondensed',
                          )),
                      Text(provider.role ?? '',
                          style: TextStyle(
                              fontSize: 10.sp, fontFamily: 'RobotoCondensed'))
                    ]),
                ElevatedButton(
                    onPressed: () {
                      showDialogBox(context);
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                        padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                            vertical: 8.sp, horizontal: 12.sp))),
                    child: Text('Logout',
                        style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.red,
                            fontFamily: 'RobotoCondensed')))
              ]),
              SizedBox(height: 1.h),
              Consumer<AccountProvider>(
                builder: (context, state, child) {
                  int income = 0;
                  int expense = 0;
                  var value = state.getData
                      .where((e) => e.name == provider.username)
                      .toList();
                  for (final result in value) {
                    if (result.date.day == DateTime.now().day &&
                        result.date.month == DateTime.now().month) {
                      if (result.type == "income") {
                        income += int.parse(result.amount);
                      } else {
                        expense += int.parse(result.amount);
                      }
                    }
                  }

                  return dashboardContainer(context, income, expense);
                },
              ),
              SizedBox(
                height: 2.5.h,
              ),
              Expanded(
                  child: Consumer<AccountProvider>(
                key: const Key('listview-data'),
                builder: (context, res, _) {
                  final value = res.getData
                      .where((data) => data.name == provider.username)
                      .toList();
                  List<Data> data = [];
                  if (value.isNotEmpty) {
                    DateTime currentDate = DateTime.now();
                    data = value.where((element) {
                      final res = element.date.day == currentDate.day &&
                          element.date.month == currentDate.month;
                      return res == true;
                    }).toList();
                  }
                  if (res.loading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        key: Key('transactions-progress loader'),
                      ),
                    );
                  } else if (data.isNotEmpty) {
                    return ScrollViewBuilder(data: data);
                  } else {
                    return Center(
                      child: Text(
                        'No Data Today',
                        style: TextStyle(
                            fontFamily: 'RobotoCondensed', fontSize: 10.sp),
                      ),
                    );
                  }
                },
              )),
            ],
          ),
        ),
      ),
      floatingActionButton:
          // FloatingActionButton(onPressed: (){}),
          FabWidget(sharedPreferencesServices),
    );
  }
}
