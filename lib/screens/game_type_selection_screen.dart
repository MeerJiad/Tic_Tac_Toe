import 'package:flutter/material.dart';
import 'package:tic_tac_toe/constants/custom_text_fonts.dart';
import 'package:tic_tac_toe/screens/with_timer_game_screen.dart';
import 'package:tic_tac_toe/screens/without_timer_game_screen.dart';

class GameTypeSelectionScreen extends StatelessWidget {
  const GameTypeSelectionScreen({super.key});

  static const name = '/';

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/tic_tac_toe_logo.png',
                height: screenHeight / 4,
              ),
              Text(
                'Choose Your Preferred One',
                style: CustomTextFonts.coinyGoogleFonts(),
              ),
              SizedBox(height: 8),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () => Navigator.pushReplacementNamed(
                          context,
                          WithTimerGameScreen.name,
                        ),
                        child: Card(
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            //by that we are saying that give the childs full width
                            children: [
                              Expanded(
                                child: Image.asset(
                                  'assets/images/timer_image.png',
                                ),
                              ),
                              Text(
                                'Play With Timer',
                                textAlign: TextAlign.center,
                                style: CustomTextFonts.coinyGoogleFonts(
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                            context,
                            WithoutTimerGameScreen.name,
                          );
                        },
                        child: Card(
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: Image.asset(
                                  'assets/images/crossed_timer_image.png',
                                ),
                              ),
                              Text(
                                'Play Without Timer',
                                textAlign: TextAlign.center,
                                style: CustomTextFonts.coinyGoogleFonts(
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
