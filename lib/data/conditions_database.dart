/// Veterinarski dijetetski vodici za cesta stanja kod kucnih ljubimaca.

enum PetType { dog, cat, poultry, pigeon, parrot }

String petTypeLabel(PetType type) {
  switch (type) {
    case PetType.dog: return '🐕 Pas';
    case PetType.cat: return '🐈 Macka';
    case PetType.poultry: return '🐔 Zivina';
    case PetType.pigeon: return '🕊️ Golub';
    case PetType.parrot: return '🦜 Papagaj';
  }
}

class DietaryGuideline {
  final String nutrient;
  final String recommendation;
  final String reason;

  const DietaryGuideline({
    required this.nutrient,
    required this.recommendation,
    required this.reason,
  });
}

class PetCondition {
  final String id;
  final String name;
  final String description;
  final List<PetType> affectedSpecies;
  final String icon;
  final List<String> symptoms;
  final List<DietaryGuideline> guidelines;
  final List<String> goodIngredients;
  final List<String> badIngredients;

  const PetCondition({
    required this.id,
    required this.name,
    required this.description,
    required this.affectedSpecies,
    required this.icon,
    required this.symptoms,
    required this.guidelines,
    required this.goodIngredients,
    required this.badIngredients,
  });
}

List<PetCondition> findConditionsBySymptoms(
    List<String> selectedSymptoms, PetType petType) {
  if (selectedSymptoms.isEmpty) return [];
  final matches = <MapEntry<PetCondition, int>>[];
  for (final condition in conditionsDatabase) {
    if (!condition.affectedSpecies.contains(petType)) continue;
    int matchCount = 0;
    for (final symptom in condition.symptoms) {
      if (selectedSymptoms.any((s) => symptom == s)) matchCount++;
    }
    if (matchCount > 0) matches.add(MapEntry(condition, matchCount));
  }
  matches.sort((a, b) => b.value.compareTo(a.value));
  return matches.map((m) => m.key).toList();
}

List<String> getAllSymptoms(PetType petType) {
  final symptoms = <String>{};
  for (final condition in conditionsDatabase) {
    if (condition.affectedSpecies.contains(petType)) {
      symptoms.addAll(condition.symptoms);
    }
  }
  final list = symptoms.toList()..sort();
  return list;
}

const List<PetCondition> conditionsDatabase = [
  // ==================== PSI I MACKE ====================
  PetCondition(
    id: 'hepatitis',
    name: 'Hepatitis',
    description: 'Upala jetre — potrebna dijeta sa smanjenim opterecenjem za jetru.',
    affectedSpecies: [PetType.dog, PetType.cat],
    icon: '🫁',
    symptoms: ['Gubitak apetita', 'Povracanje', 'Zutica (zuta boja koze i ociju)', 'Letargija i slabost', 'Povecan unos vode', 'Tamna mokraca', 'Nadut stomak', 'Gubitak tezine'],
    guidelines: [
      DietaryGuideline(nutrient: 'Proteini', recommendation: 'moderate', reason: 'Visokokvalitetni, lako svarljivi proteini u umerenoj kolicini.'),
      DietaryGuideline(nutrient: 'Masti', recommendation: 'low', reason: 'Smanjene masti rasterecuju jetru.'),
      DietaryGuideline(nutrient: 'Bakar', recommendation: 'avoid', reason: 'Bakar se akumulira u ostecenoj jetri.'),
      DietaryGuideline(nutrient: 'Vlakna', recommendation: 'moderate', reason: 'Pomaze u vezivanju toksina u crevima.'),
      DietaryGuideline(nutrient: 'Antioksidansi', recommendation: 'high', reason: 'Vitamin E i C stite celije jetre.'),
    ],
    goodIngredients: ['piletina', 'curetina', 'pirinac', 'jaja', 'svezi sir', 'vitamin e', 'vitamin c', 'omega 3'],
    badIngredients: ['bakar', 'jetra', 'dzigerica', 'nusproizvod', 'kukuruz', 'psenica'],
  ),
  PetCondition(
    id: 'kidney_disease',
    name: 'Bubrezna bolest',
    description: 'Hronicna bubrezna insuficijencija — smanjen unos fosfora i proteina.',
    affectedSpecies: [PetType.dog, PetType.cat],
    icon: '🫘',
    symptoms: ['Pojacano mokrenje', 'Pojacana zedj', 'Gubitak apetita', 'Povracanje', 'Gubitak tezine', 'Los zadah (miris na amonijak)', 'Letargija', 'Dehidracija', 'Bledilo desni'],
    guidelines: [
      DietaryGuideline(nutrient: 'Proteini', recommendation: 'low', reason: 'Smanjeni proteini da se ne opterete bubrezi.'),
      DietaryGuideline(nutrient: 'Fosfor', recommendation: 'avoid', reason: 'Fosfor pogorsava bubreznu funkciju.'),
      DietaryGuideline(nutrient: 'Natrijum', recommendation: 'low', reason: 'Nizak natrijum pomaze kontrolu krvnog pritiska.'),
      DietaryGuideline(nutrient: 'Omega-3', recommendation: 'high', reason: 'Smanjuje upalu u bubrezima.'),
    ],
    goodIngredients: ['jaja', 'omega 3', 'riblje ulje', 'pirinac', 'batat'],
    badIngredients: ['fosfor', 'kostano brasno', 'so', 'natrijum', 'nusproizvod'],
  ),
  PetCondition(
    id: 'diabetes',
    name: 'Dijabetes',
    description: 'Secerna bolest — potrebna hrana sa niskim glikemijskim indeksom.',
    affectedSpecies: [PetType.dog, PetType.cat],
    icon: '💉',
    symptoms: ['Pojacana zedj', 'Ucestalo mokrenje', 'Pojacan apetit uz gubitak tezine', 'Letargija', 'Zamucen vid', 'Sporo zarastanje rana', 'Ceste infekcije', 'Sladak miris daha'],
    guidelines: [
      DietaryGuideline(nutrient: 'Ugljeni hidrati', recommendation: 'low', reason: 'Nizak GI sprecava skokove secera u krvi.'),
      DietaryGuideline(nutrient: 'Proteini', recommendation: 'high', reason: 'Visok protein pomaze stabilizaciju glukoze.'),
      DietaryGuideline(nutrient: 'Vlakna', recommendation: 'high', reason: 'Vlakna usporavaju apsorpciju secera.'),
    ],
    goodIngredients: ['piletina', 'curetina', 'riba', 'vlakna', 'bundeva', 'boranija'],
    badIngredients: ['secer', 'kukuruzni sirup', 'psenica', 'kukuruz', 'beli pirinac'],
  ),
  PetCondition(
    id: 'pancreatitis',
    name: 'Pankreatitis',
    description: 'Upala pankreasa — strogo niskomasna dijeta.',
    affectedSpecies: [PetType.dog, PetType.cat],
    icon: '🔥',
    symptoms: ['Jak bol u stomaku', 'Povracanje', 'Proliv', 'Gubitak apetita', 'Dehidracija', 'Letargija', 'Grbljenje ledja (kod pasa)', 'Povisena temperatura'],
    guidelines: [
      DietaryGuideline(nutrient: 'Masti', recommendation: 'avoid', reason: 'Masti su glavni okidac pankreatitisa.'),
      DietaryGuideline(nutrient: 'Proteini', recommendation: 'moderate', reason: 'Lako svarljivi proteini u umerenoj kolicini.'),
      DietaryGuideline(nutrient: 'Vlakna', recommendation: 'moderate', reason: 'Pomaze probavi bez opterecenja pankreasa.'),
    ],
    goodIngredients: ['pileca prsa', 'curetina', 'pirinac', 'bundeva', 'batat'],
    badIngredients: ['mast', 'ulje', 'puter', 'loj', 'slanina'],
  ),
  PetCondition(
    id: 'allergies',
    name: 'Alergije na hranu',
    description: 'Preosetljivost na odredjene sastojke — eliminaciona dijeta.',
    affectedSpecies: [PetType.dog, PetType.cat],
    icon: '🤧',
    symptoms: ['Svrab koze', 'Crvenilo i osip', 'Cesanje usiju', 'Lizanje sapa', 'Proliv ili mek stolica', 'Povracanje', 'Gubitak dlake', 'Hronicne upale usiju'],
    guidelines: [
      DietaryGuideline(nutrient: 'Proteini', recommendation: 'moderate', reason: 'Koristiti nove proteine (jagnjetina, divljac, riba).'),
      DietaryGuideline(nutrient: 'Zitarice', recommendation: 'avoid', reason: 'Cesti alergeni — izbegavati psenicu, kukuruz, soju.'),
    ],
    goodIngredients: ['jagnjetina', 'divljac', 'losos', 'pacetina', 'batat', 'grasak'],
    badIngredients: ['psenica', 'kukuruz', 'soja', 'govedina', 'mlecni proizvodi', 'vestacki dodaci'],
  ),
  PetCondition(
    id: 'obesity',
    name: 'Gojaznost',
    description: 'Prekomerna tezina — niskokaloricna dijeta bogata vlaknima.',
    affectedSpecies: [PetType.dog, PetType.cat],
    icon: '⚖️',
    symptoms: ['Vidljiv visak kilograma', 'Tesko disanje pri naporu', 'Smanjena aktivnost', 'Otezano kretanje', 'Ne mogu se napipati rebra', 'Brzo zamaranje', 'Hramanje (opterecenje zglobova)'],
    guidelines: [
      DietaryGuideline(nutrient: 'Kalorije', recommendation: 'low', reason: 'Smanjen kalorijski unos za gubitak tezine.'),
      DietaryGuideline(nutrient: 'Vlakna', recommendation: 'high', reason: 'Vlakna daju osecaj sitosti.'),
      DietaryGuideline(nutrient: 'Proteini', recommendation: 'high', reason: 'Visok protein cuva misicnu masu tokom mrsavljenja.'),
    ],
    goodIngredients: ['piletina', 'curetina', 'vlakna', 'boranija', 'bundeva', 'sargarepa'],
    badIngredients: ['mast', 'secer', 'kukuruzni sirup', 'nusproizvod'],
  ),
  PetCondition(
    id: 'urinary',
    name: 'Urinarni problemi',
    description: 'Kristali/kamenci u mokracnim putevima — kontrola pH i minerala.',
    affectedSpecies: [PetType.dog, PetType.cat],
    icon: '💧',
    symptoms: ['Bolno mokrenje', 'Krv u mokraci', 'Ucestalo mokrenje u malim kolicinama', 'Mokrenje van posude/napolju', 'Lizanje genitalnog podrucja', 'Naprezanje pri mokrenju', 'Nemogucnost mokrenja (hitno!)'],
    guidelines: [
      DietaryGuideline(nutrient: 'Magnezijum', recommendation: 'low', reason: 'Visak magnezijuma doprinosi formiranju kristala.'),
      DietaryGuideline(nutrient: 'Fosfor', recommendation: 'low', reason: 'Kontrola fosfora smanjuje rizik od kamenaca.'),
      DietaryGuideline(nutrient: 'Vlaga', recommendation: 'high', reason: 'Mokra hrana pomaze razblazienju urina.'),
    ],
    goodIngredients: ['piletina', 'riba', 'vlazna hrana', 'brusnica'],
    badIngredients: ['magnezijum', 'pepeo', 'fosfor', 'so'],
  ),
  PetCondition(
    id: 'heart_disease',
    name: 'Srcana bolest',
    description: 'Oboljenje srca — smanjen natrijum i podrska srcanom misicu.',
    affectedSpecies: [PetType.dog, PetType.cat],
    icon: '❤️',
    symptoms: ['Kasalj (narocito nocu)', 'Tesko disanje', 'Brzo zamaranje', 'Smanjena aktivnost', 'Gubitak apetita', 'Nadut stomak (tecnost)', 'Plavicaste desni', 'Nesvestica'],
    guidelines: [
      DietaryGuideline(nutrient: 'Natrijum', recommendation: 'low', reason: 'Nizak natrijum smanjuje zadrzavanje tecnosti.'),
      DietaryGuideline(nutrient: 'Taurin', recommendation: 'high', reason: 'Taurin je kljucan za funkciju srcanog misica.'),
      DietaryGuideline(nutrient: 'Omega-3', recommendation: 'high', reason: 'Smanjuje upalu i podrzava srce.'),
    ],
    goodIngredients: ['riba', 'losos', 'taurin', 'omega 3', 'riblje ulje', 'piletina'],
    badIngredients: ['so', 'natrijum', 'slanina', 'preradjeno meso'],
  ),
  PetCondition(
    id: 'arthritis',
    name: 'Artritis',
    description: 'Upala zglobova — antiinflamatorna dijeta sa podrskom hrskavici.',
    affectedSpecies: [PetType.dog, PetType.cat],
    icon: '🦴',
    symptoms: ['Hramanje', 'Ukocenost posle odmora', 'Otezano ustajanje', 'Smanjena aktivnost', 'Bolni zglobovi na dodir', 'Oteceni zglobovi', 'Lizanje bolnih mesta', 'Odbijanje skakanja ili penjanja'],
    guidelines: [
      DietaryGuideline(nutrient: 'Omega-3', recommendation: 'high', reason: 'Snazno antiinflamatorno dejstvo na zglobove.'),
      DietaryGuideline(nutrient: 'Glukozamin', recommendation: 'high', reason: 'Podrzava obnovu hrskavice.'),
      DietaryGuideline(nutrient: 'Kalorije', recommendation: 'low', reason: 'Odrzavanje idealne tezine smanjuje opterecenje zglobova.'),
    ],
    goodIngredients: ['losos', 'riblje ulje', 'omega 3', 'glukozamin', 'hondroitin', 'kurkuma'],
    badIngredients: ['secer', 'kukuruz', 'psenica', 'nusproizvod'],
  ),
  PetCondition(
    id: 'ibd',
    name: 'Upalna bolest creva (IBD)',
    description: 'Hronicna upala digestivnog trakta — lako svarljiva dijeta.',
    affectedSpecies: [PetType.dog, PetType.cat],
    icon: '🩺',
    symptoms: ['Hronican proliv', 'Povracanje', 'Gubitak tezine', 'Gubitak apetita', 'Krv ili sluz u stolici', 'Nadimanje i gasovi', 'Bolovi u stomaku', 'Lose stanje dlake'],
    guidelines: [
      DietaryGuideline(nutrient: 'Proteini', recommendation: 'moderate', reason: 'Hidrolizovani ili novi proteini smanjuju reakciju creva.'),
      DietaryGuideline(nutrient: 'Masti', recommendation: 'low', reason: 'Niske masti su lakse za varenje.'),
      DietaryGuideline(nutrient: 'Probiotici', recommendation: 'high', reason: 'Podrzavaju zdravu crevnu floru.'),
    ],
    goodIngredients: ['piletina', 'curetina', 'pirinac', 'bundeva', 'probiotici', 'prebiotici'],
    badIngredients: ['psenica', 'kukuruz', 'soja', 'mlecni proizvodi', 'vestacki dodaci'],
  ),
  PetCondition(
    id: 'hypothyroidism',
    name: 'Hipotireoza',
    description: 'Smanjena funkcija stitne zlezde — dijeta za metabolizam i tezinu.',
    affectedSpecies: [PetType.dog],
    icon: '🦋',
    symptoms: ['Debljanje bez povecanog apetita', 'Letargija i pospanost', 'Gubitak dlake', 'Suva i ljuspasta koza', 'Osetljivost na hladnocu', 'Spor puls', 'Tamna pigmentacija koze', 'Ceste kozne infekcije'],
    guidelines: [
      DietaryGuideline(nutrient: 'Kalorije', recommendation: 'low', reason: 'Spor metabolizam zahteva manje kalorija.'),
      DietaryGuideline(nutrient: 'Proteini', recommendation: 'high', reason: 'Visok protein podrzava metabolizam.'),
      DietaryGuideline(nutrient: 'Omega-3', recommendation: 'high', reason: 'Pomaze zdravlju koze i dlake.'),
    ],
    goodIngredients: ['riba', 'piletina', 'omega 3', 'riblje ulje', 'batat', 'boranija'],
    badIngredients: ['secer', 'kukuruzni sirup', 'mast', 'nusproizvod'],
  ),
  PetCondition(
    id: 'hyperthyroidism',
    name: 'Hipertireoza',
    description: 'Pojacana funkcija stitne zlezde — kontrola joda i kalorija.',
    affectedSpecies: [PetType.cat],
    icon: '⚡',
    symptoms: ['Gubitak tezine uz pojacan apetit', 'Pojacana zedj i mokrenje', 'Hiperaktivnost i nemir', 'Povracanje', 'Proliv', 'Lose stanje dlake', 'Ubrzan puls', 'Agresivnost ili promena ponasanja'],
    guidelines: [
      DietaryGuideline(nutrient: 'Jod', recommendation: 'avoid', reason: 'Ogranicenje joda smanjuje proizvodnju hormona.'),
      DietaryGuideline(nutrient: 'Kalorije', recommendation: 'high', reason: 'Potrebno nadoknaditi gubitak tezine.'),
      DietaryGuideline(nutrient: 'Proteini', recommendation: 'high', reason: 'Visok protein za ocuvanje misicne mase.'),
    ],
    goodIngredients: ['piletina', 'curetina', 'jaja', 'pirinac'],
    badIngredients: ['riba', 'morski plodovi', 'alge', 'jod'],
  ),
  PetCondition(
    id: 'dental_disease',
    name: 'Bolesti zuba i desni',
    description: 'Parodontalna bolest — dijeta koja podrzava oralno zdravlje.',
    affectedSpecies: [PetType.dog, PetType.cat],
    icon: '🦷',
    symptoms: ['Los zadah', 'Crvenilo i otecenost desni', 'Krvarenje desni', 'Otezano zvakanje', 'Gubitak apetita', 'Ispustanje hrane iz usta', 'Curenje pljuvacke', 'Labavi ili izgubljeni zubi'],
    guidelines: [
      DietaryGuideline(nutrient: 'Tekstura hrane', recommendation: 'high', reason: 'Suva hrana pomaze mehanickom ciscenju zuba.'),
      DietaryGuideline(nutrient: 'Kalcijum', recommendation: 'moderate', reason: 'Podrzava zdravlje kostiju i zuba.'),
      DietaryGuideline(nutrient: 'Vitamin C', recommendation: 'high', reason: 'Pomaze zdravlju desni i zarastanju.'),
    ],
    goodIngredients: ['piletina', 'riba', 'vitamin c', 'kalcijum', 'suva hrana'],
    badIngredients: ['secer', 'meka lepljiva hrana', 'kukuruzni sirup'],
  ),
  PetCondition(
    id: 'skin_issues',
    name: 'Kozni problemi',
    description: 'Dermatitis i problemi sa dlakom — dijeta bogata masnim kiselinama.',
    affectedSpecies: [PetType.dog, PetType.cat],
    icon: '🐾',
    symptoms: ['Svrab i cesanje', 'Suva i ljuspasta koza', 'Gubitak dlake', 'Crvenilo koze', 'Masna ili smrdljiva koza', 'Ceste kozne infekcije', 'Perut', 'Lizanje i grickanje koze'],
    guidelines: [
      DietaryGuideline(nutrient: 'Omega-3', recommendation: 'high', reason: 'Esencijalne masne kiseline za zdravu kozu i dlaku.'),
      DietaryGuideline(nutrient: 'Cink', recommendation: 'high', reason: 'Cink je kljucan za obnovu koze.'),
      DietaryGuideline(nutrient: 'Biotin', recommendation: 'high', reason: 'Podrzava rast zdrave dlake.'),
    ],
    goodIngredients: ['losos', 'riblje ulje', 'omega 3', 'cink', 'biotin', 'jaja'],
    badIngredients: ['vestacki dodaci', 'boje', 'kukuruz', 'soja'],
  ),
  PetCondition(
    id: 'gastritis',
    name: 'Gastritis',
    description: 'Upala zeluca — blaga, lako svarljiva dijeta.',
    affectedSpecies: [PetType.dog, PetType.cat],
    icon: '🤢',
    symptoms: ['Povracanje', 'Gubitak apetita', 'Bol u stomaku', 'Letargija', 'Dehidracija', 'Jedenje trave (kod pasa)', 'Podrigivanje', 'Crna stolica (krvarenje)'],
    guidelines: [
      DietaryGuideline(nutrient: 'Masti', recommendation: 'low', reason: 'Niske masti su lakse za zeludac.'),
      DietaryGuideline(nutrient: 'Proteini', recommendation: 'moderate', reason: 'Lako svarljivi proteini u manjim obrocima.'),
    ],
    goodIngredients: ['piletina', 'pirinac', 'bundeva', 'batat', 'kuvana jaja'],
    badIngredients: ['mast', 'zacini', 'vestacki dodaci', 'mlecni proizvodi', 'masna hrana'],
  ),
  PetCondition(
    id: 'epilepsy',
    name: 'Epilepsija',
    description: 'Neuroloski poremecaj sa napadima — dijeta sa MCT uljima.',
    affectedSpecies: [PetType.dog, PetType.cat],
    icon: '🧠',
    symptoms: ['Napadi (konvulzije)', 'Gubitak svesti', 'Nekontrolisano drhtanje', 'Curenje pljuvacke', 'Dezorijentisanost posle napada', 'Ukocenost tela', 'Nekontrolisano mokrenje', 'Nemir pre napada'],
    guidelines: [
      DietaryGuideline(nutrient: 'MCT ulja', recommendation: 'high', reason: 'Srednje-lancane masne kiseline mogu smanjiti ucestalost napada.'),
      DietaryGuideline(nutrient: 'Omega-3', recommendation: 'high', reason: 'Neuroprotektivno dejstvo.'),
      DietaryGuideline(nutrient: 'Antioksidansi', recommendation: 'high', reason: 'Stite nervne celije od ostecenja.'),
    ],
    goodIngredients: ['kokosovo ulje', 'MCT ulje', 'riblje ulje', 'omega 3', 'vitamin e', 'piletina'],
    badIngredients: ['vestacki dodaci', 'boje', 'konzervansi', 'secer', 'glutamat'],
  ),
  PetCondition(
    id: 'anemia',
    name: 'Anemija',
    description: 'Smanjen broj crvenih krvnih zrnaca — dijeta bogata gvozdjem.',
    affectedSpecies: [PetType.dog, PetType.cat],
    icon: '🩸',
    symptoms: ['Blede desni', 'Letargija i slabost', 'Brzo zamaranje', 'Ubrzan puls', 'Tesko disanje', 'Gubitak apetita', 'Gubitak tezine', 'Hladni ekstremiteti'],
    guidelines: [
      DietaryGuideline(nutrient: 'Gvozdje', recommendation: 'high', reason: 'Gvozdje je neophodno za proizvodnju crvenih krvnih zrnaca.'),
      DietaryGuideline(nutrient: 'Vitamin B12', recommendation: 'high', reason: 'B12 podrzava stvaranje krvnih celija.'),
      DietaryGuideline(nutrient: 'Proteini', recommendation: 'high', reason: 'Visokokvalitetni proteini za oporavak.'),
    ],
    goodIngredients: ['govedina', 'jetra', 'jaja', 'spanac', 'riba', 'vitamin b12'],
    badIngredients: ['nusproizvod', 'vestacki dodaci'],
  ),
  PetCondition(
    id: 'cushing',
    name: 'Kusingov sindrom',
    description: 'Visak kortizola — dijeta za kontrolu tezine i metabolizma.',
    affectedSpecies: [PetType.dog],
    icon: '💊',
    symptoms: ['Pojacana zedj i mokrenje', 'Pojacan apetit', 'Nadut stomak', 'Gubitak dlake (simetricno)', 'Tanka koza', 'Letargija', 'Ceste kozne infekcije', 'Misicna slabost'],
    guidelines: [
      DietaryGuideline(nutrient: 'Kalorije', recommendation: 'low', reason: 'Kontrola tezine je kljucna.'),
      DietaryGuideline(nutrient: 'Proteini', recommendation: 'high', reason: 'Visok protein za ocuvanje misicne mase.'),
      DietaryGuideline(nutrient: 'Vlakna', recommendation: 'high', reason: 'Vlakna pomazu osecaju sitosti.'),
    ],
    goodIngredients: ['piletina', 'curetina', 'vlakna', 'boranija', 'bundeva', 'sargarepa'],
    badIngredients: ['mast', 'secer', 'kukuruzni sirup', 'nusproizvod'],
  ),
  PetCondition(
    id: 'constipation',
    name: 'Zatvor',
    description: 'Otezano praznjenje creva — dijeta bogata vlaknima i vodom.',
    affectedSpecies: [PetType.dog, PetType.cat],
    icon: '🚫',
    symptoms: ['Retko praznjenje creva', 'Naprezanje pri defekaciji', 'Tvrda i suva stolica', 'Gubitak apetita', 'Bol u stomaku', 'Letargija', 'Povracanje', 'Nadimanje'],
    guidelines: [
      DietaryGuideline(nutrient: 'Vlakna', recommendation: 'high', reason: 'Vlakna stimulisu rad creva.'),
      DietaryGuideline(nutrient: 'Vlaga', recommendation: 'high', reason: 'Mokra hrana pomaze hidrataciji stolice.'),
      DietaryGuideline(nutrient: 'Probiotici', recommendation: 'high', reason: 'Podrzavaju zdravu crevnu floru.'),
    ],
    goodIngredients: ['bundeva', 'vlakna', 'vlazna hrana', 'probiotici', 'laneno seme', 'sargarepa'],
    badIngredients: ['kosti', 'suva hrana (iskljucivo)', 'pirinac'],
  ),
  // ==================== ZIVINA ====================
  PetCondition(
    id: 'newcastle',
    name: 'Njukasl bolest',
    description: 'Virusna bolest koja napada respiratorni, nervni i digestivni sistem.',
    affectedSpecies: [PetType.poultry, PetType.pigeon],
    icon: '🦠',
    symptoms: ['Kijanje i kasalj', 'Otezano disanje', 'Zelenkasti proliv', 'Pad nosivosti jaja', 'Uvijanje vrata', 'Paraliza krila i nogu', 'Otecenost glave', 'Iznenadna smrt'],
    guidelines: [
      DietaryGuideline(nutrient: 'Proteini', recommendation: 'high', reason: 'Visok protein podrzava imuni sistem.'),
      DietaryGuideline(nutrient: 'Vitamin E', recommendation: 'high', reason: 'Antioksidans koji jaca imunitet.'),
      DietaryGuideline(nutrient: 'Elektroliti', recommendation: 'high', reason: 'Nadoknada tecnosti zbog proliva.'),
    ],
    goodIngredients: ['vitamin e', 'elektroliti', 'probiotici', 'visokoproteinska hrana'],
    badIngredients: ['plesniva hrana', 'kontaminirana voda'],
  ),
  PetCondition(
    id: 'coccidiosis_poultry',
    name: 'Kokcidioza',
    description: 'Parazitska infekcija creva — cesta kod mladih pilica.',
    affectedSpecies: [PetType.poultry, PetType.pigeon],
    icon: '🔬',
    symptoms: ['Krvav proliv', 'Gubitak apetita', 'Gubitak tezine', 'Nakostresen perje', 'Letargija', 'Dehidracija', 'Blede kreste i podbradak', 'Pad nosivosti'],
    guidelines: [
      DietaryGuideline(nutrient: 'Vitamin A', recommendation: 'high', reason: 'Pomaze oporavku crevne sluznice.'),
      DietaryGuideline(nutrient: 'Vitamin K', recommendation: 'high', reason: 'Pomaze zaustavljanju krvarenja u crevima.'),
      DietaryGuideline(nutrient: 'Probiotici', recommendation: 'high', reason: 'Obnavljaju zdravu crevnu floru.'),
    ],
    goodIngredients: ['vitamin a', 'vitamin k', 'probiotici', 'elektroliti', 'jogurt'],
    badIngredients: ['plesniva hrana', 'vlazna prostirka'],
  ),
  PetCondition(
    id: 'avian_influenza',
    name: 'Pticji grip',
    description: 'Visoko patogeni virus influence — izuzetno opasna bolest.',
    affectedSpecies: [PetType.poultry, PetType.pigeon, PetType.parrot],
    icon: '⚠️',
    symptoms: ['Iznenadna smrt', 'Pad nosivosti jaja', 'Otecenost glave i ociju', 'Plavicaste kreste i podbradak', 'Otezano disanje', 'Vodenast proliv', 'Letargija', 'Krvarenja na nogama'],
    guidelines: [
      DietaryGuideline(nutrient: 'Vitamin C', recommendation: 'high', reason: 'Podrzava imuni odgovor.'),
      DietaryGuideline(nutrient: 'Selen', recommendation: 'high', reason: 'Antioksidans koji stiti celije.'),
      DietaryGuideline(nutrient: 'Proteini', recommendation: 'high', reason: 'Podrzava oporavak organizma.'),
    ],
    goodIngredients: ['vitamin c', 'selen', 'vitamin e', 'elektroliti'],
    badIngredients: ['kontaminirana hrana', 'sirova jaja'],
  ),
  PetCondition(
    id: 'infectious_bronchitis',
    name: 'Infektivni bronhitis',
    description: 'Virusna respiratorna bolest — cesta kod kokosi.',
    affectedSpecies: [PetType.poultry],
    icon: '🫁',
    symptoms: ['Kasalj i kijanje', 'Hropci pri disanju', 'Curenje iz nosa', 'Suzenje ociju', 'Pad nosivosti jaja', 'Deformisana jaja (meka ljuska)', 'Smanjen unos hrane', 'Letargija'],
    guidelines: [
      DietaryGuideline(nutrient: 'Vitamin A', recommendation: 'high', reason: 'Stiti sluznice respiratornog trakta.'),
      DietaryGuideline(nutrient: 'Elektroliti', recommendation: 'high', reason: 'Sprecava dehidraciju.'),
      DietaryGuideline(nutrient: 'Proteini', recommendation: 'high', reason: 'Podrzava oporavak tkiva.'),
    ],
    goodIngredients: ['vitamin a', 'elektroliti', 'probiotici', 'topla voda'],
    badIngredients: ['prasnjava hrana', 'plesniva hrana'],
  ),
  PetCondition(
    id: 'marek',
    name: 'Marekova bolest',
    description: 'Virusna bolest koja izaziva tumore i paralizu kod pilica.',
    affectedSpecies: [PetType.poultry],
    icon: '🧬',
    symptoms: ['Paraliza nogu i krila', 'Gubitak tezine', 'Siva boja ociju (promena zenice)', 'Tumori na kozi', 'Otezano disanje', 'Proliv', 'Smanjena nosivost', 'Iznenadna smrt mladih pilica'],
    guidelines: [
      DietaryGuideline(nutrient: 'Antioksidansi', recommendation: 'high', reason: 'Podrzavaju imuni sistem.'),
      DietaryGuideline(nutrient: 'Proteini', recommendation: 'high', reason: 'Pomazu oporavku organizma.'),
      DietaryGuideline(nutrient: 'Vitamin E', recommendation: 'high', reason: 'Stiti celije od ostecenja.'),
    ],
    goodIngredients: ['vitamin e', 'selen', 'visokoproteinska hrana', 'zeleno povrce'],
    badIngredients: ['plesniva hrana', 'niskokvalitetna hrana'],
  ),
  PetCondition(
    id: 'egg_binding',
    name: 'Zastoj jajeta',
    description: 'Nemogucnost polaganja jajeta — hitno stanje.',
    affectedSpecies: [PetType.poultry, PetType.parrot, PetType.pigeon],
    icon: '🥚',
    symptoms: ['Naprezanje bez polaganja jajeta', 'Nadut stomak', 'Letargija', 'Gubitak apetita', 'Otezano hodanje', 'Sedenje na podu', 'Tesko disanje', 'Izlazak tkiva iz kloake'],
    guidelines: [
      DietaryGuideline(nutrient: 'Kalcijum', recommendation: 'high', reason: 'Kalcijum je kljucan za formiranje ljuske i kontrakcije.'),
      DietaryGuideline(nutrient: 'Vitamin D3', recommendation: 'high', reason: 'Pomaze apsorpciju kalcijuma.'),
      DietaryGuideline(nutrient: 'Vlaga', recommendation: 'high', reason: 'Hidratacija pomaze polaganju.'),
    ],
    goodIngredients: ['kalcijum', 'vitamin d3', 'ljuske jaja (mlevene)', 'zeleno povrce'],
    badIngredients: ['niskokaloricna hrana', 'hrana bez kalcijuma'],
  ),
  PetCondition(
    id: 'bumblefoot',
    name: 'Pododermatitis (Bumblefoot)',
    description: 'Bakterijska infekcija stopala — cesta kod zivine.',
    affectedSpecies: [PetType.poultry, PetType.pigeon],
    icon: '🦶',
    symptoms: ['Hramanje', 'Otecenost stopala', 'Crna krasta na tabanu', 'Toplota na mestu infekcije', 'Odbijanje hodanja', 'Sedenje na mestu', 'Gubitak apetita', 'Letargija'],
    guidelines: [
      DietaryGuideline(nutrient: 'Vitamin A', recommendation: 'high', reason: 'Podrzava zdravlje koze i zarastanje.'),
      DietaryGuideline(nutrient: 'Proteini', recommendation: 'high', reason: 'Potrebni za oporavak tkiva.'),
      DietaryGuideline(nutrient: 'Cink', recommendation: 'high', reason: 'Pomaze zarastanju rana.'),
    ],
    goodIngredients: ['vitamin a', 'cink', 'proteini', 'zeleno povrce'],
    badIngredients: ['niskokvalitetna hrana'],
  ),
  // ==================== GOLUBOVI ====================
  PetCondition(
    id: 'paramyxovirus',
    name: 'Paramiksoviroza (PMV)',
    description: 'Virusna bolest nervnog sistema — cesta kod golubova.',
    affectedSpecies: [PetType.pigeon],
    icon: '🦠',
    symptoms: ['Uvijanje vrata', 'Kruzenje u mestu', 'Gubitak ravnoteze', 'Vodenast zeleni proliv', 'Gubitak tezine', 'Nemogucnost letenja', 'Drhtanje glave', 'Paraliza'],
    guidelines: [
      DietaryGuideline(nutrient: 'Elektroliti', recommendation: 'high', reason: 'Nadoknada tecnosti zbog proliva.'),
      DietaryGuideline(nutrient: 'Vitamin B', recommendation: 'high', reason: 'Podrzava nervni sistem.'),
      DietaryGuideline(nutrient: 'Proteini', recommendation: 'high', reason: 'Pomaze oporavku organizma.'),
    ],
    goodIngredients: ['elektroliti', 'vitamin b kompleks', 'probiotici', 'lako svarljivo seme'],
    badIngredients: ['kontaminirana voda', 'plesnivo seme'],
  ),
  PetCondition(
    id: 'canker',
    name: 'Trihomonijaza (Canker)',
    description: 'Parazitska infekcija grla i voljke — najcesca bolest golubova.',
    affectedSpecies: [PetType.pigeon, PetType.parrot],
    icon: '🟡',
    symptoms: ['Zuckaste naslage u grlu', 'Otezano gutanje', 'Gubitak apetita', 'Gubitak tezine', 'Smrdljiv dah', 'Nakostresen perje', 'Povracanje', 'Curenje iz kljuna'],
    guidelines: [
      DietaryGuideline(nutrient: 'Vitamin A', recommendation: 'high', reason: 'Stiti sluznice grla i voljke.'),
      DietaryGuideline(nutrient: 'Probiotici', recommendation: 'high', reason: 'Obnavljaju zdravu floru.'),
      DietaryGuideline(nutrient: 'Meka hrana', recommendation: 'high', reason: 'Lakse za gutanje tokom bolesti.'),
    ],
    goodIngredients: ['vitamin a', 'probiotici', 'meko seme', 'sargarepa', 'zeleno povrce'],
    badIngredients: ['tvrdo seme', 'kontaminirana voda'],
  ),
  PetCondition(
    id: 'pigeon_salmonella',
    name: 'Salmoneloza (Paratifus)',
    description: 'Bakterijska infekcija — napada zglobove, creva i organe.',
    affectedSpecies: [PetType.pigeon, PetType.poultry],
    icon: '🦠',
    symptoms: ['Zelenkast vodenast proliv', 'Oteceni zglobovi', 'Hramanje', 'Gubitak tezine', 'Nakostresen perje', 'Neplodnost', 'Mrtvi embrioni u jajima', 'Letargija'],
    guidelines: [
      DietaryGuideline(nutrient: 'Probiotici', recommendation: 'high', reason: 'Pomazu obnovi crevne flore.'),
      DietaryGuideline(nutrient: 'Elektroliti', recommendation: 'high', reason: 'Nadoknada tecnosti.'),
      DietaryGuideline(nutrient: 'Vitamin E', recommendation: 'high', reason: 'Podrzava imunitet.'),
    ],
    goodIngredients: ['probiotici', 'elektroliti', 'vitamin e', 'cist pirinac'],
    badIngredients: ['kontaminirana hrana', 'kontaminirana voda', 'plesnivo seme'],
  ),
  PetCondition(
    id: 'pigeon_worms',
    name: 'Crvi (Helmintijaza)',
    description: 'Parazitska infekcija creva — cesta kod golubova u volijerama.',
    affectedSpecies: [PetType.pigeon, PetType.poultry, PetType.parrot],
    icon: '🪱',
    symptoms: ['Gubitak tezine', 'Proliv', 'Nakostresen perje', 'Smanjen apetit', 'Lose stanje perja', 'Letargija', 'Vidljivi crvi u izmetu', 'Anemija (blede sluznice)'],
    guidelines: [
      DietaryGuideline(nutrient: 'Vitamin A', recommendation: 'high', reason: 'Pomaze oporavku crevne sluznice.'),
      DietaryGuideline(nutrient: 'Gvozdje', recommendation: 'high', reason: 'Nadoknada zbog anemije.'),
      DietaryGuideline(nutrient: 'Probiotici', recommendation: 'high', reason: 'Obnova crevne flore posle lecenja.'),
    ],
    goodIngredients: ['vitamin a', 'gvozdje', 'probiotici', 'beli luk (u malim kolicinama)'],
    badIngredients: ['kontaminirana hrana', 'neociscena voda'],
  ),
  PetCondition(
    id: 'ornithosis',
    name: 'Ornitoza (Hlamidija)',
    description: 'Bakterijska infekcija respiratornog sistema — prenosiva na ljude.',
    affectedSpecies: [PetType.pigeon, PetType.parrot, PetType.poultry],
    icon: '😷',
    symptoms: ['Curenje iz nosa', 'Suzenje ociju', 'Otezano disanje', 'Kijanje', 'Zelenkast proliv', 'Gubitak apetita', 'Nakostresen perje', 'Letargija'],
    guidelines: [
      DietaryGuideline(nutrient: 'Vitamin A', recommendation: 'high', reason: 'Stiti respiratorne sluznice.'),
      DietaryGuideline(nutrient: 'Vitamin C', recommendation: 'high', reason: 'Podrzava imuni odgovor.'),
      DietaryGuideline(nutrient: 'Proteini', recommendation: 'high', reason: 'Pomaze oporavku.'),
    ],
    goodIngredients: ['vitamin a', 'vitamin c', 'probiotici', 'zeleno povrce'],
    badIngredients: ['prasnjava hrana', 'plesniva hrana'],
  ),
  // ==================== PAPAGAJI ====================
  PetCondition(
    id: 'pbfd',
    name: 'PBFD (Bolest perja i kljuna)',
    description: 'Virusna bolest koja napada perje, kljun i imuni sistem papagaja.',
    affectedSpecies: [PetType.parrot],
    icon: '🪶',
    symptoms: ['Gubitak perja', 'Deformisano perje', 'Deformisan kljun', 'Lomljiv kljun', 'Kozne lezije', 'Ceste infekcije', 'Gubitak tezine', 'Letargija'],
    guidelines: [
      DietaryGuideline(nutrient: 'Vitamin A', recommendation: 'high', reason: 'Kljucan za zdravlje koze i perja.'),
      DietaryGuideline(nutrient: 'Proteini', recommendation: 'high', reason: 'Podrzava rast perja.'),
      DietaryGuideline(nutrient: 'Antioksidansi', recommendation: 'high', reason: 'Podrzavaju oslabljen imuni sistem.'),
    ],
    goodIngredients: ['vitamin a', 'sargarepa', 'batat', 'brokoli', 'spanac', 'jaja'],
    badIngredients: ['secer', 'masna hrana', 'vestacki dodaci'],
  ),
  PetCondition(
    id: 'psittacosis',
    name: 'Psitakoza (Papagajska groznica)',
    description: 'Bakterijska infekcija — prenosiva na ljude, izaziva respiratorne probleme.',
    affectedSpecies: [PetType.parrot, PetType.pigeon],
    icon: '🤒',
    symptoms: ['Otezano disanje', 'Curenje iz nosa i ociju', 'Zelenkast proliv', 'Nakostresen perje', 'Letargija', 'Gubitak apetita', 'Drhtanje', 'Gubitak tezine'],
    guidelines: [
      DietaryGuideline(nutrient: 'Vitamin A', recommendation: 'high', reason: 'Stiti respiratorne sluznice.'),
      DietaryGuideline(nutrient: 'Probiotici', recommendation: 'high', reason: 'Podrzavaju crevnu floru tokom lecenja antibioticima.'),
      DietaryGuideline(nutrient: 'Elektroliti', recommendation: 'high', reason: 'Sprecava dehidraciju.'),
    ],
    goodIngredients: ['vitamin a', 'probiotici', 'elektroliti', 'svezo voce', 'povrce'],
    badIngredients: ['secer', 'vestacki dodaci', 'plesniva hrana'],
  ),
  PetCondition(
    id: 'aspergillosis',
    name: 'Aspergiloza',
    description: 'Gljivicna infekcija respiratornog sistema — cesta kod papagaja.',
    affectedSpecies: [PetType.parrot, PetType.pigeon, PetType.poultry],
    icon: '🍄',
    symptoms: ['Otezano disanje', 'Hropci i zvizdanje', 'Gubitak glasa', 'Gubitak apetita', 'Gubitak tezine', 'Letargija', 'Promena boje izmeta', 'Nakostresen perje'],
    guidelines: [
      DietaryGuideline(nutrient: 'Vitamin A', recommendation: 'high', reason: 'Stiti respiratorne sluznice od gljivica.'),
      DietaryGuideline(nutrient: 'Antioksidansi', recommendation: 'high', reason: 'Podrzavaju imuni odgovor.'),
      DietaryGuideline(nutrient: 'Proteini', recommendation: 'high', reason: 'Pomaze oporavku organizma.'),
    ],
    goodIngredients: ['vitamin a', 'sargarepa', 'brokoli', 'paprika', 'svezo voce'],
    badIngredients: ['plesniva hrana', 'plesnivo seme', 'prasnjava hrana'],
  ),
  PetCondition(
    id: 'feather_plucking',
    name: 'Cupanje perja',
    description: 'Samopovredjivanje — cesto uzrokovano stresom ili losim ishranom.',
    affectedSpecies: [PetType.parrot],
    icon: '😰',
    symptoms: ['Cupanje sopstvenog perja', 'Ogoljene zone na telu', 'Grickanje koze', 'Razdrazljivost', 'Kricanje', 'Stereotipno ponasanje', 'Gubitak apetita', 'Agresivnost'],
    guidelines: [
      DietaryGuideline(nutrient: 'Omega-3', recommendation: 'high', reason: 'Podrzava zdravlje koze i perja.'),
      DietaryGuideline(nutrient: 'Vitamin A', recommendation: 'high', reason: 'Kljucan za zdravlje koze.'),
      DietaryGuideline(nutrient: 'Kalcijum', recommendation: 'moderate', reason: 'Deficit kalcijuma moze izazvati cupanje.'),
    ],
    goodIngredients: ['omega 3', 'vitamin a', 'orasasti plodovi', 'svezo voce', 'povrce', 'pelet'],
    badIngredients: ['samo seme (bez peleta)', 'secer', 'vestacki dodaci'],
  ),
  PetCondition(
    id: 'avian_gastric_yeast',
    name: 'Megabakterijoza (AGY)',
    description: 'Gljivicna infekcija zeluca — izaziva mrsavljenje i povracanje.',
    affectedSpecies: [PetType.parrot],
    icon: '🦠',
    symptoms: ['Gubitak tezine', 'Povracanje', 'Nesvarena hrana u izmetu', 'Nakostresen perje', 'Letargija', 'Gubitak apetita', 'Proliv', 'Regurgitacija'],
    guidelines: [
      DietaryGuideline(nutrient: 'Probiotici', recommendation: 'high', reason: 'Pomazu kontroli gljivica u zelucu.'),
      DietaryGuideline(nutrient: 'Vitamin A', recommendation: 'high', reason: 'Stiti sluznice zeluca.'),
      DietaryGuideline(nutrient: 'Lako svarljiva hrana', recommendation: 'high', reason: 'Smanjuje opterecenje zeluca.'),
    ],
    goodIngredients: ['probiotici', 'vitamin a', 'jabucni sirce (razblazeno)', 'pelet', 'svezo povrce'],
    badIngredients: ['secer', 'seme suncokreta (previse)', 'plesniva hrana'],
  ),
  PetCondition(
    id: 'vitamin_a_deficiency',
    name: 'Nedostatak vitamina A',
    description: 'Cest problem kod papagaja na dijeti od samog semena.',
    affectedSpecies: [PetType.parrot, PetType.pigeon, PetType.poultry],
    icon: '🥕',
    symptoms: ['Bele tacke u ustima', 'Oteceni sinusi', 'Curenje iz nosa', 'Lose stanje perja', 'Ceste infekcije', 'Otezano disanje', 'Problemi sa ocima', 'Gubitak apetita'],
    guidelines: [
      DietaryGuideline(nutrient: 'Vitamin A', recommendation: 'high', reason: 'Direktna nadoknada nedostatka.'),
      DietaryGuideline(nutrient: 'Beta-karoten', recommendation: 'high', reason: 'Prirodni izvor vitamina A.'),
      DietaryGuideline(nutrient: 'Raznovrsna ishrana', recommendation: 'high', reason: 'Prelazak sa samog semena na pelet i povrce.'),
    ],
    goodIngredients: ['sargarepa', 'batat', 'brokoli', 'spanac', 'paprika', 'mango', 'pelet'],
    badIngredients: ['samo seme', 'seme suncokreta (previse)', 'niskokvalitetna hrana'],
  ),
  PetCondition(
    id: 'fatty_liver',
    name: 'Masna jetra (Hepaticka lipidoza)',
    description: 'Nakupljanje masti u jetri — cesto kod papagaja na masnoj dijeti.',
    affectedSpecies: [PetType.parrot],
    icon: '🫁',
    symptoms: ['Gojaznost', 'Letargija', 'Otezano disanje', 'Gubitak apetita', 'Prerasli kljun', 'Prerasli nokti', 'Lose stanje perja', 'Proliv'],
    guidelines: [
      DietaryGuideline(nutrient: 'Masti', recommendation: 'low', reason: 'Smanjiti masne namirnice, posebno seme.'),
      DietaryGuideline(nutrient: 'Vlakna', recommendation: 'high', reason: 'Povrce i voce umesto semena.'),
      DietaryGuideline(nutrient: 'Vitamin E', recommendation: 'high', reason: 'Stiti celije jetre.'),
    ],
    goodIngredients: ['pelet', 'svezo povrce', 'voce', 'vitamin e', 'brokoli'],
    badIngredients: ['seme suncokreta', 'kikiriki', 'masno seme', 'secer'],
  ),
];
