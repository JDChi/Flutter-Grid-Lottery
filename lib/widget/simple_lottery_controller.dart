import 'package:flutter/cupertino.dart';

class SimpleLotteryValue {
  SimpleLotteryValue(
      {this.target = 0,
      this.isFinish = false,
      this.isPlaying = false,
      this.isFake = false,
      this.singleRoundFakeDuration = const Duration(),
      this.duration = const Duration(),
      this.repeatRound = 1});

  /// 中奖目标
  final int target;

  final bool isPlaying;
  final bool isFinish;

  /// 只是进行动画，无抽奖结果
  final bool isFake;

  /// 转动的圈数
  final int repeatRound;

  /// 实际抽奖总耗时
  final Duration duration;

  /// 假抽奖单圈耗时
  final Duration singleRoundFakeDuration;

  SimpleLotteryValue copyWith(
      {int target,
      bool isPlaying,
      bool isFinish,
      bool isFake,
      int repeatRound,
      Duration duration,
      Duration singleRoundFakeDuration}) {
    return SimpleLotteryValue(
        target: target ?? this.target,
        isFinish: isFinish ?? this.isFinish,
        isPlaying: isPlaying ?? this.isPlaying,
        isFake: isFake ?? this.isFake,
        repeatRound: repeatRound ?? this.repeatRound,
        duration: duration ?? this.duration,
        singleRoundFakeDuration:
            singleRoundFakeDuration ?? this.singleRoundFakeDuration);
  }

  @override
  String toString() {
    return "$runtimeType(target : $target , isPlaying : $isPlaying , isFinish : $isFinish , isFake : $isFake , repeatRound : $repeatRound)";
  }
}

class SimpleLotteryController extends ValueNotifier<SimpleLotteryValue> {
  SimpleLotteryController() : super(SimpleLotteryValue());

  /// 开启抽奖
  ///
  /// [target] 中奖目标
  void start({int target = 0, Duration duration, int repeatRound}) {
    // 九宫格抽奖里范围为0~8
    assert(target >= 0 && target <= 8);
    // 如果是在实际抽奖过程中，则不能多次start
    if (value.isPlaying && !value.isFake) {
      return;
    }
    value = value.copyWith(
        target: target,
        isPlaying: true,
        isFake: false,
        duration: duration,
        repeatRound: repeatRound);
  }

  /// 开启假的抽奖动画
  void startFake({Duration singleRoundFakeDuration}) {
    if (value.isPlaying) {
      return;
    }
    value = value.copyWith(
        isPlaying: true,
        isFake: true,
        singleRoundFakeDuration: singleRoundFakeDuration);
  }

  void finish() {
    value = value.copyWith(isFinish: true, isPlaying: false);
  }
}
