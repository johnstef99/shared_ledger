import 'package:shared_ledger/models/contact_model.dart';
import 'package:shared_ledger/models/transaction_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show SupabaseClient;

class TransactionsRepository {
  final SupabaseClient _supabase;

  TransactionsRepository({
    required SupabaseClient supabase,
  }) : _supabase = supabase;

  static const _selectQuery = '''
    id,
    ledger_id,
    contact: contact_id (id, user_uid, email, name, phone_number),
    amount,
    comment,
    created_at,
    transaction_at
  ''';

  Future<List<Transaction>> getTransactions(int ledgerId) async {
    final response = await _supabase
        .from('transactions')
        .select(_selectQuery)
        .eq('ledger_id', ledgerId)
        .order('transaction_at', ascending: false)
        .withConverter((trans) {
      return trans.map(Transaction.fromJson);
    });

    return response.toList();
  }

  Future<void> deleteTransaction(Transaction transaction) async {
    await _supabase.from('transactions').delete().eq('id', transaction.id);
  }

  Future<Transaction> updateTransaction(Transaction transaction) async {
    final data = await _supabase
        .from('transactions')
        .update({
          'contact_id': transaction.contact?.id,
          'amount': transaction.amount,
          'comment': transaction.comment,
          'transaction_at': transaction.transactionAt.toUtc().toIso8601String(),
        })
        .eq('id', transaction.id)
        .select(_selectQuery)
        .then((data) => Transaction.fromJson(data.first));

    return data;
  }

  Future<Transaction> createTransaction({
    required int ledgerId,
    required Contact contact,
    required double amount,
    required String? comment,
    required DateTime transactionAt,
  }) async {
    return await _supabase
        .from('transactions')
        .insert({
          'ledger_id': ledgerId,
          'contact_id': contact.id,
          'amount': amount,
          'comment': comment,
          'transaction_at': transactionAt.toUtc().toIso8601String(),
        })
        .select(_selectQuery)
        .then((data) => Transaction.fromJson(data.first));
  }

  Future<Transaction> getTransaction(int transactionId) async {
    final data = await _supabase
        .from('transactions')
        .select(_selectQuery)
        .eq('id', transactionId)
        .then((data) => Transaction.fromJson(data.first));

    return data;
  }
}
