import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text('Puissance 4'),
      ),
      body: Puissance4(),
    ),
  ));
}

class Puissance4 extends StatefulWidget {
  @override
  _Puissance4State createState() => _Puissance4State();
}

class _Puissance4State extends State<Puissance4> {
  late List<List<int>> board;
  late int currentPlayer;
  late int winner;
  int rows = 6;
  int cols = 7;

  @override
  void initState() {
    super.initState();
    initBoard();
  }

  void initBoard() {
    board = List.generate(rows, (i) => List.generate(cols, (j) => -1));
    currentPlayer = 0;
    winner = -1;
  }

  void play(int col) {
    if (winner != -1) return;
    for (int i = rows - 1; i >= 0; i--) {
      if (board[i][col] == -1) {
        board[i][col] = currentPlayer;
        checkWinner(i, col);
        setState(() {
          currentPlayer = (currentPlayer + 1) % 2;
        });
        return;
      }
    }
  }

  void checkWinner(int row, int col) {
    int count = 0;

    // Check horizontal
    for (int i = max(0, col - 3); i <= min(cols - 1, col + 3); i++) {
      if (board[row][i] == currentPlayer) {
        count++;
        if (count == 4) {
          winner = currentPlayer;

          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Le joueur ${currentPlayer + 1} a gagné !'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        initBoard();
                        setState(() {
                          currentPlayer = 0;
                        });
                      },
                      child: Text('Rejouer'),
                    ),
                  ],
                );
              });
        }
      } else {
        count = 0;
      }
    }

    // Check vertical
    count = 0;
    for (int i = max(0, row - 3); i <= min(rows - 1, row + 3); i++) {
      if (board[i][col] == currentPlayer) {
        count++;
        if (count == 4) {
          winner = currentPlayer;
          return;
        }
      } else {
        count = 0;
      }
    }

    // Check diagonal top left to bottom right
    count = 0;
    for (int i = -3; i <= 3; i++) {
      int r = row + i;
      int c = col + i;

      if (r < rows && r >= 0 && c < cols && c >= 0) {
        if (board[r][c] == currentPlayer) {
          count++;
          if (count == 4) {
            winner = currentPlayer;
            return;
          }
        } else {
          count = 0;
        }
      }
    }

    // Check diagonal top right to bottom left
    count = 0;
    for (int i = -3; i <= 3; i++) {
      int r = row + i;
      int c = col - i;

      if (r < rows && r >= 0 && c < cols && c >= 0) {
        if (board[r][c] == currentPlayer) {
          count++;
          if (count == 4) {
            winner = currentPlayer;
            return;
          }
        } else {
          count = 0;
        }
      }
    }

    // Check draw
    bool isDraw = true;
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        if (board[i][j] == -1) {
          isDraw = false;
          break;
        }
      }
      if (!isDraw) {
        break;
      }
    }

    if (isDraw) {
      winner = -2; // Draw
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: rows * cols,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cols,
      ),
      itemBuilder: (context, index) {
        int row = (index / cols).floor();
        int col = (index % cols);

        return GestureDetector(
          onLongPress: () {
            // mise en surbrillance de la colonne

            for (int i = rows - 1; i >= 0; i--) {
              if (board[i][col] == -1) {
                board[i][col] = currentPlayer;
                checkWinner(i, col);
                setState(() {
                  currentPlayer = (currentPlayer + 1) % 2;
                });
                return;
              }
            }
          },
          onTap: () {
            play(col);
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              border: Border.all(
                color: Colors.black,
                width: 2,
              ),
            ),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: board[row][col] == -1
                      ? Colors.white
                      : board[row][col] == 0
                          ? Colors.red
                          : Colors.yellow,
                  shape: BoxShape.circle,
                ),
                margin: EdgeInsets.all(5),
              ),
            ),
          ),
        );
      },
    );
  }
}
