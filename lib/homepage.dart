import 'package:flutter/material.dart';
import 'package:tictac/game_logic.dart';
import 'package:tictac/main.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String active_player = 'X';
  bool gameover = false;
  int turn = 0;
  String result = '';
  Game game = Game();
  bool isswitched = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(9, 3, 66, 1),
      body: SafeArea(
          child: MediaQuery.of(context).orientation == Orientation.portrait
              ? Column(
                  children: [
                    SwitchListTile.adaptive(
                      value: isswitched,
                      onChanged: (newval) => setState(() {
                        isswitched = newval;
                      }),
                      title: const Text(
                        'Turn on, off 2 player',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Text(
                      gameover ? '' : '$active_player turn'.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 52,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      result,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    XO(),
                    rebetition(),
                  ],
                )
              : Row(
                  children: [
                    Column(children: [...upper(), rebetition()]),
                    XO()
                  ],
                )),
    );
  }

  ElevatedButton rebetition() {
    return ElevatedButton.icon(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
                const Color.fromRGBO(48, 70, 156, 1))),
        onPressed: () {
          setState(() {
            Player.playerO = [];
            Player.playerX = [];
            active_player = 'X';
            gameover = false;
            turn = 0;
            result = '';
          });
        },
        icon: const Icon(Icons.replay),
        label: const Text(
          'Rebeat The Game',
          style: TextStyle(color: Colors.white),
        ));
  }

  Expanded XO() {
    return Expanded(
      child: GridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        padding: const EdgeInsets.all(16),
        children: List.generate(
            9,
            (index) => InkWell(
                  borderRadius: BorderRadius.circular(8),
                  overlayColor: MaterialStateProperty.all(
                      const Color.fromRGBO(2, 80, 163, 1)),
                  onTap: gameover
                      ? null
                      : () {
                          _ontap(index);
                        },
                  child: Container(
                    child: Center(
                      child: Text(
                        Player.playerX.contains(index)
                            ? 'X'
                            : Player.playerO.contains(index)
                                ? 'O'
                                : '',
                        style: TextStyle(
                          color: Player.playerX.contains(index)
                              ? Colors.blue
                              : Colors.red,
                          fontSize: 52,
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: const Color.fromRGBO(2, 34, 163, 1)),
                  ),
                )),
      ),
      // child: Container(
      //     padding: const EdgeInsets.all(10),
      //     color: const Color.fromRGBO(18, 16, 69, 1),
      //     child: Column(
      //       children: [
      //         rowqutar(),
      //         const SizedBox(
      //           height: 5,
      //         ),
      //         rowqutar(),
      //         const SizedBox(
      //           height: 5,
      //         ),
      //         rowqutar(),
      //       ],
      //     )),
    );
  }

  List<Widget> upper() {
    return [
      SwitchListTile.adaptive(
        value: isswitched,
        onChanged: (newval) => setState(() {
          isswitched = newval;
        }),
        title: const Text(
          'Turn on, off 2 player',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      Text(
        gameover ? '' : '$active_player turn'.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 52,
        ),
        textAlign: TextAlign.center,
      ),
      Text(
        result,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 28,
        ),
        textAlign: TextAlign.center,
      ),
    ];
  }

  Row rowqutar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        qutar(),
        const SizedBox(
          width: 5,
        ),
        qutar(),
        const SizedBox(
          width: 5,
        ),
        qutar(),
      ],
    );
  }

  Container qutar() {
    return Container(
      margin: const EdgeInsets.all(5),
      width: 100,
      height: 100,
      color: const Color.fromRGBO(13, 56, 224, 1),
    );
  }

  void _ontap(int index) async {
    if (!Player.playerO.contains(index) && !Player.playerX.contains(index)) {
      game.playGame(index, active_player);
      ubdateturn();
    }

    if (!isswitched && !gameover && turn > 9) {
      await game.autoPlay(active_player);
      ubdateturn();
    }
  }

  void ubdateturn() {
    return setState(() {
      active_player = active_player == 'X' ? 'O' : 'X';
      turn++;
      if (turn >= 5) {
        String Wp = game.checkWinner();
        if (Wp != '') {
          result = '$Wp is the winner';
          gameover = true;
        } else if (turn == 9 && !gameover) {
          result = 'It\'s Draw';
        }
      }
    });
  }
}
