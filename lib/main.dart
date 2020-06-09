import 'package:flutter/material.dart';
import 'package:simplegridlottery/simple_lottery_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Simple Grid Lottery'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SimpleLotteryController simpleLotteryController;

  @override
  void initState() {
    simpleLotteryController = SimpleLotteryController();
    simpleLotteryController.addListener(() {
      if (simpleLotteryController.value.isPlaying) {
      } else if (simpleLotteryController.value.isFinish) {}
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: SimpleLotteryWidget(
          controller: simpleLotteryController,
          onPress: () => simpleLotteryController.start(target: 4),
        ),
      ),
    );
  }
}
