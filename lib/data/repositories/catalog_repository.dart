import 'dart:convert';

import 'package:flutter/services.dart';

import '../../domain/models/asset.dart';

/// The 30 starter instruments, bundled in assets (no network at startup).
class CatalogRepository {
  CatalogRepository({AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;

  final AssetBundle _bundle;

  Future<List<Asset>> load() async {
    final raw = await _bundle.loadString('assets/data/catalog.json');
    return [
      for (final j in jsonDecode(raw) as List)
        Asset.fromJson(j as Map<String, dynamic>),
    ];
  }

  /// Weekly real history of a past crash, bundled for the Panic Button.
  Future<List<List<dynamic>>> loadCrash(String file) async {
    final raw = await _bundle.loadString('assets/data/$file');
    return (jsonDecode(raw) as List).cast<List<dynamic>>();
  }
}
