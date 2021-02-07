import 'package:flutter/material.dart';
import 'dart:math';
import './custom_icons.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

EdgeInsets widgetPadding = EdgeInsets.all(5.0);

class _MyHomePageState extends State<MyHomePage> {
  double _iconPadding;

  String _playerChoice;
  IconData _playerIcon;
  String _computerChoice;
  IconData _computerIcon;
  String _outcome;
  String _result;
  String _winner;
  String _loser;

  var _logic = {
    'r': {
      'name': 'Rock',
      'beats': {
        'l': 'crushes',
        's': 'crushes'
      },
      "icon": CustomIcons.hand_grab_o
    },
    'p': {
      'name': 'Paper',
      'beats': {
        'r': 'covers',
        'v': 'disproves'
      },
      "icon": CustomIcons.hand_paper_o
    },
    's': {
      'name': 'Scissors',
      'beats': {
        'p': 'cuts',
        'l': 'decapitates'
      },
      "icon": CustomIcons.hand_scissors_o
    },
    'l': {
      'name': 'Lizard',
      'beats': {
        'v': 'poisons',
        'p': 'eats'
      },
      "icon": CustomIcons.hand_lizard_o
    },
    'v': {
      'name': 'Spock',
      'beats': {
        's': 'smashes',
        'r': 'vaporizes'
      },
      "icon": CustomIcons.hand_spock_o
    }
  };

  @override void initState() {
    // TODO: implement initState
    super.initState();

    _reset();
  }

  void _reset() {
    print("RESET");
    setState(() {
      _iconPadding = 0.0;

      _playerChoice = "";
      _playerIcon = CustomIcons.question_circle_o;
      _computerChoice = "";
      _computerIcon = CustomIcons.question_circle_o;
      _outcome = "";
      _result = "";
      _winner = "";
      _loser = "";
    });
  }

  void _chooseWeapon(weapon) {
    setState(() {
      _iconPadding = 10.0;

      final _random = new Random();
      var playerDetails = _logic[weapon];
      _playerChoice = playerDetails["name"];
      _playerIcon = playerDetails["icon"];

      var options = _logic.keys;
      var computer = options.elementAt(_random.nextInt(options.length));
      var computerDetails = _logic[computer];
      _computerChoice = computerDetails["name"];
      _computerIcon = computerDetails["icon"];

      Map playerBeats = Map.from(playerDetails["beats"]);
      Map computerBeats = Map.from(computerDetails["beats"]);

      if (playerBeats.containsKey(computer)) {
        _winner = _playerChoice;
        _loser = _computerChoice;
        _outcome = playerBeats[computer];
        _result = "YOU WIN!";
      } else if (computerBeats.containsKey(weapon)) {
        _winner = _computerChoice;
        _loser = _playerChoice;
        _outcome = computerBeats[weapon];
        _result = "YOU LOSE!";
      } else {
        _winner = "";
        _loser = "";
        _outcome = "";
        _result = "DRAW!";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    List<Widget> _optionButtons = new List.generate(_logic.keys.length, (int i) {
      var key = _logic.keys.elementAt(i);
      var details = _logic[key];

      return RaisedButton(
        child: Icon(details["icon"], color: Colors.white),
        onPressed: () =>  _chooseWeapon(key)
      );
    });

    Orientation orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            tooltip: "Refresh",
            onPressed: _reset,
          )
        ],
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            // Column is also layout widget. It takes a list of children and
            // arranges them vertically. By default, it sizes itself to fit its
            // children horizontally, and tries to be as tall as its parent.
            //
            // Invoke "debug painting" (press "p" in the console, choose the
            // "Toggle Debug Paint" action from the Flutter Inspector in Android
            // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
            // to see the wireframe for each widget.
            //
            // Column has various properties to control how it sizes itself and
            // how it positions its children. Here we use mainAxisAlignment to
            // center the children vertically; the main axis here is the vertical
            // axis because Columns are vertical (the cross axis would be
            // horizontal).
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: widgetPadding,
                    child: Wrap(
                      direction: (orientation == Orientation.portrait) ? Axis.vertical : Axis.horizontal,
                      spacing: 20.0,
                      runSpacing: 20.0,
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              '$_playerChoice',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.display1,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: _iconPadding),
                              child: Icon(_playerIcon, color: Colors.grey[600])
                            )
                          ]
                        ),
                        Text(
                          'vs',
                          textAlign: TextAlign.center,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              '$_computerChoice',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.display1,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: _iconPadding),
                              child: Icon(_computerIcon, color: Colors.grey[600])
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Icon(Icons.arrow_downward, color: Colors.grey[600]),
                  ),
                  Padding(
                    padding: widgetPadding,
                    child: Wrap(
                      direction: (orientation == Orientation.portrait) ? Axis.vertical : Axis.horizontal,
                      spacing: 10.0,
                      runSpacing: 20.0,
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: <Widget>[
                        Text(
                          _winner,
                          style: TextStyle(
                            fontStyle:FontStyle.italic,
                            fontSize: 34
                          )
                        ),
                        Text(
                          "$_outcome",
                          style: Theme.of(context).textTheme.subhead,
                        ),
                        Text(
                          _loser,
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 34
                          )
                        )
                      ]
                    ),
                  ),
                  Padding(
                    padding: widgetPadding,
                    child: Text(
                      '$_result',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.display2,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Wrap(
                  spacing: 10.0,
                  runSpacing: 10.0,
                  alignment: WrapAlignment.center,
                  children: _optionButtons
                )
              ),
            ],
          )
        ),
      ),
    );
  }
}
