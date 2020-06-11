import 'package:flutter/cupertino.dart';

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
}
