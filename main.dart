import 'dart:convert';

import 'package:flukit/flukit.dart';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // root widget
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: const HomePageList(),
    );
  }
}

// 主界面的列表Widget
class HomePageList extends StatelessWidget {
  const HomePageList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(10), children: <Widget>[
      ListTile(
        title: const Text("AfterLayout"),
        trailing: const Icon(Icons.featured_play_list_outlined),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AfterLayoutPage(),
            ),
          );
        },
      ),
      ListTile(
        title: const Text("WordList"),
        trailing: const Icon(Icons.alarm_add_outlined),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LazyListPage(),
            ),
          );
        },
      ),
      ListTile(
        title: const Text("SingleChildScrollView"),
        trailing: const Icon(Icons.interests_rounded),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const SingleChildScrollViewDemo()));
        },
      ),
      ListTile(
        title: const Text("OnlineImage"),
        trailing: const Icon(Icons.image_outlined),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ShowImage()));
        },
      ),
      ListTile(
        title: const Text("PointerDown Event test"),
        trailing: const Icon(Icons.arrow_upward_outlined),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => PointerDownEventPage()));
        },
      ),
      ListTile(
        title: const Text("Watermask Sample"),
        trailing: const Icon(Icons.arrow_upward_outlined),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => eventSamplePage()));
        },
      )
    ]);
  }
}

class eventSamplePage extends StatelessWidget {
  const eventSamplePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PointerDownEvent"),
      ),
      body: WaterMaskTest(),
    );
  }
}

class WaterMaskTest extends StatelessWidget {
  const WaterMaskTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        HitTestBlocker(child: wChild(1, Colors.white, 200)),
        HitTestBlocker(child: wChild(2, Colors.black, 200))
        // IgnorePointer(
        //   child: WaterMark(
        //     painter: TextWaterMarkPainter(text: 'wendux', rotate: -20),
        //   ),
        // )
      ],
    );
  }

  Widget wChild(int index, color, double size) {
    return Listener(
      onPointerDown: (e) => print(index),
      child: Container(
        width: size,
        height: size,
        color: Colors.grey,
      ),
    );
  }
}

class PointerDownListener extends SingleChildRenderObjectWidget {
  PointerDownListener({Key? key, this.onPointerDown, Widget? child})
      : super(key: key, child: child);

  final PointerDownEventListener? onPointerDown;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      RenderPointerDownListener()..onPointerDown = onPointerDown;

  @override
  void updateRenderObject(
      BuildContext context, RenderPointerDownListener renderObject) {
    renderObject.onPointerDown = onPointerDown;
  }
}

class RenderPointerDownListener extends RenderProxyBox {
  PointerDownEventListener? onPointerDown;

  @override
  bool hitTestSelf(Offset position) => true; //始终通过命中测试

  @override
  void handleEvent(PointerEvent event, covariant HitTestEntry entry) {
    //事件分发时处理事件
    if (event is PointerDownEvent) onPointerDown?.call(event);
  }
}

class PointerDownEventPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PointerDownEvent"),
      ),
      body: PointerDownListenerRoute(),
    );
  }
}

class PointerDownListenerRoute extends StatelessWidget {
  const PointerDownListenerRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PointerDownListener(
      child: Text('Click me'),
      onPointerDown: (e) => print('down'),
    );
  }
}

class ShowImage extends StatelessWidget {
  const ShowImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ImageGallery"),
      ),
      body: ImagesPage(),
    );
  }
}

class ImagesPage extends StatefulWidget {
  @override
  _ImagesPage createState() => _ImagesPage();
}

class _ImagesPage extends State<ImagesPage> {
  List data = [];
  List imageUrl = [];

  @override
  void initState() {
    super.initState();
    fetchDataOnline();
  }

  Future<String> fetchDataOnline() async {
    var jsonData = await http.get(Uri.parse(
        "https://raw.githubusercontent.com/GeorgeHu6/learnflutter/main/static/image_list.json"));
    var fetchData = jsonDecode(jsonData.body);

    print(fetchData);

    setState(() {
      data = fetchData["images"];
      data.forEach((element) {
        imageUrl.add(element);
      });
    });

    return "OK";
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: imageUrl.length,
        itemBuilder: (BuildContext context, int index) {
          return Image.network(imageUrl[index], fit: BoxFit.fitWidth);
        });
  }
}

class SingleChildScrollViewDemo extends StatelessWidget {
  const SingleChildScrollViewDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String str = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    return Scaffold(
      appBar: AppBar(
        title: const Text("SingleChildScrollView"),
      ),
      body: Scrollbar(
        // 显示进度条
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              //动态创建一个List<Widget>
              children: str
                  .split("")
                  //每一个字母都用一个Text显示,字体为原来的两倍
                  .map((c) => Text(
                        c,
                        textScaleFactor: 2.0,
                      ))
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class LazyListPage extends StatefulWidget {
  const LazyListPage({Key? key}) : super(key: key);

  @override
  _LazyListPageState createState() => _LazyListPageState();
}

class _LazyListPageState extends State<LazyListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WordList'),
      ),
      body: const InfiniteListView(),
    );
  }
}

class InfiniteListView extends StatefulWidget {
  const InfiniteListView({Key? key}) : super(key: key);

  @override
  _InfiniteListViewState createState() => _InfiniteListViewState();
}

class _InfiniteListViewState extends State<InfiniteListView> {
  static const loadingTag = "##loading##"; //表尾标记
  var _words = <String>[loadingTag];

  @override
  void initState() {
    super.initState();
    _retrieveData();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: _words.length,
      itemBuilder: (context, index) {
        //如果到了表尾
        if (_words[index] == loadingTag) {
          //不足50条，继续获取数据
          if (_words.length - 1 < 50) {
            //获取数据
            _retrieveData();
            //加载时显示loading
            return Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.center,
              child: const SizedBox(
                width: 24.0,
                height: 24.0,
                child: CircularProgressIndicator(strokeWidth: 2.0),
              ),
            );
          } else {
            //已经加载了50条数据，不再获取数据。
            return Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(16.0),
              child: const Text(
                "没有更多了",
                style: TextStyle(color: Colors.grey),
              ),
            );
          }
        }
        //显示单词列表项
        return ListTile(title: Text(_words[index]));
      },
      separatorBuilder: (context, index) {
        print("Separator added at $index");
        return const Divider(height: .0);
      },
    );
  }

  void _retrieveData() {
    Future.delayed(Duration(seconds: 1)).then((e) {
      setState(() {
        //重新构建列表
        _words.insertAll(
          _words.length - 1,
          //每次生成20个单词
          generateWordPairs().take(20).map((e) => e.asPascalCase).toList(),
        );
      });
    });
  }
}

class AfterLayoutPage extends StatelessWidget {
  const AfterLayoutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AfterLayout'),
      ),
      body: const AfterLayoutRoute(),
    );
  }
}

class AfterLayoutRoute extends StatefulWidget {
  const AfterLayoutRoute({Key? key}) : super(key: key);

  @override
  _AfterLayoutRouteState createState() => _AfterLayoutRouteState();
}

class _AfterLayoutRouteState extends State<AfterLayoutRoute> {
  String _text = 'flutter 实战 ';
  Size _size = Size.zero;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Builder(
            builder: (context) {
              return GestureDetector(
                child: const Text(
                  'Text1: 点我获取我的大小',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.blue),
                ),
                onTap: () => print('Text1: ${context.size}'),
              );
            },
          ),
        ),
        AfterLayout(
          callback: (RenderAfterLayout ral) {
            print('Text2: ${ral.size}, ${ral.offset}');
          },
          child: const Text('Text2: flutter@wendux'),
        ),
        Builder(builder: (context) {
          return Container(
            color: Colors.grey.shade200,
            alignment: Alignment.center,
            width: 100,
            height: 100,
            child: AfterLayout(
              callback: (RenderAfterLayout ral) {
                Offset offset = ral.localToGlobal(
                  Offset.zero,
                  ancestor: context.findRenderObject(),
                );
                print('A 在 Container 中占用的空间范围为：${offset & ral.size}');
              },
              child: const Text('A'),
            ),
          );
        }),
        const Divider(),
        AfterLayout(
          child: Text(_text),
          callback: (RenderAfterLayout value) {
            setState(() {
              //更新尺寸信息
              _size = value.size;
            });
          },
        ),
        //显示上面 Text 的尺寸
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Text size: $_size ',
            style: const TextStyle(color: Colors.blue),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _text += 'flutter 实战 ';
            });
          },
          child: const Text('追加字符串'),
        ),
      ],
    );
  }
}

class HitTestBlocker extends SingleChildRenderObjectWidget {
  HitTestBlocker({
    Key? key,
    this.up = true,
    this.down = false,
    this.self = false,
    Widget? child,
  }) : super(key: key, child: child);

  /// up 为 true 时 , `hitTest()` 将会一直返回 false.
  final bool up;

  /// down 为 true 时, 将不会调用 `hitTestChildren()`.
  final bool down;

  /// `hitTestSelf` 的返回值
  final bool self;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderHitTestBlocker(up: up, down: down, self: self);
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderHitTestBlocker renderObject) {
    renderObject
      ..up = up
      ..down = down
      ..self = self;
  }
}

class RenderHitTestBlocker extends RenderProxyBox {
  RenderHitTestBlocker({this.up = true, this.down = true, this.self = true});

  bool up;
  bool down;
  bool self;

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    bool hitTestDownResult = false;

    if (!down) {
      hitTestDownResult = hitTestChildren(result, position: position);
    }

    bool pass =
        hitTestSelf(position) || (hitTestDownResult && size.contains(position));

    if (pass) {
      result.add(BoxHitTestEntry(this, position));
    }

    return !up && pass;
  }

  @override
  bool hitTestSelf(Offset position) => self;
}
