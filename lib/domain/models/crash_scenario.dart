/// A historical market crash replayed week by week in the Panic Button.
class CrashScenario {
  const CrashScenario({
    required this.id,
    required this.title,
    required this.assetName,
    required this.file,
    required this.story,
  });

  final String id;
  final String title;
  final String assetName;

  /// Weekly closes bundled in `assets/data/`.
  final String file;
  final String story;
}

const crashScenarios = [
  CrashScenario(
    id: 'covid2020',
    title: 'Covid crash 2020',
    assetName: 'S&P 500 (SPY)',
    file: 'crash_covid_2020.json',
    story:
        'February 2020: markets are at record highs. Within five weeks, '
        'the pandemic wipes out over a third of their value.',
  ),
  CrashScenario(
    id: 'gfc2008',
    title: 'Financial crisis 2008',
    assetName: 'S&P 500 (SPY)',
    file: 'crash_gfc_2008.json',
    story:
        'October 2007: stocks peak. Banks collapse, Lehman Brothers fails, '
        'and the market falls by more than half over 17 months.',
  ),
  CrashScenario(
    id: 'dotcom2000',
    title: 'Dot-com bubble 2000',
    assetName: 'Nasdaq 100 (QQQ)',
    file: 'crash_dotcom_2000.json',
    story:
        'March 2000: internet stocks are booming. The bubble bursts and '
        'the Nasdaq loses about 80 % in under three years.',
  ),
  CrashScenario(
    id: 'crypto2018',
    title: 'Crypto winter 2018',
    assetName: 'Bitcoin (BTC)',
    file: 'crash_crypto_2018.json',
    story:
        'December 2017: Bitcoin nears \$20,000 and everybody talks about it. '
        'One year later, it has lost more than 80 %.',
  ),
  CrashScenario(
    id: 'crypto2022',
    title: 'Crypto winter 2022',
    assetName: 'Bitcoin (BTC)',
    file: 'crash_crypto_2022.json',
    story:
        'November 2021: Bitcoin trades near its all-time high. Over the next '
        'year, rate hikes and failures across the industry cut its price by three quarters.',
  ),
  CrashScenario(
    id: 'tariffs2025',
    title: 'Tariff shock 2025',
    assetName: 'S&P 500 (SPY)',
    file: 'crash_tariff_2025.json',
    story:
        'February 2025: new trade tariffs shake the markets. The S&P 500 '
        'drops about 19 % in weeks, then rebounds just as fast.',
  ),
];
