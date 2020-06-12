import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simplegridlottery/widget/simple_lottery_controller.dart';

class SimpleLotteryWidget extends StatefulWidget {
  final SimpleLotteryController controller;
  final Function onPress;

  SimpleLotteryWidget({Key key, @required this.controller, this.onPress})
      : assert(controller != null);

  @override
  _SimpleLotteryWidgetState createState() => _SimpleLotteryWidgetState();
}

class _SimpleLotteryWidgetState extends State<SimpleLotteryWidget>
    with TickerProviderStateMixin {
  Animation<int> _selectedIndexTween;
  AnimationController _startAnimateController;
  int _currentSelect = -1;
  final int _totalIndex = 8;

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
          _startFakeAnimation();
        } // 如果在假装抽奖的过程中，设置了target
        else if (isDuringFake) {
          setState(() {
            _continueToTarget = true;
          });
        } // 常规的直接抽奖
        else {
          _startActualAnimation();
        }
      }
    };
  }

  bool get isDuringFake =>
      !widget.controller.value.isFake && _startAnimateController.isAnimating;

  /// 初始化tween
  ///
  /// [target] 中奖的目标
  Animation _initSelectIndexTween({int begin = 0, int end = 0}) =>
      StepTween(begin: begin, end: end).animate(CurvedAnimation(
          parent: _startAnimateController, curve: Curves.linear));

  _startFakeAnimation() {
    _startAnimateController.reset();
    _startAnimateController.duration =
        widget.controller.value.singleRoundFakeDuration;
    _selectedIndexTween = _initSelectIndexTween(begin: 0, end: _totalIndex);
    _startAnimateController.repeat();
  }

  _startActualAnimation() {
    _startAnimateController.reset();
    _startAnimateController.duration = widget.controller.value.duration;
    _selectedIndexTween = _initSelectIndexTween(
        begin: 0,
        end: widget.controller.value.repeatRound * _totalIndex +
            widget.controller.value.target);
    _startAnimateController.forward();
  }

  @override
  void initState() {
    _startAnimateController = AnimationController(
        vsync: this, duration: widget.controller.value.duration);
    _selectedIndexTween = _initSelectIndexTween(begin: 0, end: _totalIndex);

    // 动画监听
    _startAnimateController.addListener(() {
      // 更新选中的下标
      _currentSelect = _selectMap[_selectedIndexTween.value % _totalIndex];

      // 在假的抽奖过程到0位置时, 开启真的抽奖, 主要是起到无缝衔接
      if (_continueToTarget && _currentSelect == 0) {
        _continueToTarget = false;
        _startActualAnimation();
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
