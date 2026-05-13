import 'package:flutter/material.dart';
import 'package:tic_tac_toe/screens/game_type_selection_screen.dart';
import 'package:tic_tac_toe/screens/with_timer_game_screen.dart';
import 'package:tic_tac_toe/screens/without_timer_game_screen.dart';

import 'constants/app_colors.dart';

class TicTacToeApp extends StatelessWidget {
  const TicTacToeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tic-Tac-Toe',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.appThemeColor,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accentColor,
            padding: EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (BuildContext context) => GameTypeSelectionScreen(),
            );
          case '/without_timer_game_screen':
            return MaterialPageRoute(
              builder: (BuildContext context) => WithoutTimerGameScreen(),
            );
          default :
            return MaterialPageRoute(
              builder: (BuildContext context) => WithTimerGameScreen(),
            );

        }
      },
      initialRoute: '/',
    );
  }
}
