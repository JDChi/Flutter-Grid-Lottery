import 'package:flutter/material.dart';
import 'package:simplegridlottery/widget/simple_lottery_controller.dart';
import 'package:simplegridlottery/widget/simple_lottery_widget.dart';

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
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late SimpleLotteryController simpleLotteryController;
  List<String> rewardsList = [];

  @override
  void initState() {
    rewardsList
      ..add("images/gift1.jpg")
      ..add("images/gift2.jpg")
      ..add("images/gift1.jpg")
      ..add("images/gift2.jpg")
      ..add("images/gift1.jpg")
      ..add("images/gift2.jpg")
      ..add("images/gift1.jpg")
      ..add("images/gift2.jpg");
    simpleLotteryController = SimpleLotteryController(rewardsList: rewardsList);
    simpleLotteryController.addListener(() {
      if (simpleLotteryController.value.isPlaying) {
      } else if (simpleLotteryController.value.isFinish) {}
      print(simpleLotteryController.value.toString());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          TextButton(
              child: Text("模拟在假抽奖动画过程中加入最后结果"),
              onPressed: () {
                simpleLotteryController.startFake(
                    singleRoundFakeDuration: Duration(milliseconds: 1000));
                Future.delayed(Duration(seconds: 2)).then((_) {
                  simpleLotteryController.start(
                      target: 4,
                      duration: Duration(milliseconds: 2500),
                      repeatRound: 2);
                });
              }),
          Center(
            child: SimpleLotteryWidget(
              controller: simpleLotteryController,
              onPress: () {
                simpleLotteryController.start(
                    target: 4,
                    duration: Duration(milliseconds: 2500),
                    repeatRound: 2);
              },
            ),
          ),
          TextButton(
              onPressed: () {
                _resetRewardList();
              },
              child: Text('Reset'))
        ],
      ),
    );
  }

  /// 当抽奖结束后，变更抽奖列表
  void _resetRewardList() {
    setState(() {
      rewardsList
        ..clear()
        ..add("images/gift3.jpg")
        ..add("images/gift2.jpg")
        ..add("images/gift3.jpg")
        ..add("images/gift2.jpg")
        ..add("images/gift3.jpg")
        ..add("images/gift2.jpg")
        ..add("images/gift3.jpg")
        ..add("images/gift2.jpg");
      simpleLotteryController =
          SimpleLotteryController(rewardsList: rewardsList);
    });
  }
}
