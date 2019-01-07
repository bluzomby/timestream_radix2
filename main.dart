import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  tick();
  runApp(new MyApp());
}

final timeStreamController = StreamController<int>();
final timeStream = timeStreamController.stream;
bool isRadix10 = false;

void tick() async {
  for (int i = 0; i < 1000000; i++) {
    await Future.delayed(const Duration(milliseconds: 1),
        () => timeStreamController.add(DateTime.now().millisecondsSinceEpoch));
  }
}

Stream<String> timeInBinary() => timeStream.map((int x) => x.toRadixString(2));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Time Stream'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isRadix10 = false;

  @override
  build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Current Time:',
            ),
            StreamBuilder(
                stream: _isRadix10 ? timeStream : timeInBinary(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) =>
                        Text(
                          '${snapshot.data}',
                          style: Theme.of(context).textTheme.body2,
                        )),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          setState(() {
            _isRadix10 = !_isRadix10;
          });
        },
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
    );
  }
}
