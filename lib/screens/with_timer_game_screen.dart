import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tic_tac_toe/constants/app_colors.dart';
import 'package:tic_tac_toe/constants/custom_text_fonts.dart';

class WithTimerGameScreen extends StatefulWidget {
  const WithTimerGameScreen({super.key});

  static const name = '/with_timer_game_screen';

  @override
  State<WithTimerGameScreen> createState() => _WithTimerGameScreenState();
}

class _WithTimerGameScreenState extends State<WithTimerGameScreen> {
  final List<String> _userInputXO = ['', '', '', '', '', '', '', '', ''];
  List<int> _matchedIndexes = [];
  bool _isPlayerO = true;
  String _resultDeclaration = '';
  int _filledBoxes = 0;
  bool _resultDeclared = false;
  int _playerXScore = 0;
  int _playerOScore = 0;
  int _matchCount = 0;
  Timer? _timer;
  static const int _timerMaxSec = 60;
  int _timerTimeLeft =
      _timerMaxSec; //in the state,if we don't set the maxSec as const,then we can't initialize it in the timeLeft.but if we do it const then we need to make it static.
  bool _isTimerActive = false;
  bool _hasGameStarted = false;
  bool _isTimerPaused = false;

  @override
  Widget build(BuildContext context) {
    double screenHeight =
        MediaQuery // if we keep something in the build,it becomes locale variable,so no need to do private.also,context is only available within the build
            .sizeOf(context)
            .height;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //SizedBox(height: 50,),
                SizedBox(
                  height: screenHeight / 6,
                  //it will get 1/6 of the screenHeight.Did this just to make the screen a bit responsive(Obviously not a standard thing)
                  width: double.infinity,
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Text(
                            'Player O',
                            style: CustomTextFonts.coinyGoogleFonts(),
                          ),
                          SizedBox(height: 6),
                          Text(
                            _playerOScore.toString(),
                            style: CustomTextFonts.coinyGoogleFonts(),
                          ),
                        ],
                      ),
                      Spacer(),
                      Column(
                        children: [
                          Text(
                            'Player X',
                            style: CustomTextFonts.coinyGoogleFonts(),
                          ),
                          SizedBox(height: 8),
                          Text(
                            _playerXScore.toString(),
                            style: CustomTextFonts.coinyGoogleFonts(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: screenHeight / 2,
                  width: double.infinity,
                  //it will get 1/2 of the screenHeight
                  child: GridView.builder(
                    shrinkWrap: true,
                    primary: false,
                    //it can't stay under a parent widget,without these.it tries to take infinite space without these.
                    itemCount: 9,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      crossAxisCount: 3,
                    ),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          _gameBoardContainerOnTap(index);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color:
                                _matchedIndexes.contains(
                                  index,
                                ) //it will check that if any values of matchedIndex match with the indexes of gridView.builder,if matches then the matched ones will get accent and others will get secondary color
                                ? AppColors.secondaryColor
                                : AppColors.accentColor,
                          ),
                          child: Text(
                            _userInputXO[index],
                            textAlign: TextAlign.center,
                            style: CustomTextFonts.coinyGoogleFonts(
                              fontSize: 80,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Column(
                  //it will take the remaining space,will go below the screen if it needs.(As it is a scrollable screen)
                  children: [
                    Text(
                      _resultDeclaration,
                      style: CustomTextFonts.coinyGoogleFonts(),
                    ),
                    _isTimerActive ? SizedBox() : SizedBox(height: 24),
                    if (_matchCount == 0 && !_isTimerActive)
                      ElevatedButton(
                        onPressed: () {
                          _isTimerActive = true;
                          _hasGameStarted = true;
                          _isTimerPaused = false;
                          _startTimer();
                          _matchCount++;
                          setState(() {});
                        },
                        child: Transform.translate(
                          offset: Offset(0, -3),
                          //with that we can fit the text wherever we want by x and y axis
                          child: Text(
                            'Start',
                            style: CustomTextFonts.coinyGoogleFonts(
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    else if (_matchCount > 0 && !_isTimerActive)
                      ElevatedButton(
                        onPressed: _playAgainButtonOnTap,
                        child: Transform.translate(
                          offset: Offset(0, -3),
                          //with that we can fit the text wherever we want by x and y axis
                          child: Text(
                            'Play Again',
                            style: CustomTextFonts.coinyGoogleFonts(
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    else if (_isTimerActive)
                      Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                height: 132,
                                width: 132,
                                child: CircularProgressIndicator(
                                  value: _timerTimeLeft / _timerMaxSec,
                                  backgroundColor: AppColors.secondaryColor,
                                  color: Colors.white,
                                  strokeWidth: 8,
                                ),
                              ),
                              Transform.translate(
                                offset: Offset(0, -10),
                                child: Text(
                                  _timerTimeLeft.toString(),
                                  style: CustomTextFonts.coinyGoogleFonts(
                                    fontSize: 64,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          !_isTimerPaused
                              ? ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.secondaryColor,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isTimerPaused = true;
                                      _stopTimer();
                                    });
                                  },
                                  child: Transform.translate(
                                    offset: Offset(0, -3),
                                    child: Text(
                                      'Pause',
                                      style: CustomTextFonts.coinyGoogleFonts(),
                                    ),
                                  ),
                                )
                              : Wrap(
                                  spacing: 16, //horizontally spacing
                                  runSpacing: 16, //vertically spacing
                                  children: [
                                    SizedBox(
                                      width: 250,
                                      height: 60,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            _isTimerPaused = false;
                                          });
                                          _startTimer();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColors.secondaryColor,
                                        ),
                                        child: Text(
                                          'Resume',
                                          style:
                                              CustomTextFonts.coinyGoogleFonts(),
                                        ),
                                      ),
                                    ),

                                    ElevatedButton(
                                      onPressed: () {
                                        _playAgainButtonOnTap();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        fixedSize: Size(250, 60),
                                        backgroundColor:
                                            AppColors.secondaryColor,
                                      ),
                                      child: Text(
                                        'New Game',
                                        style:
                                            CustomTextFonts.coinyGoogleFonts(),
                                      ),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _playAgainButtonOnTap() {
    for (int x = 0; x < 9; x++) {
      _userInputXO[x] = '';
    }
    _matchCount++;
    _timerTimeLeft = _timerMaxSec;
    _startTimer();
    _isTimerActive = true;
    _isTimerPaused = false;
    _isPlayerO = true;
    _resultDeclared = false;
    _resultDeclaration = '';
    _matchedIndexes = [];
    _filledBoxes = 0;
    setState(() {});
  }

  void _gameBoardContainerOnTap(int index) {
    if (_isPlayerO &&
        _userInputXO[index] == '' &&
        !_resultDeclared &&
        _hasGameStarted &&
        !_isTimerPaused) {
      _userInputXO[index] = 'O';
      _filledBoxes++;
      _winnerSelection();
      _isDraw();
      _isPlayerO = !_isPlayerO;
    } else if (_isPlayerO == false &&
        _userInputXO[index] == '' &&
        _resultDeclared == false &&
        !_isTimerPaused &&
        _hasGameStarted) {
      _userInputXO[index] = 'X';
      _filledBoxes++;
      _winnerSelection();
      _isDraw();
      _isPlayerO = !_isPlayerO;
    }
    setState(() {});
  }

  void _winnerSelection() {
    // 3 matched rows winning conditions
    if (_userInputXO[0] != '' &&
        _userInputXO[0] == _userInputXO[1] &&
        _userInputXO[0] == _userInputXO[2]) {
      _matchedIndexes.addAll([0, 1, 2]);
      _resultDeclaration = 'Player ${_userInputXO[0]} Wins';
      _updateScore(_userInputXO[0]);
    } else if (_userInputXO[3] != '' &&
        _userInputXO[3] == _userInputXO[4] &&
        _userInputXO[3] == _userInputXO[5]) {
      _matchedIndexes.addAll([3, 4, 5]);
      _resultDeclaration = 'Player ${_userInputXO[3]} Wins';
      _updateScore(_userInputXO[3]);
    } else if (_userInputXO[6] != '' &&
        _userInputXO[6] == _userInputXO[7] &&
        _userInputXO[6] == _userInputXO[8]) {
      _matchedIndexes.addAll([6, 7, 8]);
      _resultDeclaration = 'Player ${_userInputXO[6]} Wins';
      _updateScore(_userInputXO[6]);
    }
    // 3 matched columns winning conditions
    else if (_userInputXO[0] != '' &&
        _userInputXO[0] == _userInputXO[3] &&
        _userInputXO[0] == _userInputXO[6]) {
      _matchedIndexes.addAll([0, 3, 6]);
      _resultDeclaration = 'Player ${_userInputXO[0]} Wins';
      _updateScore(_userInputXO[0]);
    } else if (_userInputXO[1] != '' &&
        _userInputXO[1] == _userInputXO[4] &&
        _userInputXO[1] == _userInputXO[7]) {
      _matchedIndexes.addAll([1, 4, 7]);
      _resultDeclaration = 'Player ${_userInputXO[1]} Wins';
      _updateScore(_userInputXO[1]);
    } else if (_userInputXO[2] != '' &&
        _userInputXO[2] == _userInputXO[5] &&
        _userInputXO[2] == _userInputXO[8]) {
      _matchedIndexes.addAll([2, 5, 8]);
      _resultDeclaration = 'Player ${_userInputXO[2]} Wins';
      _updateScore(_userInputXO[2]);
    }
    // 2 diagonal winning conditions
    else if (_userInputXO[0] != '' &&
        _userInputXO[0] == _userInputXO[4] &&
        _userInputXO[0] == _userInputXO[8]) {
      _matchedIndexes.addAll([0, 4, 8]);
      _resultDeclaration = 'Player ${_userInputXO[0]} Wins';
      _updateScore(_userInputXO[0]);
    } else if (_userInputXO[2] != '' &&
        _userInputXO[2] == _userInputXO[4] &&
        _userInputXO[2] == _userInputXO[6]) {
      _matchedIndexes.addAll([2, 4, 6]);
      _resultDeclaration = 'Player ${_userInputXO[2]} Wins';
      _updateScore(_userInputXO[2]);
    }
  }

  void _updateScore(String winner) {
    _resultDeclared = true;
    _timer?.cancel();
    _isTimerActive = false;
    if (winner == 'O') {
      _playerOScore++;
    } else {
      _playerXScore++;
    }
  }

  void _isDraw() {
    if (_filledBoxes == 9 && _resultDeclared == false) {
      _resultDeclaration = 'Nobody Wins';
      _resultDeclared = true;
    } else if (_timerTimeLeft <= 0 && _resultDeclared == false) {
      _resultDeclaration = 'Time Over!! Nobody Wins';
      _resultDeclared = true;
    }
  }

  void _startTimer() {
    _timer
        ?.cancel(); //if any previous timers are active.Then,they will be canceled at first.
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        if (_timerTimeLeft > 0) {
          _timerTimeLeft--;
        } else {
          _isDraw();
          _isTimerActive = false;
          _timer?.cancel();
        }
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    _timer
        ?.cancel(); // Timer has no dispose(). So in the final lifecycle of this StatefulWidget, we cancel the timer.
    super.dispose();
  }
}
