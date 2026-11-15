import '../config/app_info.dart';

class LegalSection {
  const LegalSection(this.heading, this.paragraphs);

  final String heading;
  final List<String> paragraphs;
}

class LegalDocument {
  const LegalDocument({
    required this.id,
    required this.title,
    required this.summary,
    required this.sections,
  });

  final String id;
  final String title;
  final String summary;
  final List<LegalSection> sections;
}

/// Legal texts shown at first launch and available in Settings.
/// Increase [version] whenever a text changes: users must accept again.
abstract final class LegalDocuments {
  static const version = '1.0.0';
  static const lastUpdated = '3 November 2026';

  static const all = [terms, disclaimer, privacy, notice];

  static LegalDocument? byId(String id) {
    for (final d in all) {
      if (d.id == id) return d;
    }
    return null;
  }

  static const _school = AppInfo.school;
  static const _contact = AppInfo.contactEmail;
  static const _contactLine = _contact == ''
      ? 'You can contact the publisher through the app store page of Boussole.'
      : 'You can contact the publisher at $_contact.';

  // -------------------------------------------------------------------------
  static const terms = LegalDocument(
    id: 'terms',
    title: 'Terms of Use',
    summary: 'The rules for using Boussole.',
    sections: [
      LegalSection('1. Purpose and acceptance', [
        'These Terms of Use ("Terms") govern your use of the Boussole mobile application ("the App"), published by ${AppInfo.developer} ("the Publisher").',
        'By ticking the acceptance box and using the App, you agree to these Terms, to the Financial Disclaimer and to the Privacy Policy. If you do not agree, you must not use the App and should uninstall it.',
        'Last updated: $lastUpdated (version $version).',
      ]),
      LegalSection('2. What the App is', [
        'Boussole is an educational application. It helps beginners understand investment risk (price history, volatility, drops, holding period, emotional decisions) through quizzes and simulations built on historical market data.',
        'The App is free of charge. It does not sell, recommend or execute any financial product.',
      ]),
      LegalSection('2 bis. School project and the author\'s understanding', [
        AppInfo.schoolContext,
        AppInfo.authorNotice,
        'The App is not an official publication of $_school and does not engage its responsibility. The school name and logo are used only to indicate the academic context of the project.',
      ]),
      LegalSection('3. What the App is not', [
        'Boussole is not a bank, a broker, an investment firm, a trading platform, a payment service or a financial adviser. It is not authorised or supervised as such by any financial authority.',
        'No real transaction is possible. No bank account, card or broker account is requested or connected. All amounts, portfolios and results shown in simulations are fictional.',
      ]),
      LegalSection('4. Eligibility', [
        'The App is intended for adults (18 years or older). By accepting these Terms you confirm that you are at least 18 and have the legal capacity to accept them.',
      ]),
      LegalSection('5. Acceptable use', [
        'You agree to use the App for lawful, personal and non-commercial purposes only.',
        'You must not: reverse engineer, decompile or modify the App except where the law allows it; extract the data of the App in bulk or republish it; overload or disrupt the services the App relies on; use the App to give financial advice to third parties as if it came from a regulated professional.',
      ]),
      LegalSection('6. Third-party data', [
        'Market data (prices, exchange rates) is retrieved from third-party providers listed in the Settings screen and in the Privacy Policy. The Publisher does not control these providers, does not guarantee that the data is accurate, complete, up to date or continuously available, and is not responsible for any error, delay or interruption.',
        'Prices are raw closing prices. They are not adjusted for dividends or stock splits, which can understate or distort some performances. Historical crash data bundled in the App is a snapshot and may differ slightly from other sources.',
        'All trademarks, names and data belong to their respective owners. Their mention in the App does not imply any affiliation or endorsement.',
      ]),
      LegalSection('7. Intellectual property', [
        'The App, its source code, design, texts, logo and name are the property of ${AppInfo.developer}. ${AppInfo.copyright}',
        'You are granted a personal, non-exclusive, non-transferable, revocable licence to install and use the App on your devices, in accordance with these Terms. No other right is granted.',
      ]),
      LegalSection('8. No warranty', [
        'The App is provided "as is" and "as available", without warranty of any kind, express or implied, including accuracy, fitness for a particular purpose, availability, or absence of errors. Calculations (performance, volatility, maximum drawdown, probability of loss, simulation results) are simplified teaching models.',
      ]),
      LegalSection('9. Limitation of liability', [
        'To the maximum extent permitted by applicable law, the Publisher shall not be liable for any direct or indirect loss or damage arising from the use of, or the inability to use, the App, including any financial loss, loss of profit, loss of capital, loss of opportunity or loss of data, even if the Publisher was warned of the possibility of such loss.',
        'You are solely responsible for your own investment decisions. Nothing in the App should be relied upon to make them.',
        'Nothing in these Terms excludes or limits liability that cannot be excluded or limited by law, in particular liability for death or personal injury, for fraud or gross negligence, or the legal rights you hold as a consumer.',
      ]),
      LegalSection('10. Availability, changes and termination', [
        'The Publisher may modify, suspend or discontinue the App or any feature at any time, for instance if a data provider changes or stops its service.',
        'The Publisher may update these Terms. When a text changes materially, the App asks you to accept the new version before you continue. You can stop using the App at any time by uninstalling it.',
      ]),
      LegalSection('11. Governing law and disputes', [
        'These Terms are governed by French law. If you are a consumer, you keep the benefit of the mandatory consumer protection rules of your country of residence.',
        'In case of dispute, you are encouraged to contact the Publisher first to find an amicable solution. As a consumer, you may also use a consumer mediator or the European Online Dispute Resolution platform. Failing an amicable solution, the competent French courts have jurisdiction, subject to mandatory rules that give you the right to bring proceedings in your country of residence.',
        _contactLine,
      ]),
    ],
  );

  // -------------------------------------------------------------------------
  static const disclaimer = LegalDocument(
    id: 'disclaimer',
    title: 'Financial Disclaimer',
    summary: 'Informative only. Not advice. No liability for losses.',
    sections: [
      LegalSection('1. Information only', [
        'Boussole is provided for educational and informational purposes only. Nothing in the App constitutes investment advice, a personal recommendation, an offer, a solicitation or an invitation to buy, sell or hold any financial instrument (shares, ETFs, cryptocurrencies or others).',
        'The App does not take your personal situation, objectives, resources or risk tolerance into account.',
      ]),
      LegalSection('1 bis. The author\'s understanding', [
        AppInfo.authorNotice,
        'The explanations, indicators, simplified formulas and simulation rules of the App represent how the developer understood these topics. They are not the view of a financial professional, of a financial institution or of $_school.',
      ]),
      LegalSection('2. The past does not predict the future', [
        'Every indicator displayed (performance, volatility, maximum drawdown, recovery time, probability of loss, simulation results) describes what happened in the past on a limited period. It is not a forecast and gives no guarantee of future results.',
        'A low historical probability of loss does not mean that a loss cannot happen. Markets can fall further and for longer than they ever did in the data shown.',
      ]),
      LegalSection('3. Simulations are fictional', [
        'The Risk clock and the Panic button use virtual money and simplified rules (no fees, no taxes, no spread, no slippage, no liquidity constraints, weekly decisions at closing prices). Real life is different and usually less favourable.',
        'Your behaviour in a simulation is not a prediction of your behaviour with real money.',
      ]),
      LegalSection('4. Data based on third parties', [
        'The App relies on data retrieved from third-party APIs (see the data sources in Settings). That data may be late, incomplete, inaccurate or unavailable. Prices are raw and not adjusted for dividends or stock splits. Converted amounts (euro display) use historical exchange rates and are approximate.',
      ]),
      LegalSection('5. Risk warning', [
        'Investing involves risk, including the possible loss of all the capital invested. Cryptocurrencies are particularly volatile and speculative, and some investors lose their entire investment. Do not invest money you cannot afford to lose.',
        'Before any real investment, seek advice from a qualified and authorised professional and consult the official documents of the product concerned.',
      ]),
      LegalSection('6. No liability', [
        'The Publisher, ${AppInfo.developer}, is not responsible for any decision you take, or any loss you suffer, whether directly or indirectly related to the use of the App or to the information it displays. This includes, without limitation, any loss of money, capital, profit or opportunity.',
        'By using the App you acknowledge and accept that you act at your own risk and under your own responsibility.',
      ]),
    ],
  );

  // -------------------------------------------------------------------------
  static const privacy = LegalDocument(
    id: 'privacy',
    title: 'Privacy Policy (GDPR)',
    summary: 'What data the app handles, where it is stored, and your rights.',
    sections: [
      LegalSection('1. Data controller', [
        'The data controller is ${AppInfo.developer}, an individual publisher established in France. $_contactLine',
        'This policy complies with Regulation (EU) 2016/679 (General Data Protection Regulation, "GDPR") and the French Data Protection Act.',
      ]),
      LegalSection('2. Our approach in one sentence', [
        'Boussole has no account, no registration, no advertising, no analytics and no tracking. The Publisher does not operate any server that receives your data and does not collect your personal data.',
      ]),
      LegalSection('3. Data stored on your device', [
        'The following data is stored locally, in a database on your device only, so that the App works and can be used offline:',
        '• Your favourite assets.\n• Your saved simulations (Risk clock and Panic button results).\n• Your quiz score and daily streak.\n• Your preferences (theme, display currency).\n• The record of your acceptance of the legal documents (version and date).\n• A cache of downloaded market prices (not personal data).',
        'This data is not sent to the Publisher or to any third party. It is not linked to your identity. Purpose: provide the features you use (contract/legitimate interest under Article 6 GDPR). Retention: until you delete it in Settings or uninstall the App.',
      ]),
      LegalSection('4. Data exchanged with the data provider', [
        'To display market data, the App sends requests directly from your device to Yahoo Finance (query1.finance.yahoo.com). A request contains the ticker symbol requested (for example "AAPL" or "BTC-USD") and technical information inherent to any internet connection: your IP address, device and system type, and the time of the request.',
        'Yahoo acts as an independent controller for this technical data and applies its own privacy policy, available on its website. The Publisher has no access to these logs. The ticker symbols you request are not linked to your identity by the App.',
        'The App does not use any other online service. Your IP address may reveal your approximate location to that provider; you can use a VPN if you wish to avoid this.',
      ]),
      LegalSection('5. What we do not collect', [
        'We do not collect your name, email, phone number, contacts, precise location, photos, advertising identifier, banking or payment data, or any account information. The App does not use cookies, trackers or third-party analytics or advertising SDKs.',
      ]),
      LegalSection('6. Sharing and transfers', [
        'The Publisher does not sell, rent or share personal data. The only external recipient of technical data is the data provider named above, which may process it outside the European Economic Area under its own safeguards.',
      ]),
      LegalSection('7. Your rights', [
        'Under the GDPR you have the right of access, rectification, erasure, restriction, portability and objection, and the right to withdraw consent at any time. As the data is held only on your device, you can exercise these rights yourself:',
        '• Access and portability: the Saved screen lists your simulations.\n• Erasure: Settings > Storage > "Delete all my data" erases favourites, simulations, quiz progress, preferences, acceptance record and cached prices. Uninstalling the App also removes everything.\n• Withdrawing acceptance: delete your data in Settings; the App will ask you to accept again.',
        'If you consider that your rights are not respected, you may lodge a complaint with a supervisory authority, in France the CNIL (www.cnil.fr).',
      ]),
      LegalSection('8. Security', [
        'Data stays in the private storage of the App, protected by your device security. The Publisher cannot recover your data if you lose your device. You are responsible for securing your device.',
      ]),
      LegalSection('9. Children', [
        'The App is intended for adults and is not directed at children. The Publisher does not knowingly process data of minors.',
      ]),
      LegalSection('10. Changes', [
        'This policy may be updated, for example if a data provider changes. A material change is shown in the App and requires a new acceptance. Last updated: $lastUpdated (version $version).',
      ]),
    ],
  );

  // -------------------------------------------------------------------------
  static const notice = LegalDocument(
    id: 'notice',
    title: 'Legal Notice',
    summary: 'Who publishes the app, credits and copyright.',
    sections: [
      LegalSection('Publisher', [
        'Application: ${AppInfo.name} (version ${AppInfo.version}).\nPublisher and developer: ${AppInfo.developer}, individual, France.\nNature: free educational application developed as a school project, not a commercial activity.',
        _contactLine,
      ]),
      LegalSection('Academic context', [
        AppInfo.schoolContext,
        'The project was carried out for educational purposes. $_school is not the publisher of the App, did not review or endorse its content, and is not responsible for it. The $_school name and logo remain the property of the institution and are shown only to indicate the academic context.',
      ]),
      LegalSection('Hosting and distribution', [
        'The App runs on your device and is distributed through the application stores. The Publisher does not host any user data.',
      ]),
      LegalSection('Copyright', [
        AppInfo.copyright,
        'The name Boussole, the logo, the interface design, the texts and the source code are protected by copyright and may not be copied, modified or distributed without prior written permission of the author, except where the law allows it.',
      ]),
      LegalSection('Data sources and credits', [
        'Market data: Yahoo Finance (prices of stocks, ETFs and cryptocurrencies, USD/EUR exchange rate). Names, tickers and trademarks belong to their respective owners and are used for identification only.',
        'The App uses open-source software (Flutter, Dart and several packages) distributed under their own licences, which you can list from the licences screen of the App on your device.',
      ]),
      LegalSection('No financial services', [
        'The Publisher does not provide investment services, investment advice or crypto-asset services and is not registered as such. See the Financial Disclaimer.',
      ]),
    ],
  );
}
