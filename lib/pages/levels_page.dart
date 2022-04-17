import 'package:crossword/services/db.dart';
import 'package:crossword/widgets/level_desc.dart';

import 'package:provider/provider.dart';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'dart:convert';

List<Widget> _levels = [
  // LvlDesc(level: "01"),
  // SizedBox(width: 1),
  // LvlDesc(
  //   level: "01",
  //   isLocked: true,
  // ),
  // SizedBox(width: 1),
  // LvlDesc(level: "01", isLocked: true),
  // SizedBox(height: 1),
  // SizedBox(height: 1),
  // SizedBox(height: 1),
  // SizedBox(height: 1),
  //SizedBox(height: 1),
  // LvlDesc(level: "01", isLocked: true),
  // SizedBox(width: 1),
  // LvlDesc(level: "01", isLocked: true),
  // SizedBox(width: 1),
  // LvlDesc(level: "01", isLocked: true),
];

Future<List<Widget>> _buildLevelIcons(BuildContext context) async {
  _levels.clear();
  final dbService = Provider.of<DbService>(context, listen: false);
  String _levelsDataString =
      await rootBundle.loadString("assets/levels/levels.json");
  final _levelsData = await jsonDecode(_levelsDataString);
  if (!_levelsData.containsKey("level_nums")) {
    print("Error Empty!");
    return [];
  }
  int boxNum = 0;
  int curLevel = await dbService.read("general", "cur_level", Object());
  _levelsData['level_nums'].forEach((element) {
    _levels.add(LvlDesc(
      level: element,
      isLocked: curLevel < boxNum + 1,
    ));

    boxNum += 2;
    if ((boxNum) % 6 == 0) {
      _levels.add(
        SizedBox(
          height: 1,
        ),
      );
      _levels.add(SizedBox(
        height: 1,
      ));
      _levels.add(SizedBox(
        height: 1,
      ));
      _levels.add(SizedBox(
        height: 1,
      ));
      _levels.add(SizedBox(
        height: 1,
      ));

      _levels.add(SizedBox(
        height: 1,
      ));
      _levels.add(SizedBox(height: 1));

      ///boxNum += 3;
    } else
      _levels.add(
        SizedBox(
          width: 1,
        ),
      );
  });
  return _levels;
}

class LevelsPage extends StatelessWidget {
  const LevelsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Levels")),
        body: SafeArea(
            child: InteractiveViewer(
          child: Scaffold(
              body: Column(
            children: [
              Expanded(
                  flex: 1,
                  child: SizedBox(
                    width: 1,
                  )),
              Expanded(
                flex: 4,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_left,
                          size: 50,
                        ),
                        onPressed: () {},
                      ),
                    ),
                    //identical(),
                    Expanded(
                      flex: 3,
                      child: PageView(children: [
                        FutureBuilder(
                            future: _buildLevelIcons(context),
                            builder: (context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData)
                                return GridView.count(
                                  childAspectRatio: 2 / 3,
                                  crossAxisCount: 6,
                                  children: snapshot.data as List<Widget>,
                                );
                              else
                                return Center(
                                    child: CircularProgressIndicator());
                            }),
                      ]),
                    ),
                    Expanded(
                      flex: 1,
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_right,
                          size: 50,
                        ),
                        onPressed: () {},
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                  flex: 1,
                  child: SizedBox(
                    width: 1,
                  )),
            ],
          )),
        )));
  }
}
