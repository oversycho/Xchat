/// Wipes everything cached on the device (messages, drafts, ...). Called on sign-out
/// so the next person using the device cannot see the previous account's data.
abstract interface class LocalDataCleaner {
  Future<void> clear();
}
