import 'package:fl_products/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/services.dart';

class CheckAuthScreen extends StatelessWidget {
  const CheckAuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      body: Center(
        child: FutureBuilder(
            future: authService.readToken(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) return const Text('');

              if (snapshot.data == '') {

              Future.microtask(() {
                Navigator.pushReplacement(
                    context, PageRouteBuilder(
                      pageBuilder: ( _ , __ , ___ ) => const RegisterScreen(),
                      transitionDuration: const Duration(seconds: 1),
                      )
                    );
                  });
              } else {
                Future.microtask(() {
                Navigator.pushReplacement(
                    context, PageRouteBuilder(
                      pageBuilder: ( _ , __ , ___) => const HomeScreen(),
                      transitionDuration: const Duration(seconds: 1),
                      )
                    );
                  });
              }
              return Container();
            }),
      ),
    );
  }
}
