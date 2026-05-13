import 'package:flutter/material.dart';
import 'package:tic_tac_toe/constants/app_colors.dart';
import 'package:tic_tac_toe/constants/custom_text_fonts.dart';

class WithoutTimerGameScreen extends StatefulWidget {
  const WithoutTimerGameScreen({super.key});

  static const name = '/without_timer_game_screen';

  @override
  State<WithoutTimerGameScreen> createState() => _WithoutTimerGameScreenState();
}

class _WithoutTimerGameScreenState extends State<WithoutTimerGameScreen> {
  final List<String> _userInputXO = ['', '', '', '', '', '', '', '', ''];
  List<int> _matchedIndexes = [];
  bool _isPlayerO = true;
  String _resultDeclaration = '';
  int _filledBoxes = 0;
  bool _resultDeclared = false;
  int _playerXScore = 0;
  int _playerOScore = 0;
  int _matchCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
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
                      _resultDeclaration,
                      style: CustomTextFonts.coinyGoogleFonts(),
                    ),
                    SizedBox(height: 40),
                    _matchCount > 0
                        ? ElevatedButton(
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

  void _playAgainButtonOnTap() {
    for (int x = 0; x < 9; x++) {
      _userInputXO[x] = '';
    }
    _isPlayerO = true;
    _resultDeclared = false;
    _resultDeclaration = '';
    _matchedIndexes = [];
    _filledBoxes = 0;
    setState(() {});
  }

  void _gameBoardContainerOnTap(int index) {
    if (_isPlayerO && _userInputXO[index] == '' && _resultDeclared == false) {
      _userInputXO[index] = 'O';
      _filledBoxes++;
      _winnerSelection();
      _isDraw();
      _isPlayerO = !_isPlayerO;
    } else if (_isPlayerO == false &&
        _userInputXO[index] == '' &&
        _resultDeclared == false) {
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
    }
  }
}
