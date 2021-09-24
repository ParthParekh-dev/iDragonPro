import 'dart:async';

import 'package:get/get.dart';
import 'package:idragon_pro/models/promoResponse.dart';
import 'package:idragon_pro/services/networkService.dart';

class PromoController extends GetxController {
  var promoDetails = Rxn<Promoflash>();
  var isLoading = true.obs;
  late Timer _timer;
  var _start = 0;
  var coundDown = Rxn<int>();
  var isTimerOver = false.obs;

  @override
  void onInit() {
    fetchPromoVideo();
    super.onInit();
  }

  void setCountDown(int count) {
    coundDown.value = count;
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (_start == 0) {
        _timer.cancel();
        isTimerOver(true);
      }
      _start--;
      setCountDown(_start);
    });
  }

  void fetchPromoVideo() async {
    isLoading(true);
    try {
      var result = await NetworkService().fetchPromoVideo();

      if (result != null) {
        promoDetails.value = result.promoflash;
        _start = int.parse(result.promoflash.flashTime) + 3;
      }
    } finally {
      isTimerOver(false);
      startTimer();
      isLoading(false);
    }
  }
}
