import 'package:flutter/widgets.dart';

import 'minerva_manager.dart';

class MinervaAppLifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        final MinervaManager minMgr = MinervaManager.getInstance();
        minMgr.becomeActive();
        break;
      case AppLifecycleState.inactive:
        final MinervaManager minMgr = MinervaManager.getInstance();
        minMgr.enterBackground();
        break;
      default:
        break;
    }
  }
}
