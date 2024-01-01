import "dart:async";
import 'package:timezone/timezone.dart' as timezone;

class CountDown {
  late DateTime begin;
  late Timer _timer;
  late Duration _duration;
  late Duration remainingTime;
  bool isPaused = false;
  late StreamController<Duration> _controller;
  late Duration _refresh;
  int everyTick = 1;
  late int _everyTick, counter = 0;
  late Duration timeStep; // Thêm timeStep để định rõ thời gian lăn

  CountDown(
    DateTime startTime,
    Duration duration,
    Duration timeStep, // Thêm timeStep vào constructor
    {
    Duration refresh = const Duration(milliseconds: 10),
  }) {
    begin = startTime;
    _refresh = refresh;
    _everyTick = everyTick;
    _duration = duration;
    this.timeStep = timeStep; // Gán giá trị cho timeStep
    _controller = StreamController<Duration>(
      onListen: _onListen,
      onPause: _onPause,
      onResume: _onResume,
      onCancel: _onCancel,
    );
  }

  int getCurrentSeconds() {
    Duration alreadyConsumed = DateTime.now().difference(begin);
    int seconds = alreadyConsumed.inSeconds;
    return seconds < 0 ? 0 : seconds;
  }

  Stream<Duration> get stream => _controller.stream;

   _onListen() {
    _timer = Timer.periodic(_refresh, (timer) => _tick(timer, DateTime.now()));
    _startOtpRefreshTimer();
  }

  _onPause() {
    isPaused = true;
    _timer.cancel();
  }

  _onResume() {
    _duration = remainingTime;
    isPaused = false;
    _timer = Timer.periodic(_refresh, (timer) => _tick(timer, DateTime.now()));
    _startOtpRefreshTimer(); // Resume the OTP refresh timer
  }

  _onCancel() {
    if (!isPaused) {
      _timer.cancel();
    }
  }

void _startOtpRefreshTimer() {
    Timer.periodic(const Duration(seconds: 30), (timer) {
      DateTime now = DateTime.now();
      int secondsInCurrentInterval = now.second;
      int secondsUntilRefresh = 30 - secondsInCurrentInterval;

      Timer(Duration(seconds: secondsUntilRefresh), () {

     // Schedule the next refresh
      });
    });
  }

  void _refreshOtp() {
    // Implement the logic to refresh the OTP
    print('Refreshing OTP');
    // You can replace the print statement with the actual logic
  }

  void _tick(Timer timer, DateTime currentTime) {
    counter++;
    Duration alreadyConsumed = currentTime.difference(begin);
    remainingTime = _duration - alreadyConsumed;
    if (remainingTime.isNegative) {
      timer.cancel();
      _controller.close();
    } else {
      if (counter % _everyTick == 0) {
        _controller.add(remainingTime);
        counter = 0;
      }
    }
  }
}
