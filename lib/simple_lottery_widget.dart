import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SimpleLotteryWidget extends StatefulWidget {
  final SimpleLotteryController controller;
  final Function onPress;

  SimpleLotteryWidget({Key key, @required this.controller, this.onPress});

  @override
  _SimpleLotteryWidgetState createState() => _SimpleLotteryWidgetState();
}

class _SimpleLotteryWidgetState extends State<SimpleLotteryWidget>
    with TickerProviderStateMixin {
  Animation<int> _selectedIndexTween;
  AnimationController _startAnimateController;
  int _currentSelect = -1;
  int _target = 0;
  final int _totalIndex = 8;

  /// 旋转的圈数
  final int repeatRound = 3;
  VoidCallback _listener;
  bool _continueToTarget = false;

  /// 选中下标的映射
  final Map<int, int> _selectMap = {
    0: 0,
    1: 3,
    2: 6,
    3: 7,
    4: 8,
    5: 5,
    6: 2,
    7: 1
  };

  _SimpleLotteryWidgetState() {
    _listener = () {
      _continueToTarget = false;
      // 开启抽奖动画
      if (widget.controller.value.isPlaying) {
        // 如果是假的，则只是循环抽奖过程
        if (widget.controller.value.isFake) {
          _startAnimation(isFake: true);
        } // 如果在假装抽奖的过程中，设置了target
        else if (isDuringJustAnimation) {
          setState(() {
            _continueToTarget = true;
          });
        } // 常规的直接抽奖
        else {
          _startAnimation();
        }
      }
    };
  }

  /// 是否处于
  bool get isDuringJustAnimation =>
      !widget.controller.value.isFake && _startAnimateController.isAnimating;

  /// 初始化tween
  ///
  /// [target] 中奖的目标
  Animation _initSelectIndexTween({int begin = 0, int end = 0}) =>
      StepTween(begin: begin, end: end).animate(CurvedAnimation(
          parent: _startAnimateController, curve: Curves.linear));

  /// 开启抽奖动画
  ///
  /// [isFake] false : 表示有实际结果
  ///          true :  表示开启重复动画，无实际效果
  _startAnimation({bool isFake = false}) {
    _startAnimateController.reset();
    if (isFake) {
      _startAnimateController.duration = widget.controller.fakeDuration;
      _selectedIndexTween = _initSelectIndexTween(begin: 0, end: _totalIndex);
      _startAnimateController.repeat();
    } else {
      _target = widget.controller.value.target;
      _startAnimateController.duration = widget.controller.duration;
      _selectedIndexTween = _initSelectIndexTween(
          begin: 0, end: widget.controller.repeatRound * _totalIndex + _target);
      _startAnimateController.forward();
    }
  }

  @override
  void initState() {
    _startAnimateController =
        AnimationController(vsync: this, duration: widget.controller.duration);
    _selectedIndexTween = _initSelectIndexTween(begin: 0, end: _totalIndex);

    // 动画监听
    _startAnimateController.addListener(() {
      // 更新选中的下标
      _currentSelect = _selectMap[_selectedIndexTween.value % _totalIndex];

      // 在假的抽奖过程到0位置时, 开启真的抽奖
      if (_continueToTarget && _currentSelect == 0) {
        _continueToTarget = false;
        _startAnimation();
      }
      if (_startAnimateController.isCompleted) {
        widget.controller.finish();
      }
      setState(() {});
    });

    // 控制监听
    widget.controller.addListener(_listener);

    super.initState();
  }

  @override
  void deactivate() {
    widget.controller.removeListener(_listener);
    super.deactivate();
  }

  @override
  void dispose() {
    _startAnimateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 220,
        height: 220,
        child: GridView.builder(
            itemCount: 9,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, crossAxisSpacing: 4, mainAxisSpacing: 4),
            itemBuilder: (context, index) {
              if (index != 4) {
                return Container(
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Container(
                        width: 50,
                        height: 50,
                        color: index == _currentSelect
                            ? Colors.blue
                            : Colors.amber,
                      ),
                    ],
                  ),
                );
              }
              return GestureDetector(
                onTap: () => widget.onPress(),
                child: Container(
                  color: Colors.red,
                ),
              );
            }));
  }
}

class SimpleLotteryValue {
  SimpleLotteryValue(
      {this.target = 0,
      this.isFinish = false,
      this.isPlaying = false,
      this.isFake = false});

  /// 中奖目标
  int target = 0;

  bool isPlaying = false;
  bool isFinish = false;

  /// 只是进行动画，无抽奖结果
  bool isFake = false;

  SimpleLotteryValue copyWith({
    int target = 0,
    bool isPlaying = false,
    bool isFinish = false,
    bool isFake = false,
  }) {
    return SimpleLotteryValue(
        target: target,
        isFinish: isFinish,
        isPlaying: isPlaying,
        isFake: isFake);
  }

  @override
  String toString() {
    return "target : $target , isPlaying : $isPlaying , isFinish : $isFinish";
  }
}

class SimpleLotteryController extends ValueNotifier<SimpleLotteryValue> {
  /// 转动的圈数
  final int repeatRound;

  /// 耗时
  final Duration duration;

  final Duration fakeDuration;

  SimpleLotteryController(
      {this.repeatRound = 1,
      this.duration = const Duration(seconds: 4),
      this.fakeDuration = const Duration(seconds: 1)})
      : super(SimpleLotteryValue());

  /// 开启抽奖
  ///
  /// [target] 中奖目标
  ///
  /// [isFake] 是否只是循环播放动画，如果为true，则会忽略target，只是循环播放抽奖过程
  void start({int target = 0, bool isFake = false}) {
    // 九宫格抽奖里范围为0~8
    assert(target >= 0 && target <= 8);
    // 如果是在实际抽奖过程中，则不能多次start
    if (value.isPlaying && !value.isFake) {
      return;
    }
    value = value.copyWith(target: target, isPlaying: true, isFake: isFake);
  }

  void finish() {
    value = value.copyWith(isFinish: true);
  }

  void cancel() {}
}
