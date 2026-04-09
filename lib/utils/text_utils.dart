/// Normalizuje srpski tekst — uklanja kvačiće sa slova
/// tako da "č", "ć", "š", "ž", "đ" postaju "c", "c", "s", "z", "d".
String normalizeSerbian(String text) {
  return text
      .replaceAll('č', 'c').replaceAll('Č', 'C')
      .replaceAll('ć', 'c').replaceAll('Ć', 'C')
      .replaceAll('š', 's').replaceAll('Š', 'S')
      .replaceAll('ž', 'z').replaceAll('Ž', 'Z')
      .replaceAll('đ', 'd').replaceAll('Đ', 'D');
}

/// Proverava da li [text] sadrži [query], ignorišući kvačiće i veličinu slova.
bool containsNormalized(String text, String query) {
  return normalizeSerbian(text.toLowerCase())
      .contains(normalizeSerbian(query.toLowerCase()));
}
