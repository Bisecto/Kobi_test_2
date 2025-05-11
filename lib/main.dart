import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kobi_test_2/views/app_screens/history_page.dart';
import 'package:kobi_test_2/views/app_screens/merchants_page.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KOBI TEST HISTORY',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
       // fontFamily: 'SF Pro Display',
        scaffoldBackgroundColor: const Color(0xFFF5F8FA),
      ),
      home:
      //BlocProvider(
        //create: (context) => TransactionBloc(),
        //child:
        const MerchantPage(),
     // ),
    );
  }
}