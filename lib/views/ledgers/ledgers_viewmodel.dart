import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_ledger/models/ledger_model.dart';
import 'package:shared_ledger/repositories/ledger_repository.dart';
import 'package:shared_ledger/widgets/ledger_list_tile_widget.dart';

class LedgersViewModel {
  final LedgerRepository _ledgerRepo;

  final GoRouter _router;

  final ValueNotifier<List<Ledger>> userLedgers = ValueNotifier([]);

  final ValueNotifier<List<Ledger>> sharedLedgers = ValueNotifier([]);

  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  LedgersViewModel({
    required LedgerRepository ledgerRepository,
    required GoRouter router,
  })  : _ledgerRepo = ledgerRepository,
        _router = router;

  GlobalKey<AnimatedListState> animatedListKey = GlobalKey();

  Future<void> createNewLedgerTapped() async {
    final newLedger = await _router.push('/ledgers/create');
    if (newLedger is! Ledger) return;

    userLedgers.value = [newLedger, ...userLedgers.value];
    animatedListKey.currentState?.insertItem(0);
  }

  void dispose() {
    userLedgers.dispose();
    isLoading.dispose();
  }

  Future<void> getLedgers() async {
    await _ledgerRepo.getLedgers().then((data) {
      userLedgers.value = data;
    });
    await _ledgerRepo.getSharedWithMeLedgers().then((data) {
      sharedLedgers.value = data;
    });
  }

  Future<void> init() async {
    isLoading.value = true;
    await getLedgers().whenComplete(() {
      isLoading.value = false;
    });
  }

  Future<void> onRefresh() async {
    await getLedgers();
  }

  Future<void> deleteLedgerTapped(Ledger ledger, int listIndex) async {
    await _ledgerRepo.deleteLedger(ledger).then((data) {
      userLedgers.value = userLedgers.value
          .where((element) => element.id != ledger.id)
          .toList();
    });
    animatedListKey.currentState?.removeItem(
      listIndex,
      (context, animation) => LedgerListTile(
        ledger: ledger,
        animation: animation,
      ),
    );
  }

  void onLedgerTapped(Ledger ledger) {
    _router.go('/ledgers/${ledger.id}', extra: ledger);
  }

  Future<void> onEditLedgerTapped(Ledger ledger) async {
    final updated =
        await _router.push('/ledgers/${ledger.id}/edit', extra: ledger);
    if (updated is! Ledger) return;
    await _ledgerRepo.getLedgers().then((data) {
      userLedgers.value = data;
    });
  }
}
