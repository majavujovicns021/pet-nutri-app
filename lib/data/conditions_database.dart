/// Veterinarski dijetetski vodiči za česta stanja kod kućnih ljubimaca.

enum PetType { dog, cat }

class DietaryGuideline {
  final String nutrient;
  final String recommendation; // "low", "moderate", "high", "avoid"
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

/// Vraća listu bolesti koje odgovaraju datim simptomima.
List<PetCondition> findConditionsBySymptoms(
    List<String> selectedSymptoms, PetType petType) {
  if (selectedSymptoms.isEmpty) return [];

  final matches = <MapEntry<PetCondition, int>>[];

  for (final condition in conditionsDatabase) {
    if (!condition.affectedSpecies.contains(petType)) continue;

    int matchCount = 0;
    for (final symptom in condition.symptoms) {
      if (selectedSymptoms.any((s) => symptom == s)) {
        matchCount++;
      }
    }
    if (matchCount > 0) {
      matches.add(MapEntry(condition, matchCount));
    }
  }

  matches.sort((a, b) => b.value.compareTo(a.value));
  return matches.map((m) => m.key).toList();
}

/// Sve jedinstvene simptome iz baze za dati tip životinje.
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
  PetCondition(
    id: 'hepatitis',
    name: 'Hepatitis',
    description: 'Upala jetre — potrebna dijeta sa smanjenim opterećenjem za jetru.',
    affectedSpecies: [PetType.dog, PetType.cat],
    icon: '🫁',
    symptoms: [
      'Gubitak apetita',
      'Povraćanje',
      'Žutica (žuta boja kože i očiju)',
      'Letargija i slabost',
      'Povećan unos vode',
      'Tamna mokraća',
      'Nadut stomak',
      'Gubitak težine',
    ],
    guidelines: [
      DietaryGuideline(
        nutrient: 'Proteini',
        recommendation: 'moderate',
        reason: 'Visokokvalitetni, lako svarljivi proteini u umerenoj količini.',
      ),
      DietaryGuideline(
        nutrient: 'Masti',
        recommendation: 'low',
        reason: 'Smanjene masti rasterećuju jetru.',
      ),
      DietaryGuideline(
        nutrient: 'Bakar',
        recommendation: 'avoid',
        reason: 'Bakar se akumulira u oštećenoj jetri.',
      ),
      DietaryGuideline(
        nutrient: 'Vlakna',
        recommendation: 'moderate',
        reason: 'Pomaže u vezivanju toksina u crevima.',
      ),
      DietaryGuideline(
        nutrient: 'Antioksidansi',
        recommendation: 'high',
        reason: 'Vitamin E i C štite ćelije jetre.',
      ),
    ],
    goodIngredients: [
      'piletina', 'ćuretina', 'pirinač',
      'jaja', 'sveži sir', 'vitamin e', 'vitamin c', 'omega 3',
    ],
    badIngredients: [
      'bakar', 'jetra', 'džigerica',
      'nusproizvod', 'kukuruz', 'pšenica',
    ],
  ),
  PetCondition(
    id: 'kidney_disease',
    name: 'Bubrežna bolest',
    description: 'Hronična bubrežna insuficijencija — smanjen unos fosfora i proteina.',
    affectedSpecies: [PetType.dog, PetType.cat],
    icon: '🫘',
    symptoms: [
      'Pojačano mokrenje',
      'Pojačana žeđ',
      'Gubitak apetita',
      'Povraćanje',
      'Gubitak težine',
      'Loš zadah (miris na amonijak)',
      'Letargija',
      'Dehidracija',
      'Bledilo desni',
    ],
    guidelines: [
      DietaryGuideline(
        nutrient: 'Proteini',
        recommendation: 'low',
        reason: 'Smanjeni proteini da se ne opterete bubrezi.',
      ),
      DietaryGuideline(
        nutrient: 'Fosfor',
        recommendation: 'avoid',
        reason: 'Fosfor pogoršava bubrežnu funkciju.',
      ),
      DietaryGuideline(
        nutrient: 'Natrijum',
        recommendation: 'low',
        reason: 'Nizak natrijum pomaže kontrolu krvnog pritiska.',
      ),
      DietaryGuideline(
        nutrient: 'Omega-3',
        recommendation: 'high',
        reason: 'Smanjuje upalu u bubrezima.',
      ),
    ],
    goodIngredients: [
      'jaja', 'omega 3', 'riblje ulje',
      'pirinač', 'batat',
    ],
    badIngredients: [
      'fosfor', 'koštano brašno',
      'so', 'natrijum', 'nusproizvod',
    ],
  ),
  PetCondition(
    id: 'diabetes',
    name: 'Dijabetes',
    description: 'Šećerna bolest — potrebna hrana sa niskim glikemijskim indeksom.',
    affectedSpecies: [PetType.dog, PetType.cat],
    icon: '💉',
    symptoms: [
      'Pojačana žeđ',
      'Učestalo mokrenje',
      'Pojačan apetit uz gubitak težine',
      'Letargija',
      'Zamućen vid',
      'Sporo zarastanje rana',
      'Česte infekcije',
      'Sladak miris daha',
    ],
    guidelines: [
      DietaryGuideline(
        nutrient: 'Ugljeni hidrati',
        recommendation: 'low',
        reason: 'Nizak GI sprečava skokove šećera u krvi.',
      ),
      DietaryGuideline(
        nutrient: 'Proteini',
        recommendation: 'high',
        reason: 'Visok protein pomaže stabilizaciju glukoze.',
      ),
      DietaryGuideline(
        nutrient: 'Vlakna',
        recommendation: 'high',
        reason: 'Vlakna usporavaju apsorpciju šećera.',
      ),
    ],
    goodIngredients: [
      'piletina', 'ćuretina', 'riba',
      'vlakna', 'bundeva', 'boranija',
    ],
    badIngredients: [
      'šećer', 'kukuruzni sirup',
      'pšenica', 'kukuruz', 'beli pirinač',
    ],
  ),
  PetCondition(
    id: 'pancreatitis',
    name: 'Pankreatitis',
    description: 'Upala pankreasa — strogo niskomasna dijeta.',
    affectedSpecies: [PetType.dog, PetType.cat],
    icon: '🔥',
    symptoms: [
      'Jak bol u stomaku',
      'Povraćanje',
      'Proliv',
      'Gubitak apetita',
      'Dehidracija',
      'Letargija',
      'Grbljenje leđa (kod pasa)',
      'Povišena temperatura',
    ],
    guidelines: [
      DietaryGuideline(
        nutrient: 'Masti',
        recommendation: 'avoid',
        reason: 'Masti su glavni okidač pankreatitisa.',
      ),
      DietaryGuideline(
        nutrient: 'Proteini',
        recommendation: 'moderate',
        reason: 'Lako svarljivi proteini u umerenoj količini.',
      ),
      DietaryGuideline(
        nutrient: 'Vlakna',
        recommendation: 'moderate',
        reason: 'Pomaže probavi bez opterećenja pankreasa.',
      ),
    ],
    goodIngredients: [
      'pileća prsa', 'ćuretina', 'pirinač',
      'bundeva', 'batat',
    ],
    badIngredients: [
      'mast', 'ulje', 'puter',
      'loj', 'slanina',
    ],
  ),
  PetCondition(
    id: 'allergies',
    name: 'Alergije na hranu',
    description: 'Preosetljivost na određene sastojke — eliminaciona dijeta.',
    affectedSpecies: [PetType.dog, PetType.cat],
    icon: '🤧',
    symptoms: [
      'Svrab kože',
      'Crvenilo i osip',
      'Češanje ušiju',
      'Lizanje šapa',
      'Proliv ili mek stolica',
      'Povraćanje',
      'Gubitak dlake',
      'Hronične upale ušiju',
    ],
    guidelines: [
      DietaryGuideline(
        nutrient: 'Proteini',
        recommendation: 'moderate',
        reason: 'Koristiti nove proteine (jagnjetina, divljač, riba).',
      ),
      DietaryGuideline(
        nutrient: 'Žitarice',
        recommendation: 'avoid',
        reason: 'Česti alergeni — izbegavati pšenicu, kukuruz, soju.',
      ),
    ],
    goodIngredients: [
      'jagnjetina', 'divljač', 'losos',
      'pačetina', 'batat', 'grašak',
    ],
    badIngredients: [
      'pšenica', 'kukuruz', 'soja',
      'govedina', 'mlečni proizvodi', 'veštački dodaci',
    ],
  ),
  PetCondition(
    id: 'obesity',
    name: 'Gojaznost',
    description: 'Prekomerna težina — niskokalorična dijeta bogata vlaknima.',
    affectedSpecies: [PetType.dog, PetType.cat],
    icon: '⚖️',
    symptoms: [
      'Vidljiv višak kilograma',
      'Teško disanje pri naporu',
      'Smanjena aktivnost',
      'Otežano kretanje',
      'Ne mogu se napipati rebra',
      'Brzo zamaranje',
      'Hramanje (opterećenje zglobova)',
    ],
    guidelines: [
      DietaryGuideline(
        nutrient: 'Kalorije',
        recommendation: 'low',
        reason: 'Smanjen kalorijski unos za gubitak težine.',
      ),
      DietaryGuideline(
        nutrient: 'Vlakna',
        recommendation: 'high',
        reason: 'Vlakna daju osećaj sitosti.',
      ),
      DietaryGuideline(
        nutrient: 'Proteini',
        recommendation: 'high',
        reason: 'Visok protein čuva mišićnu masu tokom mršavljenja.',
      ),
    ],
    goodIngredients: [
      'piletina', 'ćuretina', 'vlakna',
      'boranija', 'bundeva', 'šargarepa',
    ],
    badIngredients: [
      'mast', 'šećer', 'kukuruzni sirup', 'nusproizvod',
    ],
  ),
  PetCondition(
    id: 'urinary',
    name: 'Urinarni problemi',
    description: 'Kristali/kamenci u mokraćnim putevima — kontrola pH i minerala.',
    affectedSpecies: [PetType.dog, PetType.cat],
    icon: '💧',
    symptoms: [
      'Bolno mokrenje',
      'Krv u mokraći',
      'Učestalo mokrenje u malim količinama',
      'Mokrenje van posude/napolju',
      'Lizanje genitalnog područja',
      'Naprezanje pri mokrenju',
      'Nemogućnost mokrenja (hitno!)',
    ],
    guidelines: [
      DietaryGuideline(
        nutrient: 'Magnezijum',
        recommendation: 'low',
        reason: 'Višak magnezijuma doprinosi formiranju kristala.',
      ),
      DietaryGuideline(
        nutrient: 'Fosfor',
        recommendation: 'low',
        reason: 'Kontrola fosfora smanjuje rizik od kamenaca.',
      ),
      DietaryGuideline(
        nutrient: 'Vlaga',
        recommendation: 'high',
        reason: 'Mokra hrana pomaže razblaženju urina.',
      ),
    ],
    goodIngredients: [
      'piletina', 'riba', 'vlažna hrana', 'brusnica',
    ],
    badIngredients: [
      'magnezijum', 'pepeo', 'fosfor', 'so',
    ],
  ),
  // === NOVE BOLESTI ===
  PetCondition(
    id: 'heart_disease',
    name: 'Srčana bolest',
    description: 'Oboljenje srca — smanjen natrijum i podrška srčanom mišiću.',
    affectedSpecies: [PetType.dog, PetType.cat],
    icon: '❤️',
    symptoms: [
      'Kašalj (naročito noću)',
      'Teško disanje',
      'Brzo zamaranje',
      'Smanjena aktivnost',
      'Gubitak apetita',
      'Nadut stomak (tečnost)',
      'Plavičaste desni',
      'Nesvestica',
    ],
    guidelines: [
      DietaryGuideline(
        nutrient: 'Natrijum',
        recommendation: 'low',
        reason: 'Nizak natrijum smanjuje zadržavanje tečnosti.',
      ),
      DietaryGuideline(
        nutrient: 'Taurin',
        recommendation: 'high',
        reason: 'Taurin je ključan za funkciju srčanog mišića.',
      ),
      DietaryGuideline(
        nutrient: 'Omega-3',
        recommendation: 'high',
        reason: 'Smanjuje upalu i podržava srce.',
      ),
      DietaryGuideline(
        nutrient: 'L-karnitin',
        recommendation: 'high',
        reason: 'Pomaže energetski metabolizam srca.',
      ),
    ],
    goodIngredients: [
      'riba', 'losos', 'taurin', 'omega 3',
      'riblje ulje', 'piletina', 'l-karnitin',
    ],
    badIngredients: [
      'so', 'natrijum', 'slanina', 'prerađeno meso',
    ],
  ),
  PetCondition(
    id: 'arthritis',
    name: 'Artritis',
    description: 'Upala zglobova — antiinflamatorna dijeta sa podrškom hrskavici.',
    affectedSpecies: [PetType.dog, PetType.cat],
    icon: '🦴',
    symptoms: [
      'Hramanje',
      'Ukočenost posle odmora',
      'Otežano ustajanje',
      'Smanjena aktivnost',
      'Bolni zglobovi na dodir',
      'Otečeni zglobovi',
      'Lizanje bolnih mesta',
      'Odbijanje skakanja ili penjanja',
    ],
    guidelines: [
      DietaryGuideline(
        nutrient: 'Omega-3',
        recommendation: 'high',
        reason: 'Snažno antiinflamatorno dejstvo na zglobove.',
      ),
      DietaryGuideline(
        nutrient: 'Glukozamin',
        recommendation: 'high',
        reason: 'Podržava obnovu hrskavice.',
      ),
      DietaryGuideline(
        nutrient: 'Kalorije',
        recommendation: 'low',
        reason: 'Održavanje idealne težine smanjuje opterećenje zglobova.',
      ),
      DietaryGuideline(
        nutrient: 'Antioksidansi',
        recommendation: 'high',
        reason: 'Vitamin C i E smanjuju oksidativni stres.',
      ),
    ],
    goodIngredients: [
      'losos', 'riblje ulje', 'omega 3', 'glukozamin',
      'hondroitin', 'školjke', 'kurkuma',
    ],
    badIngredients: [
      'šećer', 'kukuruz', 'pšenica', 'nusproizvod',
    ],
  ),
  PetCondition(
    id: 'ibd',
    name: 'Upalna bolest creva (IBD)',
    description: 'Hronična upala digestivnog trakta — lako svarljiva dijeta.',
    affectedSpecies: [PetType.dog, PetType.cat],
    icon: '🩺',
    symptoms: [
      'Hroničan proliv',
      'Povraćanje',
      'Gubitak težine',
      'Gubitak apetita',
      'Krv ili sluz u stolici',
      'Nadimanje i gasovi',
      'Bolovi u stomaku',
      'Loše stanje dlake',
    ],
    guidelines: [
      DietaryGuideline(
        nutrient: 'Proteini',
        recommendation: 'moderate',
        reason: 'Hidrolizovani ili novi proteini smanjuju reakciju creva.',
      ),
      DietaryGuideline(
        nutrient: 'Masti',
        recommendation: 'low',
        reason: 'Niske masti su lakše za varenje.',
      ),
      DietaryGuideline(
        nutrient: 'Vlakna',
        recommendation: 'moderate',
        reason: 'Rastvorljiva vlakna hrane korisne bakterije.',
      ),
      DietaryGuideline(
        nutrient: 'Probiotici',
        recommendation: 'high',
        reason: 'Podržavaju zdravu crevnu floru.',
      ),
    ],
    goodIngredients: [
      'piletina', 'ćuretina', 'pirinač', 'bundeva',
      'probiotici', 'prebiotici',
    ],
    badIngredients: [
      'pšenica', 'kukuruz', 'soja', 'mlečni proizvodi',
      'veštački dodaci',
    ],
  ),
  PetCondition(
    id: 'hypothyroidism',
    name: 'Hipotireoza',
    description: 'Smanjena funkcija štitne žlezde — dijeta za metabolizam i težinu.',
    affectedSpecies: [PetType.dog],
    icon: '🦋',
    symptoms: [
      'Debljanje bez povećanog apetita',
      'Letargija i pospanost',
      'Gubitak dlake',
      'Suva i ljuspasta koža',
      'Osetljivost na hladnoću',
      'Spor puls',
      'Tamna pigmentacija kože',
      'Česte kožne infekcije',
    ],
    guidelines: [
      DietaryGuideline(
        nutrient: 'Kalorije',
        recommendation: 'low',
        reason: 'Spor metabolizam zahteva manje kalorija.',
      ),
      DietaryGuideline(
        nutrient: 'Proteini',
        recommendation: 'high',
        reason: 'Visok protein podržava metabolizam.',
      ),
      DietaryGuideline(
        nutrient: 'Omega-3',
        recommendation: 'high',
        reason: 'Pomaže zdravlju kože i dlake.',
      ),
      DietaryGuideline(
        nutrient: 'Jod',
        recommendation: 'moderate',
        reason: 'Umereni jod podržava štitnu žlezdu.',
      ),
    ],
    goodIngredients: [
      'riba', 'piletina', 'omega 3', 'riblje ulje',
      'batat', 'boranija',
    ],
    badIngredients: [
      'šećer', 'kukuruzni sirup', 'mast', 'nusproizvod',
    ],
  ),
  PetCondition(
    id: 'hyperthyroidism',
    name: 'Hipertireoza',
    description: 'Pojačana funkcija štitne žlezde — kontrola joda i kalorija.',
    affectedSpecies: [PetType.cat],
    icon: '⚡',
    symptoms: [
      'Gubitak težine uz pojačan apetit',
      'Pojačana žeđ i mokrenje',
      'Hiperaktivnost i nemir',
      'Povraćanje',
      'Proliv',
      'Loše stanje dlake',
      'Ubrzan puls',
      'Agresivnost ili promena ponašanja',
    ],
    guidelines: [
      DietaryGuideline(
        nutrient: 'Jod',
        recommendation: 'avoid',
        reason: 'Ograničenje joda smanjuje proizvodnju hormona.',
      ),
      DietaryGuideline(
        nutrient: 'Kalorije',
        recommendation: 'high',
        reason: 'Potrebno nadoknaditi gubitak težine.',
      ),
      DietaryGuideline(
        nutrient: 'Proteini',
        recommendation: 'high',
        reason: 'Visok protein za očuvanje mišićne mase.',
      ),
    ],
    goodIngredients: [
      'piletina', 'ćuretina', 'jaja', 'pirinač',
    ],
    badIngredients: [
      'riba', 'morski plodovi', 'alge', 'jod',
    ],
  ),
  PetCondition(
    id: 'dental_disease',
    name: 'Bolesti zuba i desni',
    description: 'Parodontalna bolest — dijeta koja podržava oralno zdravlje.',
    affectedSpecies: [PetType.dog, PetType.cat],
    icon: '🦷',
    symptoms: [
      'Loš zadah',
      'Crvenilo i otečenost desni',
      'Krvarenje desni',
      'Otežano žvakanje',
      'Gubitak apetita',
      'Ispuštanje hrane iz usta',
      'Curenje pljuvačke',
      'Labavi ili izgubljeni zubi',
    ],
    guidelines: [
      DietaryGuideline(
        nutrient: 'Tekstura hrane',
        recommendation: 'high',
        reason: 'Suva hrana pomaže mehaničkom čišćenju zuba.',
      ),
      DietaryGuideline(
        nutrient: 'Kalcijum',
        recommendation: 'moderate',
        reason: 'Podržava zdravlje kostiju i zuba.',
      ),
      DietaryGuideline(
        nutrient: 'Vitamin C',
        recommendation: 'high',
        reason: 'Pomaže zdravlju desni i zarastanju.',
      ),
    ],
    goodIngredients: [
      'piletina', 'riba', 'vitamin c', 'kalcijum',
      'suva hrana', 'dental poslastice',
    ],
    badIngredients: [
      'šećer', 'meka lepljiva hrana', 'kukuruzni sirup',
    ],
  ),
  PetCondition(
    id: 'skin_issues',
    name: 'Kožni problemi',
    description: 'Dermatitis i problemi sa dlakom — dijeta bogata masnim kiselinama.',
    affectedSpecies: [PetType.dog, PetType.cat],
    icon: '🐾',
    symptoms: [
      'Svrab i češanje',
      'Suva i ljuspasta koža',
      'Gubitak dlake',
      'Crvenilo kože',
      'Masna ili smrdljiva koža',
      'Česte kožne infekcije',
      'Perut',
      'Lizanje i grickanje kože',
    ],
    guidelines: [
      DietaryGuideline(
        nutrient: 'Omega-3',
        recommendation: 'high',
        reason: 'Esencijalne masne kiseline za zdravu kožu i dlaku.',
      ),
      DietaryGuideline(
        nutrient: 'Omega-6',
        recommendation: 'moderate',
        reason: 'Balans omega masnih kiselina za kožnu barijeru.',
      ),
      DietaryGuideline(
        nutrient: 'Cink',
        recommendation: 'high',
        reason: 'Cink je ključan za obnovu kože.',
      ),
      DietaryGuideline(
        nutrient: 'Biotin',
        recommendation: 'high',
        reason: 'Podržava rast zdrave dlake.',
      ),
    ],
    goodIngredients: [
      'losos', 'riblje ulje', 'omega 3', 'omega 6',
      'cink', 'biotin', 'jaja',
    ],
    badIngredients: [
      'veštački dodaci', 'boje', 'kukuruz', 'soja',
    ],
  ),
  PetCondition(
    id: 'gastritis',
    name: 'Gastritis',
    description: 'Upala želuca — blaga, lako svarljiva dijeta.',
    affectedSpecies: [PetType.dog, PetType.cat],
    icon: '🤢',
    symptoms: [
      'Povraćanje',
      'Gubitak apetita',
      'Bol u stomaku',
      'Letargija',
      'Dehidracija',
      'Jedenje trave (kod pasa)',
      'Podrigivanje',
      'Crna stolica (krvarenje)',
    ],
    guidelines: [
      DietaryGuideline(
        nutrient: 'Masti',
        recommendation: 'low',
        reason: 'Niske masti su lakše za želudac.',
      ),
      DietaryGuideline(
        nutrient: 'Proteini',
        recommendation: 'moderate',
        reason: 'Lako svarljivi proteini u manjim obrocima.',
      ),
      DietaryGuideline(
        nutrient: 'Vlakna',
        recommendation: 'low',
        reason: 'Manje vlakana smanjuje iritaciju želuca.',
      ),
    ],
    goodIngredients: [
      'piletina', 'pirinač', 'bundeva', 'batat',
      'kuvana jaja',
    ],
    badIngredients: [
      'mast', 'začini', 'veštački dodaci',
      'mlečni proizvodi', 'masna hrana',
    ],
  ),
  PetCondition(
    id: 'epilepsy',
    name: 'Epilepsija',
    description: 'Neurološki poremećaj sa napadima — dijeta sa MCT uljima.',
    affectedSpecies: [PetType.dog, PetType.cat],
    icon: '🧠',
    symptoms: [
      'Napadi (konvulzije)',
      'Gubitak svesti',
      'Nekontrolisano drhtanje',
      'Curenje pljuvačke',
      'Dezorijentisanost posle napada',
      'Ukočenost tela',
      'Nekontrolisano mokrenje/defekacija',
      'Nemir pre napada',
    ],
    guidelines: [
      DietaryGuideline(
        nutrient: 'MCT ulja',
        recommendation: 'high',
        reason: 'Srednje-lančane masne kiseline mogu smanjiti učestalost napada.',
      ),
      DietaryGuideline(
        nutrient: 'Omega-3',
        recommendation: 'high',
        reason: 'Neuroprotektivno dejstvo.',
      ),
      DietaryGuideline(
        nutrient: 'Antioksidansi',
        recommendation: 'high',
        reason: 'Štite nervne ćelije od oštećenja.',
      ),
    ],
    goodIngredients: [
      'kokosovo ulje', 'MCT ulje', 'riblje ulje', 'omega 3',
      'vitamin e', 'piletina',
    ],
    badIngredients: [
      'veštački dodaci', 'boje', 'konzervansi',
      'šećer', 'glutamat',
    ],
  ),
  PetCondition(
    id: 'liver_shunt',
    name: 'Portosistemski šant',
    description: 'Abnormalan krvotok zaobilazi jetru — stroga dijeta sa niskim proteinima.',
    affectedSpecies: [PetType.dog, PetType.cat],
    icon: '🔄',
    symptoms: [
      'Usporen rast (kod mladih)',
      'Dezorijentisanost',
      'Kruženje u mestu',
      'Naslanjanje glavom na zid',
      'Povraćanje',
      'Proliv',
      'Pojačano mokrenje',
      'Napadi',
    ],
    guidelines: [
      DietaryGuideline(
        nutrient: 'Proteini',
        recommendation: 'low',
        reason: 'Nizak protein smanjuje proizvodnju amonijaka.',
      ),
      DietaryGuideline(
        nutrient: 'Bakar',
        recommendation: 'avoid',
        reason: 'Jetra ne može pravilno da preradi bakar.',
      ),
      DietaryGuideline(
        nutrient: 'Vlakna',
        recommendation: 'high',
        reason: 'Rastvorljiva vlakna vezuju toksine u crevima.',
      ),
      DietaryGuideline(
        nutrient: 'Ugljeni hidrati',
        recommendation: 'high',
        reason: 'Lako svarljivi ugljeni hidrati kao izvor energije.',
      ),
    ],
    goodIngredients: [
      'pirinač', 'batat', 'jaja', 'sveži sir',
      'bundeva', 'vlakna',
    ],
    badIngredients: [
      'jetra', 'džigerica', 'bakar', 'crveno meso',
      'nusproizvod',
    ],
  ),
  PetCondition(
    id: 'cushing',
    name: 'Kušingov sindrom',
    description: 'Višak kortizola — dijeta za kontrolu težine i metabolizma.',
    affectedSpecies: [PetType.dog],
    icon: '💊',
    symptoms: [
      'Pojačana žeđ i mokrenje',
      'Pojačan apetit',
      'Nadut stomak',
      'Gubitak dlake (simetrično)',
      'Tanka koža',
      'Letargija',
      'Česte kožne infekcije',
      'Mišićna slabost',
    ],
    guidelines: [
      DietaryGuideline(
        nutrient: 'Kalorije',
        recommendation: 'low',
        reason: 'Kontrola težine je ključna.',
      ),
      DietaryGuideline(
        nutrient: 'Proteini',
        recommendation: 'high',
        reason: 'Visok protein za očuvanje mišićne mase.',
      ),
      DietaryGuideline(
        nutrient: 'Masti',
        recommendation: 'low',
        reason: 'Niske masti za kontrolu težine.',
      ),
      DietaryGuideline(
        nutrient: 'Vlakna',
        recommendation: 'high',
        reason: 'Vlakna pomažu osećaju sitosti.',
      ),
    ],
    goodIngredients: [
      'piletina', 'ćuretina', 'vlakna', 'boranija',
      'bundeva', 'šargarepa',
    ],
    badIngredients: [
      'mast', 'šećer', 'kukuruzni sirup', 'nusproizvod',
    ],
  ),
  PetCondition(
    id: 'constipation',
    name: 'Zatvor',
    description: 'Otežano pražnjenje creva — dijeta bogata vlaknima i vodom.',
    affectedSpecies: [PetType.dog, PetType.cat],
    icon: '🚫',
    symptoms: [
      'Retko pražnjenje creva',
      'Naprezanje pri defekaciji',
      'Tvrda i suva stolica',
      'Gubitak apetita',
      'Bol u stomaku',
      'Letargija',
      'Povraćanje',
      'Nadimanje',
    ],
    guidelines: [
      DietaryGuideline(
        nutrient: 'Vlakna',
        recommendation: 'high',
        reason: 'Vlakna stimulišu rad creva.',
      ),
      DietaryGuideline(
        nutrient: 'Vlaga',
        recommendation: 'high',
        reason: 'Mokra hrana pomaže hidrataciji stolice.',
      ),
      DietaryGuideline(
        nutrient: 'Probiotici',
        recommendation: 'high',
        reason: 'Podržavaju zdravu crevnu floru.',
      ),
    ],
    goodIngredients: [
      'bundeva', 'vlakna', 'vlažna hrana', 'probiotici',
      'laneno seme', 'šargarepa',
    ],
    badIngredients: [
      'kosti', 'suva hrana (isključivo)', 'pirinač',
    ],
  ),
  PetCondition(
    id: 'anemia',
    name: 'Anemija',
    description: 'Smanjen broj crvenih krvnih zrnaca — dijeta bogata gvožđem.',
    affectedSpecies: [PetType.dog, PetType.cat],
    icon: '🩸',
    symptoms: [
      'Blede desni',
      'Letargija i slabost',
      'Brzo zamaranje',
      'Ubrzan puls',
      'Teško disanje',
      'Gubitak apetita',
      'Gubitak težine',
      'Hladni ekstremiteti',
    ],
    guidelines: [
      DietaryGuideline(
        nutrient: 'Gvožđe',
        recommendation: 'high',
        reason: 'Gvožđe je neophodno za proizvodnju crvenih krvnih zrnaca.',
      ),
      DietaryGuideline(
        nutrient: 'Vitamin B12',
        recommendation: 'high',
        reason: 'B12 podržava stvaranje krvnih ćelija.',
      ),
      DietaryGuideline(
        nutrient: 'Proteini',
        recommendation: 'high',
        reason: 'Visokokvalitetni proteini za oporavak.',
      ),
    ],
    goodIngredients: [
      'govedina', 'jetra', 'jaja', 'spanać',
      'riba', 'vitamin b12',
    ],
    badIngredients: [
      'nusproizvod', 'veštački dodaci',
    ],
  ),
];
