// Generates the GitHub Pages site (docs/site) from the in-app legal texts.
// Run: dart run tool/generate_legal_site.dart
import 'dart:io';

import 'package:boussole/core/config/app_info.dart';
import 'package:boussole/core/legal/legal_documents.dart';

String esc(String s) => s
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;');

const css = '''
:root{--navy:#0F1F44;--blue:#0A6CFF;--bg:#F5F7FC}
*{box-sizing:border-box}
body{margin:0;font-family:-apple-system,"Segoe UI",Roboto,sans-serif;background:var(--bg);color:var(--navy);line-height:1.65}
header{background:linear-gradient(135deg,#0A6CFF,#0E9AA7,#2DB36B);color:#fff;padding:2rem 1rem}
header .in,main,footer{max-width:780px;margin:0 auto;padding:0 1rem}
header h1{margin:0;font-size:1.8rem}header p{margin:.3rem 0 0;opacity:.9}
nav{background:#fff;border-bottom:1px solid #dde3f0;position:sticky;top:0}
nav .in{max-width:780px;margin:0 auto;padding:.6rem 1rem;display:flex;flex-wrap:wrap;gap:1rem}
nav a{color:var(--navy);text-decoration:none;font-weight:600;font-size:.95rem}
nav a:hover,nav a.on{color:var(--blue)}
main{padding-top:1.5rem;padding-bottom:2rem}
section{background:#fff;border-radius:14px;padding:1rem 1.3rem;margin:1rem 0;box-shadow:0 1px 3px rgba(15,31,68,.08)}
h2{font-size:1.1rem;margin:.2rem 0 .6rem}
.card{display:block;text-decoration:none;color:inherit;background:#fff;border-radius:14px;padding:1rem 1.3rem;margin:.8rem 0;box-shadow:0 1px 3px rgba(15,31,68,.08)}
.card:hover{box-shadow:0 2px 8px rgba(10,108,255,.25)}
.card b{color:var(--blue)}
.warn{border-left:5px solid #F5A524}
footer{padding-bottom:2rem;font-size:.85rem;opacity:.75}
''';

String page(String title, String body, String active) {
  final links = [
    ('index.html', 'Home', 'home'),
    for (final d in LegalDocuments.all) ('${d.id}.html', d.title, d.id),
  ];
  final nav = links
      .map((l) =>
          '<a href="${l.$1}"${l.$3 == active ? ' class="on"' : ''}>${esc(l.$2)}</a>')
      .join();
  return '''<!DOCTYPE html>
<html lang="en"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>${esc(title)} – ${AppInfo.name}</title>
<link rel="stylesheet" href="style.css"></head><body>
<header><div class="in"><h1>${esc(title)}</h1><p>${AppInfo.name} · version ${LegalDocuments.version} · last updated ${LegalDocuments.lastUpdated}</p></div></header>
<nav><div class="in">$nav</div></nav>
<main>$body</main>
<footer>${esc(AppInfo.copyright)}</footer>
</body></html>
''';
}

String para(String p) => '<p>${esc(p).replaceAll('\n', '<br>')}</p>';

void main() {
  final out = Directory('docs/site')..createSync(recursive: true);
  File('${out.path}/style.css').writeAsStringSync(css);
  File('${out.path}/.nojekyll').writeAsStringSync('');

  for (final d in LegalDocuments.all) {
    final body = StringBuffer();
    for (final s in d.sections) {
      body.write('<section><h2>${esc(s.heading)}</h2>');
      for (final p in s.paragraphs) {
        body.write(para(p));
      }
      body.write('</section>');
    }
    File('${out.path}/${d.id}.html')
        .writeAsStringSync(page(d.title, body.toString(), d.id));
  }

  final cards = LegalDocuments.all
      .map((d) =>
          '<a class="card" href="${d.id}.html"><b>${esc(d.title)}</b><br>${esc(d.summary)}</a>')
      .join();
  final home = '''
<section class="warn"><h2>Educational app only</h2>
${para('Boussole helps beginners understand investment risk with real market data and simulations. It is not a bank, a broker or a financial adviser, it gives no investment advice, and no real transaction is possible.')}</section>
<section><h2>About</h2>${para(AppInfo.schoolContext)}${para(AppInfo.authorNotice)}</section>
<h2 style="margin-top:1.5rem">Legal documents</h2>$cards
<section><h2>Privacy in short</h2>${para('No account, no advertising, no analytics, no tracking. Your data stays on your device. The only online service used is Yahoo Finance for market prices.')}</section>
''';
  File('${out.path}/index.html')
      .writeAsStringSync(page('${AppInfo.name} – Legal', home, 'home'));
  stdout.writeln('Site generated in ${out.path}');
}
