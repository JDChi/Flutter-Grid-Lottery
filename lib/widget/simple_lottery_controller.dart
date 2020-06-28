import 'package:flutter/cupertino.dart';

class SimpleLotteryValue {
  SimpleLotteryValue(
      {this.target = 0,
      this.isFinish = false,
      this.isPlaying = false,
      this.isFake = false,
      this.isSetTargetDuringFake = false,
      this.singleRoundFakeDuration = const Duration(),
      this.duration = const Duration(),
      this.repeatRound = 1,
      this.rewardsList});

  /// 中奖目标
  final int target;

  final bool isPlaying;
  final bool isFinish;

  /// 只是进行动画，无抽奖结果
  final bool isFake;
  final bool isSetTargetDuringFake;

  /// 转动的圈数
  final int repeatRound;

  /// 实际抽奖总耗时
  final Duration duration;

  /// 奖品列表
  final List<String> rewardsList;

  /// 假抽奖单圈耗时
  final Duration singleRoundFakeDuration;

  SimpleLotteryValue copyWith(
      {int target,
      bool isPlaying,
      bool isFinish,
      bool isFake,
      bool isSetTargetDuringFake,
      int repeatRound,
      Duration duration,
      List<String> rewardsList,
      Duration singleRoundFakeDuration}) {
    return SimpleLotteryValue(
        target: target ?? this.target,
        isFinish: isFinish ?? this.isFinish,
        isPlaying: isPlaying ?? this.isPlaying,
        isFake: isFake ?? this.isFake,
        isSetTargetDuringFake:
            isSetTargetDuringFake ?? this.isSetTargetDuringFake,
        repeatRound: repeatRound ?? this.repeatRound,
        duration: duration ?? this.duration,
        singleRoundFakeDuration:
            singleRoundFakeDuration ?? this.singleRoundFakeDuration,
        rewardsList: rewardsList ?? this.rewardsList);
  }

  @override
  String toString() {
    return "$runtimeType(target : $target , "
        "isPlaying : $isPlaying , "
        "isFinish : $isFinish , "
        "isFake : $isFake , "
        "isSetTargetDuringFake : $isSetTargetDuringFake , "
        "repeatRound : $repeatRound)";
  }
}

class SimpleLotteryController extends ValueNotifier<SimpleLotteryValue> {
  SimpleLotteryController({@required List<String> rewardsList})
      : super(SimpleLotteryValue(rewardsList: rewardsList));

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
        isSetTargetDuringFake: value.isFake,
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
    value = value.copyWith(
        isFinish: true,
        isPlaying: false,
        isSetTargetDuringFake: false,
        isFake: false);
  }
}
