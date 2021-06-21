import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() {
  runApp(new MyFirstFlutterApp());
}

class MyFirstFlutterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter demos",
      theme: new ThemeData(
        primaryColor: Colors.white,
      ),
      home: new RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() {
    return new RandomWordsState();
  }
}

class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18.0, color: Colors.blue);
  final _saved = Set<WordPair>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Flutter Demos"),
        actions: <Widget>[
          new IconButton(onPressed: _pushSaved, icon: new Icon(Icons.list)),
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) {
          final tiles = _saved.map((pair) {
            return new ListTile(
              title: new Text(
                pair.asPascalCase,
                style: _biggerFont,
              ),
            );
          });
          final divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          return new Scaffold(
            appBar: new AppBar(
              title: new Text("Saved suggestions"),
            ),
            body: new ListView(
              children: divided,
            ),
          );
        },
      ),
    );
  }

  Widget _buildSuggestions() {
    return new ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        itemBuilder: (context, i) {
          if (i.isOdd) return new Divider(thickness: 2.0);
          final index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    final icon = alreadySaved ? Icons.favorite : Icons.favorite_border;
    return new ListTile(
      title: new Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: new Icon(
        icon,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:english_words/english_words.dart';
// import 'package:flutter/cupertino.dart';
// import 'dart:io';
// import 'dart:async';
// import 'package:path_provider/path_provider.dart';
// import 'dart:convert';
// import 'package:dio/dio.dart';
//
// class FutureBuilderRouter extends StatefulWidget {
//   @override
//   _FutureBuilderRouterState createState() => _FutureBuilderRouterState();
// }
//
// class _FutureBuilderRouterState extends State<FutureBuilderRouter> {
// Dio _dio = Dio();
//
// @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Container(
//       alignment: Alignment.center,
//       child: FutureBuilder(
//         future: _dio.get("https://api.github.com/orgs/flutterchina/repos"),
//           builder: (BuildContext context, AsyncSnapshot snapShot) {
//           if(snapShot.connectionState == ConnectionState.done) {
//             Response response = snapShot.data;
//             if (snapShot.hasError) {
//               return Text(snapShot.error.toString());
//             }
//
//             return ListView(
//               children: response.data.map<Widget>((e) => ListTile(title: Text(e["full_name"]))).toList(),
//             );
//
//           }
//           return CircularProgressIndicator();
//           }
//       ),
//     );
//   }
// }
//
// class HTTPTestRoute extends StatefulWidget {
//   @override
//   _HTTPTestRouteState createState() => _HTTPTestRouteState();
// }
//
// class _HTTPTestRouteState extends State<HTTPTestRoute> {
//   bool _loading = false;
//   String _text = "";
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return ConstrainedBox(
//       constraints: BoxConstraints.expand(),
//       child: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment:MainAxisAlignment.center,
//           children: <Widget>[
//             RaisedButton(
//               color: Colors.blue,
//               child: Text("获取百度首页"),
//
//                 onPressed: _loading ? null : () async {
//                 setState(() {
//                   _loading = true;
//                   _text = "正在请求...";
//                 });
//                 try {
//                   HttpClient httpClient = HttpClient();
//                   HttpClientRequest request = await httpClient.getUrl(Uri.parse("https://www.baidu.com"));
//                   request.headers.add("user-agent", "Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1");
//                   HttpClientResponse response = await request.close();
//                   _text = await response.transform(utf8.decoder).join();
//                   print(response.headers);
//                   httpClient.close();
//                 } catch (e) {
//                   _text = "请求失败：$e";
//                 } finally {
//                   setState(() {
//                     _loading = false;
//                   });
//                 }
//                 }
//             ),
//             Container(
//               width: MediaQuery.of(context).size.width - 50,
//               child: Text(_text.replaceAll(new RegExp(r"\s"), "")),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class FileOperationRoute extends StatefulWidget {
//   FileOperationRoute({Key key}) : super(key: key);
//
//   @override
//   _FileOperationRouteState createState() => _FileOperationRouteState();
// }
//
// class _FileOperationRouteState extends State<FileOperationRoute> {
//   int _counter;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _readCounter().then((int value) {
//       setState(() {
//         _counter = value;
//       });
//     });
//   }
//
//   Future<File> _getLocalFile() async {
//     String dir = (await getApplicationDocumentsDirectory()).path;
//     return File('$dir/counter.txt');
//   }
//
//   Future<int> _readCounter() async {
//     try {
//       File file = await _getLocalFile();
//       String contents = await file.readAsString();
//       return int.parse(contents);
//     } on FileSystemException {
//       return 0;
//     }
//   }
//
//   Future<Null> _incrementCounter() async {
//     setState(() {
//       _counter++;
//     });
//     await (await _getLocalFile()).writeAsString('$_counter');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return new Scaffold(
//       appBar: AppBar(title: Text('文件操作')),
//       body: Center(
//         child: Text("点击了 $_counter 次"),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }
//
// void main() => runApp(new MyApp());
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return new MaterialApp(
//       title: 'Flutter Demo',
//       initialRoute: "/",
//       theme: new ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       routes: {
//         "new_page": (context) => EchoRoute(),
//         "/": (context) => MyHomePage(title: 'Flutter Demo Home Page'),
//         "tip2": (context) {
//           return TipRoute(text: ModalRoute.of(context).settings.arguments);
//         },
//         "cupertino_router": (context) => CupertinoTestRoute(),
//         "padding_test_route": (context) => PaddingTestRoute(),
//         "single_child_scrollView_route": (context) => SingleChildScrollViewTestRoute(),
//         "file_operation_route": (context) => FileOperationRoute(),
//         "http_test_route": (context) => HTTPTestRoute(),
//         "future_build_route": (context) => FutureBuilderRouter(),
//       },
//       // home: new MyHomePage(title: 'Flutter Demo 1'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   final String title;
//   MyHomePage({Key key, this.title}) : super(key: key);
//
//   _MyHomePageState createState() => new _MyHomePageState();
// }
//
// class RandomWrodsWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final wordPair = new WordPair.random();
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: new Text(wordPair.toString()),
//     );
//   }
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//
//   void _incrementCounter() {
//     setState(() {
//       _counter++;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//       appBar: new AppBar(
//         title: new Text(widget.title),
//       ),
//       body: new Center(
//         child: new Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             new Text('You have pushed to the button this many times:'),
//             new Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headline4,
//             ),
//             FlatButton(
//               onPressed: () {
//                 // Navigator.push(context, MaterialPageRoute(builder: (context) {
//                 //   return NewRoute();
//                 // }));
//                 // Navigator.pushNamed(context, "new_page");
//                 // Navigator.of(context).pushNamed("tip2", arguments: "hi, tip2");
//                 // Navigator.pushNamed(context, "cupertino_router");
//                 // Navigator.pushNamed(context, "padding_test_route");
//                 // Navigator.pushNamed(context, "single_child_scrollView_route");
//                 // Navigator.pushNamed(context, "file_operation_route");
//                 // Navigator.pushNamed(context, "http_test_route");
//                 Navigator.pushNamed(context, "future_build_route");
//               },
//               child: Text("open new route"),
//               textColor: Colors.blue,
//             ),
//             RandomWrodsWidget(),
//             Image.network(
//               "https://avatars2.githubusercontent.com/u/20411648?s=460&v=4",
//               width: 100.0,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: new FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: new Icon(Icons.add),
//       ),
//     );
//   }
// }
//
// class EchoRoute extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     var args = ModalRoute.of(context).settings.arguments;
//     print("$args");
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("New Route"),
//         backgroundColor: Colors.red,
//         centerTitle: false,
//         titleTextStyle: TextStyle(
//           color: Colors.white,
//           fontSize: 40,
//         ),
//       ),
//       body: Center(
//         child: Text("This is new route"),
//       ),
//     );
//   }
// }
//
// class NewRoute extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("New Route"),
//         backgroundColor: Colors.red,
//         centerTitle: false,
//         titleTextStyle: TextStyle(
//           color: Colors.white,
//           fontSize: 40,
//         ),
//       ),
//       body: Center(
//         child: Text("This is new route"),
//       ),
//     );
//   }
// }
//
// class TipRoute extends StatelessWidget {
//   final String text;
//   TipRoute({
//     Key key,
//     @required this.text,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Text("提示"),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(18),
//         child: Center(
//           child: Column(
//             children: <Widget>[
//               Text(text),
//               RaisedButton(
//                 onPressed: () => Navigator.pop(context, "我是返回值"),
//                 child: Text("返回"),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class RouterTestRoute extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: RaisedButton(
//         onPressed: () async {
//           var result = await Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) {
//                 return TipRoute(text: "我是提示页");
//               },
//             ),
//           );
//           print("路由返回值 $result");
//         },
//         child: Text("打开提示页"),
//       ),
//     );
//   }
// }
//
// class CupertinoTestRoute extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return CupertinoPageScaffold(
//       navigationBar: CupertinoNavigationBar(
//         middle: Text("Cupertino Demo"),
//       ),
//       child: Center(
//         child: CupertinoButton(
//           color: CupertinoColors.activeBlue,
//           child: Text("press"),
//           onPressed: () {
//             print("cupertinoButton is clicked");
//           },
//         ),
//       ),
//     );
//   }
// }
//
// class PaddingTestRoute extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Padding(
//       padding: EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Padding(
//             padding: const EdgeInsets.only(left: 8.0),
//             child: Text("Hello world"),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 8.0),
//             child: Text("I am Jack"),
//           ),
//           Padding(
//             padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
//             child: Text("Your friend"),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class SingleChildScrollViewTestRoute extends StatelessWidget {
//   final String str = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Scrollbar(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16.0),
//           child: Center(
//             child: Column(
//               children: str.split("")
//               .map((c) => Text(c, textScaleFactor: 2.0))
//               .toList(),
//             ),
//           ),
//         ),
//     );
//   }
// }
