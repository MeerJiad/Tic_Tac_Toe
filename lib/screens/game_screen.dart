import 'package:flutter/material.dart';
import 'package:tic_tac_toe/constants/app_colors.dart';
import 'package:tic_tac_toe/constants/custom_text_fonts.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<String> _userInputXO = ['', '', '', '', '', '', '', '', ''];
  var _isFirstPlayerO = true;
  String _resultDeclaration = '';
  int _filledBoxes = 0;
  bool _resultDeclared = false;
  int _playerXScore = 0;
  int _playerOScore = 0;
  int _matchCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appThemeColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              //SizedBox(height: 50,),
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Column(
                      children: [
                        Text(
                          'Player O',
                          style: CustomTextFonts.coinyGoogleFonts(),
                        ),
                        SizedBox(height: 8),
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
              Expanded(
                //unless i wrap it with expanded,column doesn't gives it space as it wants infinity space,with expanded we tell column that give it that much space it needs or space which is equal to flex:2
                flex: 2,
                child: GridView.builder(
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
                          color: AppColors.secondaryColor,
                        ),
                        child: Text(
                          _userInputXO[index],
                          textAlign: TextAlign.center,
                          style: CustomTextFonts.coinyGoogleFonts(fontSize: 80),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Text(
                      _resultDeclaration == '' ? '' : _resultDeclaration,
                      style: CustomTextFonts.coinyGoogleFonts(),
                    ),
                    SizedBox(height: 40),
                    _matchCount > 0
                        ? ElevatedButton(
                            onPressed: () {
                              for (int x = 0; x < 9; x++) {
                                _userInputXO[x] = '';
                              }
                              _isFirstPlayerO = false;
                              _resultDeclared = false;
                              _resultDeclaration = '';
                              setState(() {});
                            },
                            child: Text(
                              'Play Again',
                              style: CustomTextFonts.coinyGoogleFonts(
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _gameBoardContainerOnTap(int index) {
    if (_isFirstPlayerO &&
        _userInputXO[index] == '' &&
        _resultDeclared == false) {
      _userInputXO[index] = 'O';
      _filledBoxes++;
      _winnerSelection();
      _isDraw();
      _isFirstPlayerO = !_isFirstPlayerO;
    } else if (_isFirstPlayerO == false &&
        _userInputXO[index] == '' &&
        _resultDeclared == false) {
      _userInputXO[index] = 'X';
      _filledBoxes++;
      _winnerSelection();
      _isDraw();
      _isFirstPlayerO = !_isFirstPlayerO;
    }
    setState(() {});
  }

  void _winnerSelection() {
    // 3 matched rows winning conditions
    if (_userInputXO[0] != '' &&
        _userInputXO[0] == _userInputXO[1] &&
        _userInputXO[0] == _userInputXO[2]) {
      _resultDeclaration = 'Player ${_userInputXO[0]} Wins';
      _updateScore(_userInputXO[0]);
    } else if (_userInputXO[3] != '' &&
        _userInputXO[3] == _userInputXO[4] &&
        _userInputXO[3] == _userInputXO[5]) {
      _resultDeclaration = 'Player ${_userInputXO[3]} Wins';
      _updateScore(_userInputXO[3]);
    } else if (_userInputXO[6] != '' &&
        _userInputXO[6] == _userInputXO[7] &&
        _userInputXO[6] == _userInputXO[8]) {
      _resultDeclaration = 'Player ${_userInputXO[6]} Wins';
      _updateScore(_userInputXO[6]);
    }
    // 3 matched columns winning conditions
    else if (_userInputXO[0] != '' &&
        _userInputXO[0] == _userInputXO[3] &&
        _userInputXO[0] == _userInputXO[6]) {
      _resultDeclaration = 'Player ${_userInputXO[0]} Wins';
      _updateScore(_userInputXO[0]);
    } else if (_userInputXO[1] != '' &&
        _userInputXO[1] == _userInputXO[4] &&
        _userInputXO[1] == _userInputXO[7]) {
      _resultDeclaration = 'Player ${_userInputXO[1]} Wins';
      _updateScore(_userInputXO[1]);
    } else if (_userInputXO[2] != '' &&
        _userInputXO[2] == _userInputXO[5] &&
        _userInputXO[2] == _userInputXO[8]) {
      _resultDeclaration = 'Player ${_userInputXO[2]} Wins';
      _updateScore(_userInputXO[2]);
    }
    // 2 diagonal winning conditions
    else if (_userInputXO[0] != '' &&
        _userInputXO[0] == _userInputXO[4] &&
        _userInputXO[0] == _userInputXO[8]) {
      _resultDeclaration = 'Player ${_userInputXO[0]} Wins';
      _updateScore(_userInputXO[0]);
    } else if (_userInputXO[2] != '' &&
        _userInputXO[2] == _userInputXO[4] &&
        _userInputXO[2] == _userInputXO[6]) {
      _resultDeclaration = 'Player ${_userInputXO[2]} Wins';
      _updateScore(_userInputXO[2]);
    }
    setState(() {});
  }

  void _updateScore(String winner) {
    if (winner == 'O') {
      _playerOScore++;
      _resultDeclared = true;
      _matchCount++;
    } else {
      _playerXScore++;
      _resultDeclared = true;
      _matchCount++;
    }
  }

  void _isDraw() {
    if (_filledBoxes == 9 && _resultDeclared == false) {
      _resultDeclaration = 'Nobody Wins';
      _resultDeclared = true;
      _matchCount++;
      setState(() {});
    }
  }
}
