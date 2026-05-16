import 'package:flutter_test/flutter_test.dart';
import 'package:finku_mobile/src/core/l10n/app_locale.dart';
import 'package:finku_mobile/src/core/l10n/l10n_bundle.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('loads Indonesian and English nav strings', () async {
    final id = await L10nBundle.load(AppLocale.id);
    final en = await L10nBundle.load(AppLocale.en);

    expect(id.t('nav', 'transactions'), 'Transaksi');
    expect(en.t('nav', 'transactions'), 'Transactions');
    expect(id.t('nav', 'addTransaction'), 'Tambah transaksi');
    expect(en.t('nav', 'addTransaction'), 'Add transaction');
  });

  test('interpolates profile languageChanged args', () async {
    final en = await L10nBundle.load(AppLocale.en);
    final text = en.t(
      'profile',
      'languageChanged',
      args: {'language': en.t('profile', 'languageEn')},
    );
    expect(text, contains('English'));
  });
}
