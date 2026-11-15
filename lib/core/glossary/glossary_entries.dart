/// Plain-English definitions of the jargon used in the app.
class GlossaryEntry {
  const GlossaryEntry({
    required this.id,
    required this.term,
    required this.definition,
    required this.inBoussole,
    required this.category,
  });

  /// Stable identifier, usable in links (`/glossary?term=buy-more`).
  final String id;
  final String term;
  final String definition;

  /// How the concept appears in the app.
  final String inBoussole;
  final GlossaryCategory category;
}

enum GlossaryCategory {
  assets('Assets'),
  risk('Reading risk'),
  panic('Panic button'),
  data('Data and numbers');

  const GlossaryCategory(this.label);
  final String label;
}

abstract final class Glossary {
  static GlossaryEntry? byId(String? id) {
    for (final e in entries) {
      if (e.id == id) return e;
    }
    return null;
  }

  static const entries = [
    // ---- Assets -----------------------------------------------------------
    GlossaryEntry(
      id: 'stock',
      term: 'Stock (share)',
      category: GlossaryCategory.assets,
      definition:
          'A small piece of ownership of one company. If the company does well, the price tends to rise; if it does badly, it falls. You depend on a single business.',
      inBoussole: 'Apple, Microsoft or Tesla in the catalog.',
    ),
    GlossaryEntry(
      id: 'etf',
      term: 'ETF',
      category: GlossaryCategory.assets,
      definition:
          'A fund traded like a stock that holds many assets at once (hundreds of companies, bonds, gold…). It spreads the risk: one company failing barely moves it.',
      inBoussole: 'SPY (500 US companies), VT (the whole world), AGG (bonds).',
    ),
    GlossaryEntry(
      id: 'crypto',
      term: 'Cryptocurrency',
      category: GlossaryCategory.assets,
      definition:
          'A digital asset that exists on a blockchain. Prices swing a lot, can fall by more than half in months, and there is no company or authority behind most of them.',
      inBoussole: 'Bitcoin, Ethereum, Solana… shown against the US dollar.',
    ),
    GlossaryEntry(
      id: 'diversification',
      term: 'Diversification',
      category: GlossaryCategory.assets,
      definition:
          'Not putting all your eggs in one basket: spreading money across many assets so that one bad performer does not ruin everything.',
      inBoussole:
          'Compare a single stock with an ETF on their sheets: the ETF curve is usually calmer.',
    ),
    GlossaryEntry(
      id: 'bond',
      term: 'Bond',
      category: GlossaryCategory.assets,
      definition:
          'A loan you make to a state or a company, which pays you interest. Usually calmer than stocks, with lower expected gains, but its price can still fall.',
      inBoussole: 'The AGG ETF holds US bonds.',
    ),

    // ---- Reading risk ---------------------------------------------------------
    GlossaryEntry(
      id: 'performance',
      term: 'Performance (return)',
      category: GlossaryCategory.risk,
      definition:
          'How much the value changed, in percent: (final value - initial value) / initial value × 100. 100 becoming 120 is +20 %.',
      inBoussole: 'Shown on every asset sheet for the selected period.',
    ),
    GlossaryEntry(
      id: 'volatility',
      term: 'Volatility',
      category: GlossaryCategory.risk,
      definition:
          'How much the price jumps around. A high volatility means big ups and downs, so a bumpier ride. It is measured here as the spread of the returns, scaled to one year.',
      inBoussole:
          'Below 12 % is low, above 45 % is very high. Bitcoin is usually far above a bond ETF.',
    ),
    GlossaryEntry(
      id: 'drawdown',
      term: 'Worst drop (maximum drawdown)',
      category: GlossaryCategory.risk,
      definition:
          'The biggest fall from a peak to the lowest point after it. Example: 100 → 125 → 90 gives (90 - 125) / 125 = -28 %. It shows what you would have lived through if you had bought at the worst moment.',
      inBoussole:
          '"Worst drop" on asset sheets, quiz answers and Panic results.',
    ),
    GlossaryEntry(
      id: 'recovery-time',
      term: 'Recovery time',
      category: GlossaryCategory.risk,
      definition:
          'How long it takes to get back to the previous peak after a fall. Some falls heal in weeks, others in years, and some never.',
      inBoussole: '"Time to recover" at the end of a Panic simulation.',
    ),
    GlossaryEntry(
      id: 'holding-period',
      term: 'Holding period (horizon)',
      category: GlossaryCategory.risk,
      definition:
          'How long you stay invested before selling. The longer it is, the less likely it is that you end up with a loss, although it is never impossible.',
      inBoussole: 'The slider of the Risk clock (1 month to 10 years).',
    ),
    GlossaryEntry(
      id: 'loss-probability',
      term: 'Chance of loss',
      category: GlossaryCategory.risk,
      definition:
          'In the past, out of all the possible start dates, the share of cases where the price N months later was lower than at the start. It describes history, not the future.',
      inBoussole: 'The big percentage and the bars of the Risk clock.',
    ),
    GlossaryEntry(
      id: 'rolling-window',
      term: 'Rolling period',
      category: GlossaryCategory.risk,
      definition:
          'Every possible start date is tried, one after another, for the same duration. With 10 years of history and a 1-year holding period, there are about 470 weekly start dates.',
      inBoussole: '"Based on 471 rolling periods" under the Risk clock result.',
    ),
    GlossaryEntry(
      id: 'risk-level',
      term: 'Risk level',
      category: GlossaryCategory.risk,
      definition:
          'A simple label (low, moderate, high, very high) based on volatility over the period shown. It changes with the period because markets are calmer or wilder at different times. It is a teaching label, not an official rating.',
      inBoussole: 'The coloured badge on asset sheets and quiz answers.',
    ),

    // ---- Panic button -----------------------------------------------------------
    GlossaryEntry(
      id: 'hold',
      term: 'Hold',
      category: GlossaryCategory.panic,
      definition:
          'Do nothing: keep what you own and let the week pass. Long-term investors often hold through falls because markets have recovered from past crashes, though never with certainty.',
      inBoussole: 'The calm choice. Holding every week equals "doing nothing".',
    ),
    GlossaryEntry(
      id: 'stay-in-cash',
      term: 'Stay in cash',
      category: GlossaryCategory.panic,
      definition:
          'After selling everything, you keep your money as cash. It cannot fall with the market, but it cannot rise with it either: you miss any rebound.',
      inBoussole:
          'When you are out of the market, the "Hold" choice becomes "Stay in cash".',
    ),
    GlossaryEntry(
      id: 'sell-all',
      term: 'Sell all',
      category: GlossaryCategory.panic,
      definition:
          'Turn everything into cash at this week\'s price. It stops further losses, but makes the loss real ("locked in") and you must decide when to come back.',
      inBoussole: 'Panic selling often happens near the bottom.',
    ),
    GlossaryEntry(
      id: 'buy-more',
      term: 'Buy more',
      category: GlossaryCategory.panic,
      definition:
          'Add new money to your investment at the current price. When the price is low you get more units for the same money, which lowers your average buying price (also called "buying the dip" or averaging down). It is not safe: prices can keep falling.',
      inBoussole:
          'You choose the amount (fictional money). It counts in "invested", and results are compared as percentages.',
    ),
    GlossaryEntry(
      id: 'buy-back',
      term: 'Buy back',
      category: GlossaryCategory.panic,
      definition:
          'Reinvest all your cash after having sold. If the price is higher than when you sold, you lost the difference.',
      inBoussole: 'Only offered when you are out of the market.',
    ),
    GlossaryEntry(
      id: 'doing-nothing',
      term: 'Doing nothing (baseline)',
      category: GlossaryCategory.panic,
      definition:
          'The reference result: you invest your starting amount at the beginning and never touch it. Your decisions are judged against it.',
      inBoussole:
          'The grey curve at the end. Returns (%) are compared, because adding money changes how much you invested.',
    ),
    GlossaryEntry(
      id: 'market-peak',
      term: 'Market peak',
      category: GlossaryCategory.panic,
      definition:
          'The highest price reached before a fall. Falls are measured from there.',
      inBoussole: '"Market vs peak" during a Panic simulation.',
    ),
    GlossaryEntry(
      id: 'loss-aversion',
      term: 'Loss aversion',
      category: GlossaryCategory.panic,
      definition:
          'A human bias: the pain of losing money is felt about twice as strongly as the joy of gaining the same amount. It pushes people to sell in panic.',
      inBoussole: 'The lesson shown after a Panic simulation where you sold.',
    ),
    GlossaryEntry(
      id: 'market-timing',
      term: 'Market timing',
      category: GlossaryCategory.panic,
      definition:
          'Trying to sell just before a fall and buy just before a rise. Almost nobody manages it consistently, because both moments are only obvious afterwards.',
      inBoussole: 'Selling then buying back is a form of market timing.',
    ),
    GlossaryEntry(
      id: 'crash',
      term: 'Crash',
      category: GlossaryCategory.panic,
      definition:
          'A sharp and deep fall of markets, often triggered by a shock (a crisis, a bubble bursting, a pandemic). A common rule of thumb is a drop of 20 % or more.',
      inBoussole: 'Six real crashes are replayed week by week.',
    ),

    // ---- Data and numbers ------------------------------------------------------
    GlossaryEntry(
      id: 'closing-price',
      term: 'Closing price',
      category: GlossaryCategory.data,
      definition:
          'The last price of a trading period (a day or a week). Boussole only uses closing prices.',
      inBoussole: 'Every curve is a series of closing prices.',
    ),
    GlossaryEntry(
      id: 'raw-prices',
      term: 'Raw vs adjusted prices',
      category: GlossaryCategory.data,
      definition:
          'Raw prices ignore dividends (money paid to owners) and stock splits (a share cut into several). Adjusted prices include them. With raw prices, some performances look lower than reality.',
      inBoussole:
          'Boussole uses raw prices, so performances can be understated.',
    ),
    GlossaryEntry(
      id: 'rebased',
      term: 'Rebased to 100',
      category: GlossaryCategory.data,
      definition:
          'Curves are scaled so that they start at 100. That makes assets with very different prices comparable: 130 means +30 %.',
      inBoussole: 'The mystery curve of the quiz.',
    ),
    GlossaryEntry(
      id: 'exchange-rate',
      term: 'Exchange rate (EUR/USD)',
      category: GlossaryCategory.data,
      definition:
          'The price of one currency in another. A US asset gains or loses in euros both from its own price and from the dollar moving against the euro.',
      inBoussole:
          'Euro display converts sheet prices. The quiz and the Risk clock stay in US dollars.',
    ),
    GlossaryEntry(
      id: 'past-not-future',
      term: 'The past is not the future',
      category: GlossaryCategory.data,
      definition:
          'Every figure in the app describes what happened. Markets can do things they never did before. Use the numbers to understand risk, never to predict.',
      inBoussole: 'Reminded next to every indicator.',
    ),
  ];
}
