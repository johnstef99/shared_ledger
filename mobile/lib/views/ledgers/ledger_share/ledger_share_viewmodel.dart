import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_ledger/app/utils.dart';
import 'package:shared_ledger/models/ledger_model.dart';
import 'package:shared_ledger/repositories/ledger_repository.dart';

class LedgerShareViewModel {
  final LedgerRepository _ledgerRepo;

  late final Ledger ledger;

  final ValueNotifier<bool> isLoading = ValueNotifier(true);

  final ValueNotifier<List<String>> sharedEmails = ValueNotifier([]);

  LedgerShareViewModel({
    required ModelOrId<Ledger> ledgerOrId,
    required LedgerRepository ledgerRepo,
  }) : _ledgerRepo = ledgerRepo {
    _loadLedger(ledgerOrId).then((_) {
      _ledgerRepo.getSharedEmails(ledger.id).then((emails) {
        sharedEmails.value = emails;
        isLoading.value = false;
      });
    });
  }

  void dispose() {
    isLoading.dispose();
  }

  Future<void> _loadLedger(ModelOrId<Ledger> ledgerOrId) async {
    if (ledgerOrId.hasModel) {
      ledger = ledgerOrId.model!;
      return;
    }

    ledger = await _ledgerRepo.getLedger(ledgerOrId.id);
  }

  Future<void> removeSharedEmail(String email) async {
    await _ledgerRepo.removeSharedEmail(ledger.id, email).then((_) {
      sharedEmails.value = [...sharedEmails.value..remove(email)];
    });
  }

  Future<void> addSharedEmail({
    required String email,
    required BuildContext context,
  }) async {
    await _ledgerRepo.addSharedEmail(ledger.id, email).then((_) {
      sharedEmails.value = [...sharedEmails.value..add(email)];
    })
        // .onError<PostgrestException>((e, _) {
        //   if (e.code == '23505') {
        //     if (!context.mounted) return;
        //     ScaffoldMessenger.of(context).showSnackBar(
        //       SnackBar(
        //         content: Text(tr('ledger_share_view.email_already_shared')),
        //       ),
        //     );
        //   } else {
        //     throw e;
        //   }
        // })
        .catchError((e, _) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(tr('generic_error_msg')),
        ),
      );
    });
  }
}
