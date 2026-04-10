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
  final String treatment;

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
    required this.treatment,
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
    description: 'Hepatitis je upala jetre koja moze biti akutna ili hronicna, a nastaje usled virusnih, bakterijskih, toksinskih ili autoimunih uzroka. Ostecenje hepatocita dovodi do poremecaja metabolizma, detoksikacije i proizvodnje zucnih kiselina. Bez adekvatnog lecenja moze napredovati do ciroze ili potpunog otkazivanja jetre.',
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
    treatment: 'Lecenje hepatitisa zavisi od uzroka i tezine bolesti. Kod infektivnog hepatitisa pasa primenjuju se antivirusni protokoli i suportivna terapija, dok se kod bakterijskih infekcija koriste antibiotici poput Amoksicilina ili Metronidazola. Hepatoprotektori kao sto su S-adenozilmetionin (SAMe) i silimarin (ekstrakt biljke sikavice) pomazu u zastiti i regeneraciji celija jetre. Ursodeoksiholna kiselina (Ursodiol) se koristi za poboljsanje protoka zuci i smanjenje upale. Infuziona terapija je neophodna za korekciju dehidracije i elektrolitnog disbalansa. Antiemetici poput Maropitanta (Cerenia) kontrolisu povracanje, a vitamin K se daje ako postoji poremecaj koagulacije. Obavezno posetite veterinara za krvne analize (ALT, AST, bilirubin) i ultrazvuk jetre radi procene stepena ostecenja.',
  ),
  PetCondition(
    id: 'kidney_disease',
    name: 'Bubrezna bolest',
    description: 'Hronicna bubrezna insuficijencija (HBI) je progresivno i nepovratno ostecenje bubreznog tkiva koje dovodi do smanjene sposobnosti filtracije krvi i eliminacije otpadnih materija. Bolest se klasifikuje u cetiri stadijuma prema IRIS sistemu na osnovu nivoa kreatinina i SDMA u krvi. Rana dijagnoza i dijetetska intervencija mogu znacajno usporiti napredovanje bolesti.',
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
    treatment: 'Lecenje hronicne bubrezne bolesti je dozivotno i usmereno na usporavanje progresije. Vezaci fosfora poput aluminijum-hidroksida ili lantanum-karbonata se dodaju hrani da smanje apsorpciju fosfora iz creva. Benazepril (ACE inhibitor) se koristi za smanjenje proteinurije i zastitu bubreznog tkiva. Subkutana infuzija fizioloskog rastvora se primenjuje kod kuce za odrzavanje hidratacije. Eritropoetin (Epoetin alfa) ili Darbepoetin se daju kod teske anemije uzrokovane smanjenom proizvodnjom eritropoetina. Antiemetici poput Maropitanta i stimulatori apetita kao Mirtazapin pomazu u kontroli mucnine i odrzavanju unosa hrane. Redovno pracenje krvnih parametara (urea, kreatinin, fosfor, SDMA) kod veterinara je neophodno svakih 3-6 meseci. Prelazak na specijalnu renalnu dijetu sa smanjenim proteinima i fosforom je kljucan deo terapije.',
  ),
  PetCondition(
    id: 'diabetes',
    name: 'Dijabetes',
    description: 'Dijabetes melitus je endokrini poremecaj koji nastaje usled nedovoljne proizvodnje insulina (tip 1, cesci kod pasa) ili rezistencije na insulin (tip 2, cesci kod macaka). Neregulisan secer u krvi dovodi do ostecenja krvnih sudova, nerava, bubrega i ociju. Pravilna ishrana sa niskim glikemijskim indeksom je temelj kontrole bolesti uz insulinsku terapiju.',
    affectedSpecies: [PetType.dog, PetType.cat],
    icon: '💉',
    symptoms: ['Pojacana zedj', 'Ucestalo mokrenje', 'Pojacan apetit uz gubitak tezine', 'Letargija', 'Zamucen vid', 'Sporo zarastanje rana', 'Ceste infekcije', 'Sladak miris daha'],
    guidelines: [
      DietaryGuideline(nutrient: 'Ugljeni hidrati', recommendation: 'low', reason: 'Nizak GI sprecava skokove secera u krvi.'),
      DietaryGuideline(nutrient: 'Proteini', recommendation: 'high', reason: 'Visok protein pomaze stabilizaciji glukoze.'),
      DietaryGuideline(nutrient: 'Vlakna', recommendation: 'high', reason: 'Vlakna usporavaju apsorpciju secera.'),
    ],
    goodIngredients: ['piletina', 'curetina', 'riba', 'vlakna', 'bundeva', 'boranija'],
    badIngredients: ['secer', 'kukuruzni sirup', 'psenica', 'kukuruz', 'beli pirinac'],
    treatment: 'Osnova lecenja dijabetesa je insulinska terapija — kod pasa se najcesce koristi srednje-delujuci insulin (Caninsulin/vetsulin), dok se kod macaka preferira dugodeluci insulin poput Glargina (Lantus) ili Protamin-cink insulina. Doza insulina se titrira na osnovu krivulje glukoze u krvi koju radi veterinar. Obroci moraju biti u isto vreme svakog dana, neposredno pre ili posle davanja insulina. Kod macaka sa tipom 2 dijabetesa, niskougljikohidratna dijeta bogata proteinima moze dovesti do remisije bolesti. Redovno merenje fruktozamina i glukoze u krvi je neophodno za pracenje kontrole bolesti. Kod dijabetesne ketoacidoze (hitno stanje) potrebna je hospitalizacija sa intravenskom infuzijom i kratkodelujucim insulinom. Obavezno posetite veterinara odmah ako primetite povracanje, letargiju ili miris acetona iz usta.',
  ),
  PetCondition(
    id: 'pancreatitis',
    name: 'Pankreatitis',
    description: 'Pankreatitis je upala pankreasa koja nastaje kada digestivni enzimi postanu aktivni unutar samog organa i pocnu da razaraju tkivo. Moze biti akutni (iznenadni, teski) ili hronicni (ponavljajuci, blazi). Masna hrana, gojaznost i neki lekovi su najcesci okidaci, a bolest moze biti zivotno ugrozavajuca bez pravovremenog lecenja.',
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
    treatment: 'Akutni pankreatitis zahteva hospitalizaciju sa agresivnom intravenskom infuzionom terapijom za korekciju dehidracije i elektrolitnog disbalansa. Analgetici poput Buprenorfina ili Metadona se koriste za kontrolu jakog abdominalnog bola, a Meloksikam se moze primeniti kod blazih slucajeva. Antiemetici Maropitant (Cerenia) i Ondansetron kontrolisu povracanje i mucninu. Rano enteralno hranjenje malom kolicinom niskomasne hrane je pozeljno cim se povracanje kontrolise. Kod hronicnog pankreatitisa, suplementacija pankreasnim enzimima moze poboljsati varenje. Antibiotici poput Amoksicilina sa klavulanskom kiselinom se daju samo ako postoji sumnja na sekundarnu bakterijsku infekciju. Obavezno posetite veterinara za ultrazvuk abdomena i krvne analize (lipaza, amilaza, cPLI/fPLI).',
  ),
  PetCondition(
    id: 'allergies',
    name: 'Alergije na hranu',
    description: 'Alergija na hranu je imunoloski posredovana reakcija preosetljivosti na odredjene proteine u hrani, najcesce govedinu, piletinu, mlecne proizvode, psenicu ili soju. Razlikuje se od intolerancije na hranu koja ne ukljucuje imuni sistem. Dijagnoza se postavlja eliminacionom dijetom u trajanju od 8-12 nedelja sa novim izvorom proteina koji zivotinja ranije nije jela.',
    affectedSpecies: [PetType.dog, PetType.cat],
    icon: '🤧',
    symptoms: ['Svrab koze', 'Crvenilo i osip', 'Cesanje usiju', 'Lizanje sapa', 'Proliv ili mek stolica', 'Povracanje', 'Gubitak dlake', 'Hronicne upale usiju'],
    guidelines: [
      DietaryGuideline(nutrient: 'Proteini', recommendation: 'moderate', reason: 'Koristiti nove proteine (jagnjetina, divljac, riba).'),
      DietaryGuideline(nutrient: 'Zitarice', recommendation: 'avoid', reason: 'Cesti alergeni — izbegavati psenicu, kukuruz, soju.'),
    ],
    goodIngredients: ['jagnjetina', 'divljac', 'losos', 'pacetina', 'batat', 'grasak'],
    badIngredients: ['psenica', 'kukuruz', 'soja', 'govedina', 'mlecni proizvodi', 'vestacki dodaci'],
    treatment: 'Lecenje alergija na hranu pocinje strogom eliminacionom dijetom sa hidrolizovanim proteinima ili potpuno novim izvorom proteina u trajanju od minimum 8 nedelja. Oclacitinib (Apoquel) se koristi za brzo smanjenje svraba kod pasa, dok se Lokivetmab (Cytopoint) daje kao mesecna injekcija za dugotrajnu kontrolu. Kod macaka se mogu koristiti antihistaminici poput Cetirizina ili kratki kursevi kortikosteroida (Prednizolon). Sekundarne kozne infekcije se lece antibioticima (Cefaleksin) ili antifungalnim samponiima sa Hlorheksidinom. Esencijalne masne kiseline (omega-3) pomazu u jacanju kozne barijere i smanjenju upale. Posle eliminacione dijete, provokacioni test sa pojedinacnim namirnicama identifikuje tacne alergene. Obavezno posetite veterinarskog dermatologa za alergijsko testiranje i dugorocni plan ishrane.',
  ),
  PetCondition(
    id: 'obesity',
    name: 'Gojaznost',
    description: 'Gojaznost je stanje prekomerne telesne mase koje nastaje kada energetski unos hronicno prevazilazi potrosnju, sto dovodi do nakupljanja masnog tkiva. Smatra se da je zivotinja gojazna kada prelazi 20% idealne telesne mase. Gojaznost je faktor rizika za dijabetes, artritis, srcane bolesti, hepaticku lipidozu i skracen zivotni vek.',
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
    treatment: 'Lecenje gojaznosti zahteva kombinaciju dijetetskog rezima i povecane fizicke aktivnosti pod nadzorom veterinara. Cilj je postepeni gubitak tezine od 1-2% nedeljno — brze mrsavljenje moze izazvati hepaticku lipidozu, narocito kod macaka. Preporucuje se prelazak na niskokalorijske dijetetske formule sa visokim sadrzajem proteina i vlakana. Dnevni obrok se deli na 3-4 manja obroka da se odrzava metabolizam i smanjuje osecaj gladi. L-karnitin kao suplement pomaze u sagorevanju masti i ocuvanju misicne mase. Kod pasa sa hipotireozom kao uzrokom gojaznosti, potrebna je suplementacija tiroksinom (Levotiroksin). Redovno merenje telesne mase i ocene telesne kondicije (BCS) kod veterinara su neophodni za pracenje napretka.',
  ),
  PetCondition(
    id: 'urinary',
    name: 'Urinarni problemi',
    description: 'Urinarni problemi obuhvataju formiranje kristala i kamenaca (urolitijazu) u mokracnoj besici ili uretri, kao i idiopatski cistitis kod macaka (FIC). Najcesci tipovi kamenaca su struvitni (magnezijum-amonijum-fosfat) i kalcijum-oksalatni. Opstrukcija uretre je hitno stanje koje moze dovesti do akutnog otkazivanja bubrega i smrti u roku od 24-48 sati.',
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
    treatment: 'Lecenje zavisi od tipa kamenaca i prisustva opstrukcije. Kod opstrukcije uretre potrebna je hitna kateterizacija pod sedacijom i ispiranje mokracne besike. Struvitni kamenci se mogu rastvoriti specijalnom dijetetskom hranom koja zakiseljava urin (pH ispod 6.5), dok kalcijum-oksalatni kamenci zahtevaju hirursko uklanjanje (cistotomija). Antibiotici poput Amoksicilina sa klavulanskom kiselinom se daju kod bakterijskih infekcija urinarnog trakta. Prazosin se koristi za relaksaciju uretre kod macaka sa ponavljajucim opstrukcijama. Kod idiopatskog cistitisa macaka, smanjenje stresa, Feliway difuzeri i suplementi poput glukozaminoglikana (GAG) pomazu u kontroli simptoma. Obavezno posetite veterinara za analizu urina, ultrazvuk i rendgen mokracne besike radi identifikacije tipa kristala.',
  ),
  PetCondition(
    id: 'heart_disease',
    name: 'Srcana bolest',
    description: 'Srcane bolesti kod pasa i macaka obuhvataju degenerativnu bolest mitralnog zaliska (MMVD, najcesca kod pasa malih rasa), dilatativnu kardiomiopatiju (DCM, kod velikih rasa) i hipertroficnu kardiomiopatiju (HCM, najcesca kod macaka). Bolest dovodi do smanjene sposobnosti srca da pumpa krv, nakupljanja tecnosti u plucima ili abdomenu i progresivnog otkazivanja srca.',
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
    treatment: 'Lecenje srcane bolesti zavisi od stadijuma i tipa oboljenja. Pimobendan (Vetmedin) je lek prvog izbora kod pasa sa MMVD i DCM jer poboljsava kontraktilnost srca i sirii krvne sudove. Furosemid (Lasix) je diuretik koji se koristi za uklanjanje viska tecnosti iz pluca i abdomena. ACE inhibitori poput Enalaprila ili Benazeprila smanjuju opterecenje srca i usporavaju progresiju bolesti. Spironolakton se dodaje kao blagi diuretik i antifibrotik. Kod macaka sa HCM, Atenolol ili Diltiazem se koriste za usporavanje srcane frekvencije, a Klopidogrel za prevenciju tromboembolije. Suplementacija taurinom je obavezna kod DCM povezane sa deficitom taurina. Redovni ultrazvucni pregledi srca (ehokardiografija) kod veterinarskog kardiologa su neophodni za pracenje napredovanja bolesti.',
  ),
  PetCondition(
    id: 'arthritis',
    name: 'Artritis',
    description: 'Osteoartritis je degenerativna bolest zglobova koja nastaje usled propadanja zglobne hrskavice, sto dovodi do bola, upale i smanjene pokretljivosti. Najcesce pogadja kukove, kolena, laktove i kicmu, narocito kod starijih i gojaznih zivotinja. Bolest je progresivna i neizleciva, ali se simptomi mogu znacajno kontrolisati kombinacijom dijete, lekova i fizikalne terapije.',
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
    treatment: 'Nesteroidni antiinflamatorni lekovi (NSAIL) poput Meloksikama (Metacam) ili Karprofen (Rimadyl) su osnova terapije bola kod pasa, dok se kod macaka koristi Meloksikam u nizoj dozi ili noviji lek Solensia (Frunevetmab, anti-NGF antitelo). Glukozamin-hondroitin sulfat suplementi pomazu u zastiti i obnovi hrskavice. Adekvan (polisulfatovani glikozaminoglikan) se daje kao serija injekcija za zastitu zglobne hrskavice. Omega-3 masne kiseline u visokim dozama (EPA i DHA) imaju dokazano antiinflamatorno dejstvo. Fizikalna terapija ukljucujuci hidroterapiju, lasersku terapiju i kontrolisane setnje znacajno poboljsava pokretljivost. Odrzavanje idealne telesne mase je kljucno jer svaki visak kilograma dodatno opterecuje zglobove. Obavezno posetite veterinara za rendgen zglobova i plan lecenja prilagodjen stadijumu bolesti.',
  ),
  PetCondition(
    id: 'ibd',
    name: 'Upalna bolest creva (IBD)',
    description: 'Upalna bolest creva (IBD) je hronicno stanje karakterisano infiltracijom zapaljenskih celija u zid creva, sto dovodi do poremecaja varenja i apsorpcije hranljivih materija. Najcesci oblici su limfocitno-plazmocitni enteritis i eozinofilni enteritis. Dijagnoza se postavlja biopsijom creva, a lecenje zahteva kombinaciju dijetetske terapije i imunosupresivnih lekova.',
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
    treatment: 'Lecenje IBD-a zahteva kombinaciju dijetetske i medikamentozne terapije. Prednizolon je imunosupresivni lek prvog izbora koji se daje u opadajucim dozama tokom nekoliko nedelja. Budezonid se koristi kao alternativa sa manje sistemskih nuspojava jer deluje lokalno na creva. Metronidazol ima antiinflamatorno i antibakterijsko dejstvo na creva i cesto se kombinuje sa kortikosteroidima. Kod teskih slucajeva koji ne reaguju na steroide, koriste se jaci imunosupresivi poput Azatioprina (kod pasa) ili Hlorambucila (kod macaka). Dijeta sa hidrolizovanim proteinima ili novim izvorom proteina je kljucna za smanjenje antigenske stimulacije creva. Probiotici i prebiotici pomazu u obnovi zdrave crevne mikroflore. Redovne kontrole kod veterinara sa krvnim analizama su neophodne za pracenje nuspojava lekova i prilagodjavanje terapije.',
  ),
  PetCondition(
    id: 'hypothyroidism',
    name: 'Hipotireoza',
    description: 'Hipotireoza je endokrini poremecaj uzrokovan nedovoljnom proizvodnjom hormona stitne zlezde (T4 i T3), najcesce usled autoimunog tiroiditisa ili idiopatske atrofije zlezde. Smanjen nivo tiroidnih hormona usporava metabolizam celokupnog organizma. Bolest je najcesca kod pasa srednjih i velikih rasa, a dijagnoza se postavlja merenjem ukupnog T4, slobodnog T4 i TSH u krvi.',
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
    treatment: 'Lecenje hipotireoze je dozivotno i zasniva se na oralnoj suplementaciji sintetickim tiroidnim hormonom — Levotiroksinom (Soloxine, Thyro-Tabs). Pocetna doza je obicno 0.02 mg/kg dva puta dnevno, a zatim se prilagodjava na osnovu kontrolnih krvnih analiza. Prva kontrola nivoa T4 u krvi se radi 4-6 nedelja nakon pocetka terapije, a zatim svakih 6 meseci. Lek se daje na prazan zeludac jer hrana moze smanjiti apsorpciju. Poboljsanje energije i aktivnosti se obicno primecuje vec nakon 1-2 nedelje, dok potpuni oporavak koze i dlake moze trajati 3-6 meseci. Niskokaloricna dijeta bogata proteinima pomaze u kontroli telesne mase dok se metabolizam normalizuje. Obavezno posetite veterinara za redovne kontrole hormona i prilagodjavanje doze leka.',
  ),
  PetCondition(
    id: 'hyperthyroidism',
    name: 'Hipertireoza',
    description: 'Hipertireoza je najcesci endokrini poremecaj kod macaka starijih od 8 godina, uzrokovan benignim tumorom (adenomom) stitne zlezde koji proizvodi prekomerne kolicine tiroidnih hormona. Ubrzani metabolizam dovodi do gubitka tezine uprkos povecanom apetitu, tahikardije i ostecenja srca i bubrega. Nelecena hipertireoza moze dovesti do hipertroficne kardiomiopatije i srcane insuficijencije.',
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
    treatment: 'Lecenje hipertireoze kod macaka ima nekoliko opcija. Metimazol (Tapazol/Felimazole) je antitiroidni lek koji blokira proizvodnju hormona i daje se oralno ili transdermalno na unutrasnju stranu usne skoljke. Terapija radioaktivnim jodom (I-131) je zlatni standard jer trajno izleci bolest jednom injekcijom, ali zahteva specijalizovanu kliniku. Hirurska tiroidektomija je opcija kod macaka koje ne tolerisu lekove. Dijeta sa ogranicenim jodom (Hill\'s y/d) moze kontrolisati blage slucajeve. Redovno pracenje nivoa T4 u krvi je neophodno svakih 3-6 meseci, kao i pracenje bubrezne funkcije jer lecenje hipertireoze moze demaskirati skrivenu bubreznu bolest. Kod macaka sa sekundarnom kardiomiopatijom, Atenolol se koristi za kontrolu tahikardije. Obavezno posetite veterinara za kompletnu krvnu sliku, biohemiju i merenje krvnog pritiska.',
  ),
  PetCondition(
    id: 'dental_disease',
    name: 'Bolesti zuba i desni',
    description: 'Parodontalna bolest je najcesca bolest kod pasa i macaka — pogadja preko 80% zivotinja starijih od 3 godine. Pocinje nakupljanjem plaka i zubnog kamenca, napreduje do gingivitisa (upale desni), a zatim do parodontitisa sa razaranjem kostiju vilice i gubitkom zuba. Bakterije iz usne duplje mogu preko krvotoka dospeti do srca, jetre i bubrega i izazvati sistemske infekcije.',
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
    treatment: 'Profesionalno ciscenje zuba (dentalna profilaksa) pod opstom anestezijom je osnova lecenja parodontalne bolesti i ukljucuje uklanjanje kamenca ultrazvukom, poliranje zuba i subgingivalno kiretiranje. Ekstrakcija (vadjenje) tesko ostecenih i labavnih zuba je neophodna jer su izvor hronicne infekcije i bola. Antibiotici poput Klindamicina, Amoksicilina sa klavulanskom kiselinom ili Metronidazola se daju pre i posle zahvata za kontrolu bakterijske infekcije. Analgetici Meloksikam i Tramadol se koriste za postoperativnu kontrolu bola. Svakodnevno pranje zuba specijalizovanom pastom za zivotinje (nikada ljudskom) je najvaznija preventivna mera. Dentalne grickalice i dodaci za vodu sa Hlorheksidinom pomazu u smanjenju plaka izmedju profesionalnih ciscenja. Obavezno posetite veterinara za dentalni pregled i rendgen zuba jer vecina parodontalnih problema nije vidljiva golim okom.',
  ),
  PetCondition(
    id: 'skin_issues',
    name: 'Kozni problemi',
    description: 'Dermatoloski problemi kod pasa i macaka obuhvataju atopijski dermatitis, bakterijske pioderme, gljivicne infekcije (dermatofitoza), demodikoza i seboreja. Koza je najveci organ tela i njen izgled direktno odrazava opste zdravstveno stanje i kvalitet ishrane. Hronicni kozni problemi cesto zahtevaju multidisciplinarni pristup ukljucujuci dijetetsku terapiju, lekove i kontrolu okoline.',
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
    treatment: 'Lecenje koznih problema zavisi od uzroka. Kod bakterijskih piodermi koriste se antibiotici poput Cefaleksina ili Amoksicilina sa klavulanskom kiselinom u trajanju od minimum 3-4 nedelje. Gljivicne infekcije se lece Itrakonazolom ili Ketokonazolom oralno, uz kupanje sa Mikonazol-Hlorheksidin samponom. Atopijski dermatitis se kontrolise Oclacitinibom (Apoquel), Lokivetmabom (Cytopoint) ili imunoterapijom (alergenskim vakcinama). Demodikoza se leci Ivermektinom, Fluralanerom (Bravecto) ili Sarolanerom (Simparica). Medicinski samponi sa Hlorheksidinom (2-4%) se koriste za lokalno lecenje bakterijskih i gljivicnih infekcija koze. Suplementacija omega-3 masnim kiselinama i cinkom poboljsava kvalitet koze i dlake. Obavezno posetite veterinarskog dermatologa za kozni skarifikacioni test, citologiju i eventualno biopsiju koze.',
  ),
  PetCondition(
    id: 'gastritis',
    name: 'Gastritis',
    description: 'Gastritis je upala sluznice zeluca koja moze biti akutna (izazvana ingestijom neadekvatne hrane, lekova ili toksina) ili hronicna (uzrokovana Helicobacter infekcijom, autoimunim procesima ili dugotrajnom upotrebom NSAIL lekova). Akutni gastritis je obicno samoogranicavajuci, dok hronicni oblik zahteva detaljnu dijagnostiku ukljucujuci endoskopiju sa biopsijom.',
    affectedSpecies: [PetType.dog, PetType.cat],
    icon: '🤢',
    symptoms: ['Povracanje', 'Gubitak apetita', 'Bol u stomaku', 'Letargija', 'Dehidracija', 'Jedenje trave (kod pasa)', 'Podrigivanje', 'Crna stolica (krvarenje)'],
    guidelines: [
      DietaryGuideline(nutrient: 'Masti', recommendation: 'low', reason: 'Niske masti su lakse za zeludac.'),
      DietaryGuideline(nutrient: 'Proteini', recommendation: 'moderate', reason: 'Lako svarljivi proteini u manjim obrocima.'),
    ],
    goodIngredients: ['piletina', 'pirinac', 'bundeva', 'batat', 'kuvana jaja'],
    badIngredients: ['mast', 'zacini', 'vestacki dodaci', 'mlecni proizvodi', 'masna hrana'],
    treatment: 'Akutni gastritis se leci kratkim postom od 12-24 sata (samo kod odraslih zivotinja, ne kod stenaca i macica), a zatim postepenim uvodjenjem blage dijete — kuvana piletina sa pirincem u malim obrocima. Antiemetici Maropitant (Cerenia) i Metoklopramid kontrolisu povracanje i mucninu. Inhibitori protonske pumpe poput Omeprazola ili H2 blokatori poput Famotidina smanjuju lucenje zeludacne kiseline i stite sluzokzu. Sukralfat stvara zastitni sloj preko ostecene sluznice zeluca i pomaze zarastanju. Infuziona terapija je neophodna kod dehidriranih zivotinja za nadoknadu tecnosti i elektrolita. Kod hronicnog gastritisa uzrokovanog Helicobacter infekcijom, koristi se trojna terapija: Amoksicilin, Metronidazol i Omeprazol. Obavezno posetite veterinara ako povracanje traje duze od 24 sata, ako je prisutna krv u povracenom sadrzaju ili ako zivotinja pokazuje znake dehidracije.',
  ),
  PetCondition(
    id: 'epilepsy',
    name: 'Epilepsija',
    description: 'Epilepsija je hronicni neuroloski poremecaj karakterisan ponavljanim epileptickim napadima (konvulzijama) usled abnormalne elektricne aktivnosti u mozgu. Idiopatska epilepsija (bez poznatog uzroka) je najcesci oblik kod pasa i obicno se javlja izmedju 1. i 5. godine zivota. Sekundarni napadi mogu biti uzrokovani tumorima mozga, encefalitisom, trovanjem ili metabolickim poremecajima.',
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
    treatment: 'Fenobarbiton (Fenobarbital) je antiepileptik prvog izbora kod pasa i daje se oralno dva puta dnevno, sa redovnim pracentem nivoa leka u krvi svakih 6 meseci. Kalijum-bromid (KBr) se koristi kao dodatna terapija ili alternativa kod pasa koji ne tolerisu Fenobarbiton. Levetiracetam (Keppra) je noviji antiepileptik sa manje nuspojava na jetru i moze se koristiti samostalno ili u kombinaciji. Zonisamid je jos jedna opcija za pse sa rezistentnom epilepsijom. Dijeta obogacena MCT uljima (srednje-lancane masne kiseline iz kokosovog ulja) je klinicki dokazano smanjila ucestalost napada kod pasa. Tokom napada, vlasnik ne treba stavljati ruke u usta zivotinje vec osigurati bezbedan prostor i beleziti trajanje napada. Obavezno posetite veterinara hitno ako napad traje duze od 5 minuta (status epileptikus) ili ako se jave klasteri napada — Diazepam rektalno se koristi kao hitna terapija.',
  ),
  PetCondition(
    id: 'anemia',
    name: 'Anemija',
    description: 'Anemija je smanjenje broja crvenih krvnih zrnaca ili hemoglobina u krvi, sto dovodi do nedovoljnog snabdevanja tkiva kiseonikom. Moze biti regenerativna (usled krvarenja ili hemolize, gde kostna srz aktivno proizvodi nove eritrocite) ili neregenerativna (usled bolesti kostne srzi, hronicne bubrezne bolesti ili nutritivnog deficita). Uzroci ukljucuju parazite (buhe, krpelji), autoimune bolesti, trovanja i hronicne infekcije.',
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
    treatment: 'Lecenje anemije zavisi od uzroka i tezine stanja. Kod teske anemije (hematokrit ispod 15%) potrebna je hitna transfuzija krvi. Autoimuna hemoliticka anemija (AIHA) se leci imunosupresivnim dozama Prednizolona, a u rezistentnim slucajevima se dodaju Azatioprin (kod pasa) ili Hlorambucil (kod macaka) i Mikofenolat-mofetil. Kod anemije uzrokovane parazitima krvi (Babesia, Mycoplasma haemofelis), koriste se antiparazitici Imidokarb-dipropionat ili antibiotik Doksiciklin. Suplementacija gvozdjem (fero-sulfat) i vitaminom B12 je vazna kod nutritivnih deficita. Eritropoetin (Epoetin alfa) se daje kod anemije uzrokovane hronicnom bubreznom bolescu. Doksiciklin je lek izbora za erlihiozu i anaplazmozu koje su cesti uzroci anemije kod pasa. Obavezno posetite veterinara hitno ako su desni blede ili bele — kompletna krvna slika i retikulocitni broj su neophodni za dijagnozu.',
  ),
  PetCondition(
    id: 'cushing',
    name: 'Kusingov sindrom',
    description: 'Hiperadrenokorticizam (Kusingov sindrom) je endokrini poremecaj uzrokovan hronicnim viskom kortizola u organizmu, najcesce zbog tumora hipofize (85% slucajeva) ili tumora nadbubreznne zlezde. Visak kortizola izaziva razgradnju misica, redistribuciju masti, potiskivanje imunog sistema i niz metabolickih poremecaja. Bolest je najcesca kod pasa srednjih i starijih godina, a retko se javlja kod macaka.',
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
    treatment: 'Trilostane (Vetoryl) je lek prvog izbora za lecenje Kusingovog sindroma kod pasa — inhibira sintezu kortizola u nadbubreznnim zlezdama i daje se jednom ili dva puta dnevno sa hranom. Doza se titrira na osnovu ACTH stimulacionog testa koji se radi 4-6 sati posle davanja leka. Mitotan (Lysodren) je alternativni lek koji razara tkivo nadbubreznne zlezde, ali ima vise nuspojava i zahteva pazljivije pracenje. Kod tumora nadbubreznne zlezde, hirurska adrenalektomija moze biti kurativna opcija. Ketokonazol se ponekad koristi kao privremena terapija za smanjenje nivoa kortizola. Redovne kontrole ACTH stimulacionog testa i elektrolita su neophodne svakih 3-6 meseci. Obavezno posetite veterinara hitno ako pas pokazuje znake Adisonove krize (letargija, povracanje, kolaps) — to moze ukazivati na predoziranje lekom i zahteva hitnu infuzionu terapiju.',
  ),
  PetCondition(
    id: 'constipation',
    name: 'Zatvor',
    description: 'Zatvor (konstipacija) je otezano ili retko praznjenje creva sa tvrdim i suvim fecesom, a moze napredovati do opstipacije (teska konstipacija) ili megakolona (trajno prosirenje debelog creva sa gubitkom motiliteta). Najcesci uzroci su dehidracija, nedostatak vlakana, nedovoljna fizicka aktivnost, bolovi u karlici ili perianalna oboljenja. Kod macaka je megakolon ozbiljno stanje koje moze zahtevati hirursku intervenciju.',
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
    treatment: 'Lecenje zatvora pocinje povecanjem unosa vlakana (bundeva, psilium) i vode u ishrani, kao i prelaskom na vlaznu hranu. Laktuloza je osmotski laksativ prvog izbora koji omeksava stolicu privlacenjem vode u creva i daje se oralno 2-3 puta dnevno. Cisaprid je prokinetik koji stimulise motilitet debelog creva i koristi se kod hronicne konstipacije, narocito kod macaka. Kod teske opstipacije, veterinar vrsi manuelnu evakuaciju fecesa pod opstom anestezijom uz ispiranje toplim fiziloskim rastvorom. Polietilen-glikol (MiraLAX) se moze dodavati hrani kao osmotski laksativ. Subkutana infuzija tecnosti pomaze kod dehidriranih zivotinja. Kod macaka sa megakolonom koji ne reaguje na terapiju, subtotalna kolektomija (hirursko uklanjanje dela debelog creva) moze biti neophodna. Obavezno posetite veterinara ako zivotinja nije imala stolicu vise od 48 sati ili ako pokazuje znake bola i naprezanja.',
  ),
  // ==================== ZIVINA ====================
  PetCondition(
    id: 'newcastle',
    name: 'Njukasl bolest',
    description: 'Njukasl bolest (Newcastle disease) je visoko kontagiozna virusna bolest ptica izazvana paramiksovirusom serotip 1 (APMV-1) koja napada respiratorni, nervni i digestivni sistem. Velogeni sojevi izazivaju mortalitet do 100% kod nevakcinisanih jata. Bolest je prijavljiva drzavnim veterinarskim sluzbama i podleze obaveznim merama kontrole i eradikacije.',
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
    treatment: 'Ne postoji specificna antivirusna terapija za Njukasl bolest — lecenje je iskljucivo suportivno i simptomatsko. Elektroliti i vitamini (narocito vitamin E, C i B kompleks) se dodaju u vodu za pice radi podrske imunom sistemu i prevencije dehidracije. Antibiotici poput Enrofloksacina ili Amoksicilina se daju za prevenciju sekundarnih bakterijskih infekcija respiratornog trakta. Obolele ptice se izoluju od zdravih i drze na toplom sa lako dostupnom hranom i vodom. Vakcinacija je najvaznija preventivna mera — koriste se zive atenuirane vakcine (La Sota, B1, Hitchner) u vodi za pice ili sprejom, i inaktivisane uljne vakcine injekciono. Dezinfekcija objekta se vrsi preparatima na bazi formalina, natrijum-hipohlorita ili kvaternernnih amonijumovih jedinjenja. Obavezno prijavite sumnju na Njukasl bolest nadleznoj veterinarskoj inspekciji jer je to zakonska obaveza.',
  ),
  PetCondition(
    id: 'coccidiosis_poultry',
    name: 'Kokcidioza',
    description: 'Kokcidioza je parazitska bolest creva izazvana protozoom iz roda Eimeria, koja razara crevnu sluzokzu i dovodi do krvarenja, malapsorpcije i dehidracije. Najcesce pogadja mlade ptice uzrasta 3-8 nedelja jer nemaju razvijen imunitet. Postoji vise vrsta Eimeria sa razlicitim tropizmom za delove creva — E. tenella napada cekume i izaziva najtezu krvavu formu.',
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
    treatment: 'Toltrazuril (Baycox) je antikokcidijalni lek prvog izbora koji se daje u vodi za pice tokom 2 uzastopna dana i deluje na sve razvojne stadijume parazita. Amprolium (Korvinal) je alternativa koja blokira metabolizam tiamina kod kokcidija i daje se 5-7 dana u vodi za pice. Sulfonamidi poput Sulfadimetoksina ili Sulfakinoksalina se takodje koriste, narocito u kombinaciji sa Trimetoprimom. Vitamin K se dodaje u vodu za pice za kontrolu krvarenja u crevima. Elektroliti i probiotici su neophodni za oporavak crevne flore i rehidraciju. Prevencija ukljucuje odrzavanje suve prostirke, redovnu dezinfekciju podova preparatima na bazi amonijaka ili kreozola (kokcidije su otporne na vecinu standardnih dezinficijenasa), i koristenje hrane sa kokcidiostatikom (Salinomicin, Monenzin) kod mladih pilica. Obavezno posetite veterinara za koproloski pregled (flotacija) radi identifikacije vrste Eimeria i procene intenziteta infekcije.',
  ),
  PetCondition(
    id: 'avian_influenza',
    name: 'Pticji grip',
    description: 'Avijarni influenca virus (AIV) je visoko patogeni virus iz porodice Orthomyxoviridae koji izaziva sistemsku infekciju sa mortalitetom do 100% kod zivine. Podtipovi H5N1 i H7N9 su od posebnog znacaja jer imaju zoonotski potencijal — mogu se preneti na ljude. Bolest je prijavljiva Svetskoj organizaciji za zdravlje zivotinja (WOAH) i podleze obaveznim merama eradikacije.',
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
    treatment: 'Ne postoji specificno lecenje za pticji grip — kod visoko patogenih sojeva (HPAI) zakonski je obavezno eutanaziranje zarazenog jata i dezinfekcija objekta. Kod nisko patogenih sojeva (LPAI), suportivna terapija ukljucuje elektrolite, vitamine (A, C, E) i probiotike u vodi za pice. Antibiotici poput Enrofloksacina se daju iskljucivo za prevenciju sekundarnih bakterijskih infekcija. Stroga biosigurnosna mera ukljucuje karantin, kontrolu pristupa divljih ptica, dezinfekciju obuce i opreme preparatima na bazi natrijum-hipohlorita ili formalina. Vakcinacija je dostupna u nekim zemljama ali je u EU zabranjena za komercijalna jata osim u izuzetnim okolnostima. Svi sumnjivi slucajevi se moraju prijaviti nadleznoj veterinarskoj inspekciji u roku od 24 sata. Obavezno nosite zastitnu opremu (masku, rukavice) pri kontaktu sa obolelim pticama jer virus ima zoonotski potencijal.',
  ),
  PetCondition(
    id: 'infectious_bronchitis',
    name: 'Infektivni bronhitis',
    description: 'Infektivni bronhitis (IB) je akutna, visoko kontagiozna virusna bolest kokosi izazvana koronavirusom (IBV) koja primarno napada respiratorni trakt, ali moze ostetiti i bubrege i reproduktivni sistem. Virus ima brojne serotipove sto otezava vakcinaciju jer imunitet na jedan soj ne stiti od drugog. Kod nosiljki izaziva znacajan pad nosivosti i deformisana jaja sa mekom ili hrapavom ljuskom.',
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
    treatment: 'Ne postoji specificna antivirusna terapija za infektivni bronhitis — lecenje je suportivno i usmereno na prevenciju sekundarnih bakterijskih infekcija. Antibiotici poput Tilosina, Enrofloksacina ili Amoksicilina se daju u vodi za pice za kontrolu sekundarnih bakterijskih infekcija (E. coli, Mycoplasma). Vitamini A, C i E se dodaju u vodu za pice za podrsku imunom sistemu i oporavak respiratornih sluznica. Elektroliti sprecavaju dehidraciju, narocito kod mladih pilica. Objekat treba zagrejati na optimalnu temperaturu i obezbediti dobru ventilaciju bez promaje. Vakcinacija zivim atenuiranim vakcinama (H120, Ma5, 4/91) je osnovna preventivna mera i sprovodi se vec od prvog dana zivota. Dezinfekcija objekta izmedju turnusa preparatima na bazi formalina ili glutaraldehida je neophodna. Obavezno posetite veterinara za seroloski pregled jata i prilagodjavanje vakcinacionog programa.',
  ),
  PetCondition(
    id: 'marek',
    name: 'Marekova bolest',
    description: 'Marekova bolest je virusna neoplasticna bolest kokosi izazvana herpes virusom (Gallid alphaherpesvirus 2) koji izaziva limfoidne tumore u nervima, kozi, misicima i unutrasnjim organima. Virus se siri vazdusnim putem preko perjane prasine i izuzetno je otporan u spoljasnjoj sredini — moze preziveti mesecima u prasini kokosinjca. Najcesce pogadja mlade kokosi uzrasta 12-24 nedelje, a vakcinacija jednodnevnih pilica je jedina efikasna preventivna mera.',
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
    treatment: 'Ne postoji lecenje za Marekovu bolest — jednom zarazene ptice ostaju dozivotni nosioci virusa. Vakcinacija jednodnevnih pilica HVT (herpes virus curica) vakcinom u inkubatorskoj stanici je jedina efikasna preventivna mera i mora se primeniti pre izlaganja virusu. Obolele ptice sa tumorima ili paralizom se eutanaziraju jer nema izgleda za oporavak. Suportivna terapija za blaze slucajeve ukljucuje vitamine E i selen za podrsku imunom sistemu, visokoprotesinsku hranu i izolaciju od zdravih ptica. Stroga biosigurnost je kljucna — redovno ciscenje i dezinfekcija objekta preparatima na bazi formalina, uklanjanje perjane prasine i kontrola ventilacije. Nove ptice se moraju vakcinisati i drzati u karantinu minimum 2 nedelje pre uvodjenja u jato. Obavezno posetite veterinara za patoloski pregled uginulih ptica i potvrdu dijagnoze histopatologijom.',
  ),
  PetCondition(
    id: 'egg_binding',
    name: 'Zastoj jajeta',
    description: 'Zastoj jajeta (egg binding) je hitno stanje u kome zenka ne moze da polozi formirano jaje, najcesce zbog deficita kalcijuma koji oslabljuje kontrakcije jajovoda, prevelikog ili deformisanog jajeta, ili opsteg slabljenja organizma. Stanje je zivotno ugrozavajuce jer moze dovesti do peritonitisa, prolapsa kloake, sepse i smrti u roku od 24-48 sati. Najcesce pogadja mlade zenke pri prvom nosenju, hronicne nosiljke i ptice na neadekvatnoj ishrani.',
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
    treatment: 'Zastoj jajeta je hitno stanje koje zahteva brzu intervenciju. Prva pomoc ukljucuje stavljanje ptice u toplu i vlaznu sredinu (30-32°C) jer toplota relaksira misice jajovoda i pomaze polaganju. Kalcijum-glukonat se daje oralno ili injekciono (intramuskularno ili intravenski kod veterinara) za jacanje kontrakcija jajovoda. Lubrikacija kloake vazelinom ili vodenim gelom moze olaksati prolaz jajeta. Oksitocin se daje injekciono kod veterinara za stimulaciju kontrakcija, ali samo ako je potvrdeno da jaje nije preveliko i da nema opstrukcije. Ako konzervativne metode ne uspeju u roku od nekoliko sati, veterinar vrsi ovocentezu — aspiraciju sadrzaja jajeta iglom kroz kloaku, nakon cega se ljuska lakse izvadi. Prevencija ukljucuje obezbedjivanje adekvatnog kalcijuma (sipina kost za papagaje, mlevene ljuske jaja za zivinu) i vitamina D3 u ishrani. Obavezno posetite veterinara hitno jer nelecen zastoj jajeta moze dovesti do peritonitisa i smrti.',
  ),
  PetCondition(
    id: 'bumblefoot',
    name: 'Pododermatitis (Bumblefoot)',
    description: 'Pododermatitis (bumblefoot) je bakterijska infekcija stopala najcesce izazvana Staphylococcus aureus bakterijom koja ulazi kroz male rane ili abrazije na tabanima. Infekcija napreduje od blagog crvenila i otoka do formiranja apscesa sa karakteristicnom crnom krastom na tabanu. Predisponirajuci faktori su gojaznost, tvrde i neadekvatne podloge, nedostatak vitamina A i smanjena aktivnost.',
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
    treatment: 'Lecenje pododermatitisa zavisi od stadijuma bolesti. U ranom stadijumu (crvenilo i blagi otok), dovoljno je poboljsati podlogu (meka prostirka), dodati vitamin A u ishranu i aplicirati antibiotsku mast (Mupirocin ili Neomicin). U naprednom stadijumu sa formiranim apscesom, potrebna je hirurska intervencija — incizija, drenaza gnoja i uklanjanje nekroticnog tkiva (jezgra apscesa). Rana se ispira razblazenim Hlorheksidinom ili Betadinom i previja sterilnim zavojem koji se menja svakodnevno. Sistemski antibiotici poput Cefaleksina ili Amoksicilina sa klavulanskom kiselinom se daju 2-4 nedelje za kontrolu infekcije. Meloksikam se koristi za kontrolu bola i upale. Prevencija ukljucuje obezbedjivanje mekih podloga (gumene obloge na preckama), odrzavanje ciste i suve prostirke i kontrolu telesne mase. Obavezno posetite veterinara za procenu stadijuma bolesti i eventualni hirurski zahvat jer nelecen bumblefoot moze dovesti do osteomijelitisa (infekcije kostiju).',
  ),
  // ==================== GOLUBOVI ====================
  PetCondition(
    id: 'paramyxovirus',
    name: 'Paramiksoviroza (PMV)',
    description: 'Paramiksoviroza golubova je virusna bolest nervnog sistema izazvana paramiksovirusom serotip 1 (PPMV-1), varijantom Njukasl virusa adaptiranom na golubove. Virus napada centralni nervni sistem i bubrege, izazivajuci karakteristicne neuroloske simptome poput uvijanja vrata (tortikolis) i gubitka ravnoteze. Bolest je visoko kontagiozna i siri se direktnim kontaktom, kontaminiranom hranom i vodom, a mortalitet kod nevakcinisanih golubova moze dostici 30-50%.',
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
    treatment: 'Ne postoji specificna antivirusna terapija za paramiksovirusu golubova — lecenje je iskljucivo suportivno. Vitamin B kompleks (narocito B1, B6 i B12) se daje injekciono ili oralno za podrsku nervnom sistemu i moze poboljsati neuroloske simptome. Elektroliti i glukoza se dodaju u vodu za pice za prevenciju dehidracije i odrzavanje energije. Oboleli golubovi se izoluju u toplom, mirnom prostoru i hrane rucno ako ne mogu sami da jedu — meko seme ili kasa se ubacuje direktno u voljku pomocu sonde. Antibiotici poput Enrofloksacina ili Amoksicilina se daju za prevenciju sekundarnih bakterijskih infekcija. Probiotici pomazu oporavku crevne flore. Vakcinacija inaktivisanom uljnom vakcinom (Colombovac PMV, Nobilis Paramyxo) je jedina pouzdana preventivna mera i daje se jednom godisnje. Obavezno posetite veterinara za potvrdu dijagnoze i plan lecenja — oporavak moze trajati 4-8 nedelja, a neki golubovi zadrze blage neuroloske sekvele.',
  ),
  PetCondition(
    id: 'canker',
    name: 'Trihomonijaza (Canker)',
    description: 'Trihomonijaza (canker) je parazitska bolest izazvana protozoom Trichomonas gallinae koji inficira gornji digestivni trakt — usnu duplju, jednjak i voljku. Parazit izaziva karakteristicne zuckaste kazeinozne naslage (plakove) u grlu koje mogu potpuno blokirati jednjak i dovesti do ugusenja ili gladovanja. Bolest se prenosi direktnim kontaktom, kontaminiranom vodom i hranjenjem mladunaca — roditelji prenose parazita na ptice u gnezdu.',
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
    treatment: 'Metronidazol (Flagyl) je lek prvog izbora za lecenje trihomonijaze i daje se oralno 5-7 dana u dozi od 10-30 mg/kg dnevno. Ronidazol je alternativni antiprotozoalni lek koji se koristi kod sojeva rezistentnih na Metronidazol. Karnidazol (Spartrix) je takodje efikasan i cesto se koristi kod golubova kao jednokratna doza. Kod teskih slucajeva sa velikim naslagama u grlu, veterinar moze mehanicki ukloniti plakove pre pocetka terapije. Obolele ptice se hrane mekom hranom ili kasom pomocu sonde ako ne mogu same da gutaju. Dezinfekcija pojilica i hranilica je obavezna jer se parazit prenosi kontaminiranom vodom — koristiti preparate na bazi amonijum-jedinjenja. Preventivno lecenje celokupnog jata se preporucuje jer su mnogi golubovi asimptomatski nosioci. Obavezno posetite veterinara za pregled usne duplje i mikroskopski nalaz brisa grla radi potvrde dijagnoze.',
  ),
  PetCondition(
    id: 'pigeon_salmonella',
    name: 'Salmoneloza (Paratifus)',
    description: 'Salmoneloza golubova je bakterijska infekcija izazvana najcesce Salmonella typhimurium varijantom Copenhagen koja napada creva, zglobove, nervni sistem i reproduktivne organe. Bolest ima vise klinickih oblika — crevni (proliv), zglobni (artritis), nervni (tortikolis) i organski (hepatitis, nefritis). Bakterija se izlucuje fecesom i kontaminira hranu i vodu, a moze preziveti mesecima u spoljasnjoj sredini.',
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
    treatment: 'Enrofloksacin (Baytril) je antibiotik prvog izbora za lecenje salmoneloza kod golubova i daje se oralno u vodi za pice 10-14 dana. Amoksicilin sa klavulanskom kiselinom je alternativa, narocito kod sojeva rezistentnih na fluorohinolone. Trimetoprim-sulfonamid (TMP-S) se takodje koristi kao efikasna terapija. Kod zglobnog oblika, lecenje traje duze (3-4 nedelje) i cesto zahteva kombinaciju antibiotika. Probiotici se daju posle zavrsetka antibiotske terapije za obnovu crevne flore. Temeljita dezinfekcija golubinjaka je obavezna — uklanjanje sve prostirke, pranje vrucim rastvorom sode i dezinfekcija preparatima na bazi formalina, krezola ili kvaternernnih amonijumovih jedinjenja. Hronicni nosioci koji stalno izlucuju bakteriju su izvor zaraze za celo jato i treba razmotriti njihovo uklanjanje. Obavezno posetite veterinara za bakterioloski pregled izmeta i antibiogram radi izbora najefikasnijeg antibiotika.',
  ),
  PetCondition(
    id: 'pigeon_worms',
    name: 'Crvi (Helmintijaza)',
    description: 'Helmintijaza je parazitska infekcija creva izazvana razlicitim vrstama crva — najcesci su oblici (Ascaridia), vlasoglavi (Capillaria) i pantljicari (cestode). Paraziti se hrane sadrzajem creva ili krvlju domacina, izazivajuci malapsorpciju, anemiju i ostecenje crevne sluznice. Infekcija se siri fekalnim putem — jaja parazita se izlucuju izmetom i kontaminiraju hranu, vodu i podlogu, a neke vrste koriste intermedijarne domacine (puzeve, insekte).',
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
    treatment: 'Levamizol je antihelmintik sirokog spektra koji se koristi za lecenje oblica (Ascaridia) i daje se oralno ili u vodi za pice. Fenbendazol (Panacur) je siguran i efikasan lek protiv oblica i vlasoglava (Capillaria) i daje se 3-5 uzastopnih dana. Prazikvantel je lek izbora za pantljicaru (cestode) i daje se kao jednokratna doza. Ivermektin se koristi za lecenje oblica i ektoparazita, ali je kontraindikovan kod nekih vrsta papagaja. Dehelmintizacija se ponavlja posle 14 dana da bi se eliminisale larve koje su u medjuvremenu sazrele. Probiotici i vitamini (narocito A i gvozdje) se daju posle terapije za oporavak crevne sluznice i korekciju anemije. Prevencija ukljucuje redovnu koprologiju (pregled izmeta) svakih 3-6 meseci, odrzavanje ciste prostirke i dezinfekciju podova preparatima na bazi krezola. Obavezno posetite veterinara za koproloski pregled radi identifikacije vrste parazita i izbora odgovarajuceg antihelmintika.',
  ),
  PetCondition(
    id: 'ornithosis',
    name: 'Ornitoza (Hlamidija)',
    description: 'Ornitoza (hlamidioza) je bakterijska infekcija izazvana obligatnim intracelularnim patogenom Chlamydia psittaci koji napada respiratorni trakt, oci i unutrasnje organe ptica. Bolest je zoonoza — moze se preneti na ljude inhalacijom kontaminirane prasine iz izmeta, perja ili nosnog sekreta zarazenih ptica, izazivajuci atipicnu pneumoniju. Kod ptica bolest moze biti akutna, hronicna ili latentna, pri cemu asimptomatski nosioci aktivno sire infekciju.',
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
    treatment: 'Doksiciklin je antibiotik prvog izbora za lecenje ornitoze i daje se oralno 21-45 dana (minimum 21 dan je obavezan za eliminaciju intracelularne bakterije). Kod golubova se Doksiciklin najcesce daje u hrani pomesanoj sa uljem da se obezbedi adekvatna apsorpcija. Enrofloksacin je alternativa kod ptica koje ne tolerisu Doksiciklin. Tokom lecenja, kalcijum se ne daje jer smanjuje apsorpciju Doksiciklina — ukloniti grit i mineralne blokove. Vitamini A i C se dodaju u ishranu za podrsku imunom sistemu i oporavak respiratornih sluznica. Dezinfekcija prostora je obavezna preparatima na bazi kvaternernnih amonijumovih jedinjenja ili natrijum-hipohlorita jer je bakterija osetljiva na vecinu dezinficijenasa. Vlasnici moraju nositi zastitnu masku i rukavice pri kontaktu sa obolelim pticama zbog zoonotskog rizika. Obavezno posetite veterinara za PCR dijagnostiku i prijavite slucaj nadleznoj sluzbi jer je ornitoza prijavljiva bolest.',
  ),
  // ==================== PAPAGAJI ====================
  PetCondition(
    id: 'pbfd',
    name: 'PBFD (Bolest perja i kljuna)',
    description: 'PBFD (Psittacine Beak and Feather Disease) je virusna bolest izazvana cirkovirusom (BFDV) koja napada celije perja, kljuna i imunog sistema papagaja. Virus razara folikule perja i matrice kljuna, izazivajuci progresivni gubitak perja, deformacije kljuna i tesku imunosupresiju. Bolest je najcesca kod kakadua, africkih sivih papagaja i loriusa, a kod mladih ptica cesto ima fatalan ishod.',
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
    treatment: 'Ne postoji specificna antivirusna terapija niti vakcina za PBFD — lecenje je iskljucivo suportivno i usmereno na jacanje imunog sistema i prevenciju sekundarnih infekcija. Visokokvalitetna ishrana bogata vitaminom A (sargarepa, batat, brokoli), proteinima i antioksidansima je osnova podrske. Sekundarne bakterijske infekcije se lece antibioticima poput Amoksicilina sa klavulanskom kiselinom ili Enrofloksacina, a gljivicne infekcije Itrakonazolom. Interferon omega (rekombinantni macjii interferon) se eksperimentalno koristi za podrsku imunom sistemu kod nekih ptica. Zarazene ptice se moraju strogo izolovati od zdravih jer se virus siri perjanom prasinom i direktnim kontaktom. Dezinfekcija kaveza i opreme se vrsi preparatima na bazi natrijum-hipohlorita (varikina) jer je cirkovirus izuzetno otporan u spoljasnjoj sredini. Obavezno posetite avijarnnog veterinara za PCR testiranje krvi ili perja radi potvrde dijagnoze i procene prognoze.',
  ),
  PetCondition(
    id: 'psittacosis',
    name: 'Psitakoza (Papagajska groznica)',
    description: 'Psitakoza je bakterijska infekcija izazvana Chlamydia psittaci koja kod papagaja izaziva respiratorne probleme, hepatitis i enteritis. Bolest je identicna ornitozi kod golubova ali se termin psitakoza tradicionalno koristi za infekciju kod papagaja (Psittaciformes). Ovo je ozbiljna zoonoza — zarazene ptice izlucuju bakteriju izmetom i nosnim sekretom, a ljudi se inficiraju inhalacijom kontaminirane prasine.',
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
    treatment: 'Doksiciklin je antibiotik prvog izbora za lecenje psitakoze i mora se davati minimum 45 dana kod papagaja da bi se potpuno eliminisala intracelularna bakterija. Kod malih papagaja (tigrica, nimfa), Doksiciklin se moze davati injekciono (Vibravenos) svakih 5-7 dana kod veterinara. Tokom terapije Doksiciklinom, ukloniti sve izvore kalcijuma (sipina kost, mineralni blokovi, grit) jer kalcijum smanjuje apsorpciju leka. Enrofloksacin je alternativni antibiotik ali je manje efikasan od Doksiciklina za hlamidiju. Suportivna terapija ukljucuje vitamine A i C, probiotike i elektrolite za podrsku imunom sistemu i prevenciju dehidracije. Dezinfekcija kaveza i okoline se vrsi preparatima na bazi kvaternernnih amonijumovih jedinjenja ili razblazenom varikinom. Vlasnici moraju nositi zastitnu masku pri ciscenju kaveza i kontaktu sa obolelom pticom. Obavezno posetite avijarnnog veterinara za PCR dijagnostiku i prijavite slucaj jer je psitakoza prijavljiva zoonoza.',
  ),
  PetCondition(
    id: 'aspergillosis',
    name: 'Aspergiloza',
    description: 'Aspergiloza je gljivicna infekcija respiratornog sistema izazvana najcesce vrstom Aspergillus fumigatus cije se spore nalaze svuda u okolini — u zemlji, trulom drvetu, plesnivoj hrani i vlaznim prostorima. Kod zdravih ptica imuni sistem kontrolise spore, ali stres, imunosupresija, nedostatak vitamina A i losa higijena predisponiraju razvoj bolesti. Gljivica formira granulome (aspergillome) u vazdusnim kesama i plucima, postepeno ugrozavajuci disanje.',
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
    treatment: 'Lecenje aspergiloze je dugotrajno (6-12 nedelja ili duze) i zahteva kombinaciju sistemske i lokalne antifungalne terapije. Itrakonazol je antifungalni lek prvog izbora koji se daje oralno jednom ili dva puta dnevno. Vorikonazol je noviji i potentniji azolni antifungal koji se koristi kod teskih ili rezistentnih slucajeva. Amfotericin B se daje inhalaciono (nebulizacijom) direktno u respiratorni trakt za lokalno dejstvo na gljivicu u vazdusnim kesama. Kod velikih aspergilloma, hirursko uklanjanje endoskopskim putem moze biti neophodno. Terbinafin se ponekad koristi u kombinaciji sa azolima za sinergisticko dejstvo. Prevencija ukljucuje odrzavanje ciste i suve okoline, izbegavanje plesnive hrane i prostirke, obezbedjivanje adekvatne ventilacije i ishrane bogate vitaminom A. Obavezno posetite avijarnnog veterinara za rendgen, endoskopiju vazdusnih kesa i kulturu gljivica radi potvrde dijagnoze i pracenja odgovora na terapiju.',
  ),
  PetCondition(
    id: 'feather_plucking',
    name: 'Cupanje perja',
    description: 'Cupanje perja (feather destructive behavior) je kompleksno stanje kod papagaja koje moze imati medicinske uzroke (kozne infekcije, paraziti, alergije, bolest jetre, deficit vitamina A ili kalcijuma) ili bihejvioralne uzroke (dosada, stres, anksioznost, nedostatak socijalne interakcije). Papagaji su visoko inteligentne i socijalne ptice kojima je potrebna mentalna stimulacija, a cupanje perja je cesto manifestacija nezadovoljenih potreba. Dijagnoza zahteva sistematsko iskljucivanje medicinskih uzroka pre nego sto se zakljuci da je problem bihejvioralni.',
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
    treatment: 'Lecenje cupanja perja zahteva sveobuhvatan pristup. Prvo se moraju iskljuciti medicinski uzroci — kompletna krvna slika, biohemija, testovi na PBFD, hlamidiju i aspergilozu. Kod koznih infekcija koriste se antibiotici (Cefaleksin) ili antifungalni lekovi (Itrakonazol). Prelazak sa dijete bazirane na semenu na kvalitetni pelet sa svezim vocem i povrcem koriguje nutritivne deficite. Kod bihejvioralnog cupanja, obogacivanje okoline (foraging igracke, puzzle hranilice, grane za grickanje) i povecanje socijalne interakcije su kljucni. Haloperidol ili Klomipramin se koriste kao poslednja opcija kod teskih psihogenih slucajeva pod nadzorom avijarnnog veterinara. Elizabetinski okovratnik se privremeno koristi da spreci samopovredjivanje dok se utvrdi i leci uzrok. Obavezno posetite avijarnnog veterinara za kompletnu dijagnostiku i konsultaciju sa specijalistom za ponasanje ptica.',
  ),
  PetCondition(
    id: 'avian_gastric_yeast',
    name: 'Megabakterijoza (AGY)',
    description: 'Megabakterijoza (Avian Gastric Yeast — AGY) je gljivicna infekcija zeluca izazvana organizmom Macrorhabdus ornithogaster (ranije poznatim kao megabakterija) koji kolonizuje zidove proventrikulusa (zlezdanog zeluca). Gljivica ostecuje sluzokzu zeluca, smanjuje lucenje zeludacne kiseline i dovodi do malapsorpcije hranljivih materija. Najcesce pogadja tigrice, kanarince i male papagaje, a bolest moze biti akutna ili hronicna sa postepenim mrsavljenjem.',
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
    treatment: 'Amfotericin B oralno je lek prvog izbora za lecenje megabakterioze i daje se direktno u kljun dva puta dnevno tokom 10-14 dana. Natrijum-benzoat zakiseljava sredinu u zelucu i stvara nepovoljne uslove za rast gljivice — dodaje se u vodu za pice. Razblazeno jabucno sirce (5 ml na 100 ml vode) se koristi kao pomocna mera za zakiseljavanje zeluca. Nistatin je alternativni antifungalni lek ali je manje efikasan od Amfotericina B za ovu gljivicu. Ishrana se prilagodjava — prelazak na pelet i svezo povrce umesto semena, jer secer iz semena pogoduje rastu gljivice. Probiotici pomazu u obnovi zdrave mikroflore zeluca i creva. Lecenje se cesto mora ponavljati jer su recidivi cesti, narocito u stresnim periodima ili kod imunosuprimiranih ptica. Obavezno posetite avijarnnog veterinara za mikroskopski pregled izmeta (bojenje po Gramu) radi potvrde dijagnoze i pracenja odgovora na terapiju.',
  ),
  PetCondition(
    id: 'vitamin_a_deficiency',
    name: 'Nedostatak vitamina A',
    description: 'Hipovitaminoza A je jedan od najcescih nutritivnih problema kod papagaja koji se hrane iskljucivo semenskom mesavinom, jer seme (narocito suncokret i proso) sadrzi vrlo malo vitamina A i beta-karotena. Vitamin A je esencijalan za zdravlje epitelijalnih tkiva — sluznica respiratornog, digestivnog i urogenitalnog trakta, koze i ociju. Deficit dovodi do metaplazije sluznica (zamene normalnog epitela keratinizovanim), sto predisponira hronicne respiratorne infekcije, sinuzitis i formiranje belihh plakova u ustima.',
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
    treatment: 'Lecenje pocinje korekcijom ishrane — postepeni prelazak sa semenskih mesavina na kvalitetni formulisani pelet koji sadrzi adekvatne nivoe vitamina A, uz svakodnevno nudenje svezeg povrca bogatog beta-karotenom (sargarepa, batat, brokoli, paprika, spanac). Kod teskog deficita, veterinar daje vitamin A injekciono (retinol-palmitat) za brzu korekciju, ali oprezno jer predoziranje vitaminom A je toksinno. Oralna suplementacija vitaminom A u kapima se daje prema uputstvu veterinara. Sekundarne respiratorne infekcije uzrokovane metaplazijom sluznica se lece antibioticima poput Doksiciklina ili Amoksicilina. Bele plakove (apscese) u ustima veterinar hirurski uklanja i ispira antiseptickim rastvorom. Prevencija je jednostavna — raznovrsna ishrana sa peletom kao osnovom (60-70%) i svezim vocem i povrcem (30-40%), uz minimalno seme. Obavezno posetite avijarnnog veterinara za krvne analize i procenu stepena deficita, narocito ako ptica ima hronicne respiratorne probleme.',
  ),
  PetCondition(
    id: 'fatty_liver',
    name: 'Masna jetra (Hepaticka lipidoza)',
    description: 'Hepaticka lipidoza (masna jetra) je metabolicki poremecaj kod papagaja uzrokovan prekomernim nakupljanjem masti u cellijama jetre, najcesce kao posledica visokokaloricne dijete bogate masnim semenjem (suncokret, kikiriki) i nedovoljne fizicke aktivnosti. Bolest je narocito cesta kod amazonki, tigrica i rozela. Ostecenje jetre dovodi do poremecaja metabolizma, koagulacije i detoksikacije, a u tezim slucajevima moze biti fatalno.',
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
    treatment: 'Lecenje masne jetre kod papagaja zahteva drasticnu promenu ishrane — potpuno uklanjanje masnog semena (suncokret, kikiriki, konoplja) i prelazak na kvalitetni niskomasni pelet sa svezim povrcem i umerenom kolicinom voca. Laktuloza se daje oralno za smanjenje nivoa amonijaka u krvi i rasterecenje jetre. Silimarin (ekstrakt sikavice) i S-adenozilmetionin (SAMe) su hepatoprotektori koji pomazu u regeneraciji celija jetre. Vitamin E i selen se dodaju kao antioksidansi za zastitu hepatocita od oksidativnog ostecenja. Podsticanje fizicke aktivnosti (letenje u sobi, vece prostorije, igracke) je neophodno za sagorevanje viska masti. Kod teskih slucajeva sa anoreksijom, veterinar primenjuje asistiranu ishranu sondom i infuzionu terapiju. Obavezno posetite avijarnnog veterinara za krvne analize (zucne kiseline, AST, holesterol) i ultrazvuk jetre radi procene stepena ostecenja i pracenja oporavka.',
  ),
];
