import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  String get lang => locale.languageCode;

  // ==================== UI STRINGS ====================
  String get appTitle => _t('PetNutri', 'PetNutri');
  String get appSubtitle => _t('Pronadji najbolju hranu za ljubimca', 'Find the best food for your pet');
  String get whereToBuy => _t('Gde kupiti', 'Where to buy');
  String get symptomChecker => _t('Provera simptoma', 'Symptom Checker');
  String get healthConditions => _t('Zdravstvena stanja', 'Health Conditions');
  String get searchConditions => _t('Pretrazi bolesti...', 'Search conditions...');
  String get dietaryGuidelines => _t('Dijetetske smernice', 'Dietary Guidelines');
  String get treatmentAndTherapy => _t('Lecenje i terapija', 'Treatment & Therapy');
  String get recommendedTherapy => _t('Preporucena terapija', 'Recommended Therapy');
  String get searchFood => _t('Pretrazi hranu', 'Search Food');
  String searchFoodHint(String conditionName) =>
      _t('Ukucaj naziv hrane da vidis koliko je pogodna za ${conditionName.toLowerCase()}',
         'Type a food name to see how suitable it is for ${conditionName.toLowerCase()}');
  String get searchFoodPlaceholder => _t('npr. Royal Canin, Whiskas...', 'e.g. Royal Canin, Whiskas...');
  String get all => _t('Sve', 'All');
  String get recommended => _t('Preporuceno', 'Recommended');
  String get good => _t('Dobro', 'Good');
  String get average => _t('Prosecno', 'Average');
  String get avoid => _t('Izbegavaj', 'Avoid');
  String get noResultsForFilter => _t('Nema rezultata za izabrani filter.', 'No results for the selected filter.');
  String get errorLoading => _t('Greska pri ucitavanju. Proveri internet konekciju.', 'Error loading. Check your internet connection.');
  String get errorSearch => _t('Greska pri pretrazi. Proveri internet konekciju.', 'Search error. Check your internet connection.');
  String get searchFoodTitle => _t('Pretraži hranu...', 'Search food...');
  String get typeFoodName => _t('Ukucaj naziv hrane za ljubimce', 'Type a pet food name');
  String get noResults => _t('Nema rezultata', 'No results');
  String get unknownProduct => _t('Nepoznat proizvod', 'Unknown product');
  String get unknownBrand => _t('Nepoznat brend', 'Unknown brand');
  String get insufficientData => _t('Nedovoljno podataka za detaljnu ocenu', 'Insufficient data for detailed evaluation');
  String get notRecommended => _t('Ne preporucuje se', 'Not recommended');

  // Symptom checker
  String get markSymptoms => _t('Oznaci simptome koje primecujes kod svog ljubimca.', 'Mark the symptoms you notice in your pet.');
  String get searchSymptoms => _t('Pretrazi simptome...', 'Search symptoms...');
  String selectedSymptomsCount(int count) =>
      _t('Izabrani simptomi ($count):', 'Selected symptoms ($count):');
  String get possibleConditions => _t('💡 Moguca stanja:', '💡 Possible conditions:');
  String get basedOnSymptoms => _t('Na osnovu izabranih simptoma', 'Based on selected symptoms');
  String matchCount(int match, int total) =>
      _t('Poklapanje: $match/$total simptoma', 'Match: $match/$total symptoms');
  String get allSymptoms => _t('Svi simptomi:', 'All symptoms:');

  // Score labels
  String get highLabel => _t('↑ Visok', '↑ High');
  String get moderateLabel => _t('~ Umeren', '~ Moderate');
  String get lowLabel => _t('↓ Nizak', '↓ Low');
  String get avoidLabel => _t('✕ Izbegavaj', '✕ Avoid');

  // Food scorer
  String contains(String item) => _t('Sadrzi: $item', 'Contains: $item');
  String lowFat(String val) => _t('Nisko masti (${val}g/100g)', 'Low fat (${val}g/100g)');
  String highFat(String val) => _t('Visoko masti (${val}g/100g)', 'High fat (${val}g/100g)');
  String goodFatContent(String val) => _t('Dobar sadrzaj masti (${val}g/100g)', 'Good fat content (${val}g/100g)');
  String highProtein(String val) => _t('Visok protein (${val}g/100g)', 'High protein (${val}g/100g)');
  String moderateProtein(String val) => _t('Umeren protein (${val}g/100g)', 'Moderate protein (${val}g/100g)');
  String tooMuchProtein(String val) => _t('Previse proteina (${val}g/100g)', 'Too much protein (${val}g/100g)');
  String goodFiber(String val) => _t('Dobra vlakna (${val}g/100g)', 'Good fiber (${val}g/100g)');
  String lowSalt(String val) => _t('Nisko soli (${val}g/100g)', 'Low salt (${val}g/100g)');
  String tooMuchSalt(String val) => _t('Previse soli (${val}g/100g)', 'Too much salt (${val}g/100g)');
  String lowCalorie(String val) => _t('Niskokaloricno ($val kcal/100g)', 'Low calorie ($val kcal/100g)');
  String highCalorie(String val) => _t('Visokokaloricno ($val kcal/100g)', 'High calorie ($val kcal/100g)');

  // Pet types
  String get dogs => _t('🐕 Psi', '🐕 Dogs');
  String get cats => _t('🐈 Macke', '🐈 Cats');
  String get rabbits => _t('🐇 Zecevi i kunici', '🐇 Rabbits');
  String get rodents => _t('🐹 Glodari', '🐹 Rodents');
  String get birds => _t('🐦 Ptice', '🐦 Birds');
  String get terrarium => _t('🦎 Teraristika', '🦎 Terrarium');
  String get aquarium => _t('🐟 Akvaristika', '🐟 Aquarium');

  String get language => _t('Jezik', 'Language');

  // Vet finder
  String get findVet => _t('Pronadji veterinara', 'Find a Vet');
  String get findVetNearby => _t('Pronadji veterinara u blizini', 'Find a vet nearby');
  String get findVetDesc => _t('Koristi tvoju lokaciju da pronadje najblize veterinarske ambulante', 'Uses your location to find the nearest veterinary clinics');
  String get locationLoading => _t('Ucitavanje lokacije...', 'Loading location...');
  String get locationError => _t('Nije moguce dobiti lokaciju. Dozvoli pristup lokaciji u browseru.', 'Could not get location. Allow location access in your browser.');

  // Shop search
  String get shopSearch => _t('Pretraga prodavnica', 'Shop Search');
  String get scrollForMore => _t('Skroluj za vise', 'Scroll for more');

  String _t(String sr, String en) => locale.languageCode == 'en' ? en : sr;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['sr', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async => AppLocalizations(locale);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
