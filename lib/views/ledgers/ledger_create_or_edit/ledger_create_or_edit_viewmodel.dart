import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_ledger/app/utils.dart';
import 'package:shared_ledger/models/ledger_model.dart';
import 'package:shared_ledger/repositories/ledger_repository.dart';

class LedgerCreateOrEditViewModel {
  final LedgerRepository _ledgerRepo;
  final GoRouter _router;

  late final Ledger? ledger;

  LedgerCreateOrEditViewModel({
    required ModelOrId<Ledger>? ledgerOrId,
    required LedgerRepository ledgerRepo,
    required GoRouter router,
  })  : _ledgerRepo = ledgerRepo,
        _router = router {
    if (ledgerOrId == null) {
      ledger = null;
      return;
    }

    isLoading.value = true;
    _loadLedger(ledgerOrId).then((_) {
      name = ledger!.name;
      description = ledger!.description ?? '';
      isLoading.value = false;
    });
  }

  Future<void> _loadLedger(ModelOrId<Ledger> ledgerOrId) async {
    if (ledgerOrId.hasModel) {
      ledger = ledgerOrId.model!;
      return;
    }

    await _ledgerRepo.getLedger(ledgerOrId.id).then((ledger) {
      this.ledger = ledger;
    });
  }

  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final ValueNotifier<bool> isSaving = ValueNotifier(false);

  String name = '';
  String description = '';

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  dispose() {
    isLoading.dispose();
    isSaving.dispose();
  }

  Future<void> save() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    formKey.currentState!.save();

    createOrEdit() async {
      if (ledger == null) {
        return await _createLedger();
      } else {
        return await _updateLedger();
      }
    }

    isLoading.value = true;
    await createOrEdit().then((ledger) {
      _router.pop(ledger);
    }).whenComplete(() {
      isLoading.value = false;
    });
  }

  Future<Ledger> _createLedger() async {
    return await _ledgerRepo.createLedger(name, description);
  }

  Future<Ledger> _updateLedger() async {
    return await _ledgerRepo.updateLedger(ledger!.copyWith(
      name: name,
      description: description,
    ));
  }
}
