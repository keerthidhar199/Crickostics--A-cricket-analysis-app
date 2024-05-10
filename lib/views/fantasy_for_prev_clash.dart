import 'package:flutter/material.dart';
import 'package:datascrap/globals.dart' as globals;

class FantasyAnalysis extends StatelessWidget {
  final fantasydata;
  final e;
  final Color1;
  final previous_clashes;

  const FantasyAnalysis(
      {Key? key, this.fantasydata, this.e, this.Color1, this.previous_clashes})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List teamsplit = e.toString().split('_')[1].split('vs');
    String vs = teamsplit[0] + ' vs ' + teamsplit[1];
    String rootLogo =
        'https://img1.hscicdn.com/image/upload/f_auto,t_ds_square_w_80/lsci';
    print(previous_clashes);
    return Scaffold(
      backgroundColor: const Color(0xff2B2B28),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Fantasy Analysis',
            style: TextStyle(
              fontFamily: 'Cocosharp',
              fontSize: 20.0,
              color: Colors.black,
            )),
        backgroundColor: const Color(0xffFFB72B),
        leading: IconButton(
            color: Colors.black,
            icon: const Icon(Icons.keyboard_arrow_left),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          ExpansionTile(
            title: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                const CircleAvatar(
                  radius: 40.0,
                ),
                Text(
                  'On Pitch',
                  style: globals.Litsanswhite,
                )
              ],
            ),
            children: fantasydata[e].map<Widget>((eachteam) {
              return Column(
                children: [
                  Text(
                    teamsplit[fantasydata[e].toList().indexOf(eachteam)],
                    style: globals.cocosharp,
                  ), //Team1 and team2  title
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            gradient: LinearGradient(
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              colors: [
                                Color1.withOpacity(0.55),
                                Color1.withOpacity(0.8),
                              ],
                            )),
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  border:
                                      Border.all(width: 1, color: Colors.white),
                                  gradient: LinearGradient(
                                    colors: [
                                      Color1.withOpacity(0.5),
                                      Color1,
                                    ],
                                  )),
                              child: Text(
                                'Your Selection',
                                style: globals.cocosharp,
                              ),
                            ),
                            for (var as in eachteam.keys)
                              (as.toString() == 'Batting' ||
                                      as.toString() == 'Bowling')
                                  ? Column(
                                      children: [
                                        Container(
                                            decoration: BoxDecoration(
                                              color: Color1,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Image.asset(
                                              'logos/${as.toString().toLowerCase()}.png',
                                              color: Colors.white,
                                              width: 30,
                                              height: 30,
                                            ) //Category of the player
                                            ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    3,
                                                child: Text(
                                                  'Player',
                                                  style: globals.Litsans,
                                                ),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    3,
                                                child: Text(
                                                  as.toString() == 'Batting'
                                                      ? 'Runs'
                                                      : 'Wickets',
                                                  style: globals.Litsans,
                                                ),
                                              ),
                                              Text(
                                                as.toString() == 'Batting'
                                                    ? 'Strike Rate'
                                                    : 'Economy',
                                                style: globals.Litsans,
                                              ),
                                            ],
                                          ),
                                        ),
                                        for (var player in eachteam[as])
                                          Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              3,
                                                      child: Text(
                                                        player
                                                            .toString()
                                                            .split(' ')
                                                            .where((element) =>
                                                                element.startsWith(
                                                                    RegExp(
                                                                        r'[A-Z]')))
                                                            .join(' '),
                                                        style: globals.Litsans,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              3,
                                                      child: Text(
                                                        player
                                                            .toString()
                                                            .split(' ')
                                                            .where((element) =>
                                                                element.startsWith(
                                                                    RegExp(
                                                                        r'[0-9]')))
                                                            .first
                                                            .trim(),
                                                        style: globals.Litsans,
                                                      ),
                                                    ),
                                                    Text(
                                                      player
                                                          .toString()
                                                          .split(' ')
                                                          .where((element) =>
                                                              element.startsWith(
                                                                  RegExp(
                                                                      r'[0-9]')))
                                                          .last,
                                                      style: globals.Litsans,
                                                    )
                                                  ],
                                                ),
                                              ), //Each player and their stats
                                            ],
                                          )
                                      ],
                                    )
                                  : as.toString() == 'Partnerships'
                                      ? Column(
                                          children: [
                                            Container(
                                                decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Image.asset(
                                                  'logos/${as
                                                          .toString()
                                                          .toLowerCase()}.png',
                                                  color: Color1,
                                                  width: 30,
                                                  height: 30,
                                                ) //Category of the player
                                                ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            1.5,
                                                    child: Text(
                                                      'Players',
                                                      style: globals.Litsans,
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Text(
                                                      'Runs',
                                                      style: globals.Litsans,
                                                    ),
                                                  ),
                                                  //Each player and their stats
                                                ],
                                              ),
                                            ),
                                            for (int i = 0;
                                                i < eachteam[as].length;
                                                i += 2)
                                              Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              1.5,
                                                          child: Text(
                                                            '${eachteam[as][i]}, ${eachteam[as]
                                                                        [i + 1]
                                                                    .toString()
                                                                    .split(
                                                                        '&')[0]}',
                                                            //  + player.toString().split('&')[1][0],

                                                            style:
                                                                globals.Litsans,
                                                          ),
                                                        ),
                                                        // Text(eachteam[as].toString()),
                                                        Container(
                                                          child: Text(
                                                            eachteam[as][i + 1]
                                                                .toString()
                                                                .split('&')[1],
                                                            style:
                                                                globals.Litsans,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                          ],
                                        )
                                      : Container()
                          ],
                        ),
                      ),
                    ),
                  ), //Selected players and their data both team1 and team2
                ],
              );
            }).toList(),
          ),
          ExpansionTile(
              title: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  const CircleAvatar(
                    radius: 40.0,
                  ),
                  Text(
                    'Head to\n  Head',
                    softWrap: true,
                    style: globals.Litsanswhite,
                  )
                ],
              ),
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: [
                              Color1.withOpacity(0.55),
                              Color1.withOpacity(0.8),
                            ],
                          )),
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                border:
                                    Border.all(width: 1, color: Colors.white),
                                gradient: LinearGradient(
                                  colors: [
                                    Color1.withOpacity(0.5),
                                    Color1,
                                  ],
                                )),
                            child: Text(
                              'Your Selection',
                              style: globals.cocosharp,
                            ),
                          ),
                          for (var as in previous_clashes['headtohead'][0].keys)
                            (as.toString() == 'Batting' ||
                                    as.toString() == 'Bowling')
                                ? Column(
                                    children: [
                                      Container(
                                          decoration: BoxDecoration(
                                            color: Color1,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Image.asset(
                                            'logos/${as.toString().toLowerCase()}.png',
                                            color: Colors.white,
                                            width: 30,
                                            height: 30,
                                          ) //Category of the player
                                          ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3,
                                              child: Text(
                                                'Player',
                                                style: globals.Litsans,
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3,
                                              child: Text(
                                                as.toString() == 'Batting'
                                                    ? 'Runs'
                                                    : 'Wickets',
                                                style: globals.Litsans,
                                              ),
                                            ),
                                            Text(
                                              as.toString() == 'Batting'
                                                  ? 'Strike Rate'
                                                  : 'Economy',
                                              style: globals.Litsans,
                                            ),
                                          ],
                                        ),
                                      ),
                                      for (var player
                                          in previous_clashes['headtohead'][0]
                                              [as])
                                        Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            3,
                                                    child: Text(
                                                      player
                                                          .toString()
                                                          .split(' ')
                                                          .where((element) =>
                                                              element.startsWith(
                                                                  RegExp(
                                                                      r'[A-Z]')))
                                                          .join(' '),
                                                      style: globals.Litsans,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            3,
                                                    child: Text(
                                                      player
                                                          .toString()
                                                          .split(' ')
                                                          .where((element) =>
                                                              element.startsWith(
                                                                  RegExp(
                                                                      r'[0-9]')))
                                                          .first
                                                          .trim(),
                                                      style: globals.Litsans,
                                                    ),
                                                  ),
                                                  Text(
                                                    player
                                                        .toString()
                                                        .split(' ')
                                                        .where((element) =>
                                                            element.startsWith(
                                                                RegExp(
                                                                    r'[0-9]')))
                                                        .last,
                                                    style: globals.Litsans,
                                                  )
                                                ],
                                              ),
                                            ), //Each player and their stats
                                          ],
                                        )
                                    ],
                                  )
                                : as.toString() == 'Partnerships'
                                    ? Column(
                                        children: [
                                          Container(
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Image.asset(
                                                'logos/${as
                                                        .toString()
                                                        .toLowerCase()}.png',
                                                color: Color1,
                                                width: 30,
                                                height: 30,
                                              ) //Category of the player
                                              ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      1.5,
                                                  child: Text(
                                                    'Players',
                                                    style: globals.Litsans,
                                                  ),
                                                ),
                                                Container(
                                                  child: Text(
                                                    'Runs',
                                                    style: globals.Litsans,
                                                  ),
                                                ),
                                                //Each player and their stats
                                              ],
                                            ),
                                          ),
                                          for (int i = 0;
                                              i <
                                                  previous_clashes['headtohead']
                                                          [0][as]
                                                      .length;
                                              i += 2)
                                            Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            1.5,
                                                        child: Text(
                                                          '${previous_clashes[
                                                                          'headtohead']
                                                                      [as][i]}, ${previous_clashes[
                                                                          'headtohead']
                                                                      [
                                                                      as][i + 1]
                                                                  .toString()
                                                                  .split(
                                                                      '&')[0]}',
                                                          //  + player.toString().split('&')[1][0],

                                                          style:
                                                              globals.Litsans,
                                                        ),
                                                      ),
                                                      // Text(eachteam[as].toString()),
                                                      Container(
                                                        child: Text(
                                                          previous_clashes[
                                                                      'headtohead']
                                                                  [as][i + 1]
                                                              .toString()
                                                              .split('&')[1],
                                                          style:
                                                              globals.Litsans,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                        ],
                                      )
                                    : Container()
                        ],
                      ),
                    ),
                  ),
                ), //Selected players and their data both team1 and team2

                ...previous_clashes['headtohead'][0]['Batting']
                    .map<Widget>((e) => Text(e.toString()))
                    .toList(),
                ...previous_clashes['headtohead'][0]['Bowling']
                    .map<Widget>((e) => Text(e.toString()))
                    .toList(),
                ...previous_clashes['headtohead'][0]['Partnerships']
                    .map<Widget>((e) => Text(e.toString()))
                    .toList()
              ])
        ]),
      ),
    );
  }
}
