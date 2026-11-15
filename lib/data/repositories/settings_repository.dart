import '../local/user_store.dart';

enum DisplayCurrency { usd, eur }

class AppSettings {
  const AppSettings({
    this.themeMode = 'system',
    this.currency = DisplayCurrency.usd,
  });

  final String themeMode; // system | light | dark
  final DisplayCurrency currency;

  AppSettings copyWith({String? themeMode, DisplayCurrency? currency}) =>
      AppSettings(
        themeMode: themeMode ?? this.themeMode,
        currency: currency ?? this.currency,
      );
}

/// Record of the user's acceptance of the legal documents.
class LegalAcceptance {
  const LegalAcceptance({this.version, this.acceptedAt});

  final String? version;
  final DateTime? acceptedAt;
}

class SettingsRepository {
  SettingsRepository(this._store);

  final UserStore _store;

  Future<AppSettings> load() async {
    final p = await _store.readPreferences();
    return AppSettings(
      themeMode: p['themeMode'] ?? 'system',
      currency: p['currency'] == 'eur'
          ? DisplayCurrency.eur
          : DisplayCurrency.usd,
    );
  }

  Future<void> save(AppSettings s) async {
    await _store.writePreference('themeMode', s.themeMode);
    await _store.writePreference('currency', s.currency.name);
  }

  Future<LegalAcceptance> loadLegal() async {
    final p = await _store.readPreferences();
    return LegalAcceptance(
      version: p['legalVersion'],
      acceptedAt: DateTime.tryParse(p['legalAcceptedAt'] ?? ''),
    );
  }

  Future<LegalAcceptance> acceptLegal(String version) async {
    final now = DateTime.now();
    await _store.writePreference('legalVersion', version);
    await _store.writePreference('legalAcceptedAt', now.toIso8601String());
    return LegalAcceptance(version: version, acceptedAt: now);
  }

  Future<void> deleteAllUserData() => _store.deleteAllUserData();
}
