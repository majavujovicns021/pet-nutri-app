import '../data/conditions_database.dart';
import 'pet_food_api.dart';

class FoodScore {
  final PetFoodProduct product;
  final int score;
  final List<String> pros;
  final List<String> cons;
  final String rating;

  FoodScore({
    required this.product,
    required this.score,
    required this.pros,
    required this.cons,
    required this.rating,
  });
}

class FoodScorer {
  static FoodScore evaluate(PetFoodProduct product, PetCondition condition) {
    int score = 50; // Bazni skor — neutralno
    final pros = <String>[];
    final cons = <String>[];

    final ingredientsLower = (product.ingredients ?? '').toLowerCase();
    final nameLower = product.name.toLowerCase();
    final brandLower = product.brand.toLowerCase();
    final combined = '$ingredientsLower $nameLower $brandLower';

    // Provera dobrih sastojaka
    int goodFound = 0;
    for (final good in condition.goodIngredients) {
      if (combined.contains(good.toLowerCase())) {
        goodFound++;
        if (goodFound <= 4) pros.add('Sadrzi: $good');
      }
    }
    score += (goodFound * 8).clamp(0, 40);

    // Provera losih sastojaka
    int badFound = 0;
    for (final bad in condition.badIngredients) {
      if (combined.contains(bad.toLowerCase())) {
        badFound++;
        if (badFound <= 3) cons.add('Sadrzi: $bad');
      }
    }
    score -= (badFound * 10).clamp(0, 40);

    // Bonus za nutritivne vrednosti
    score += _evaluateNutriments(product, condition, pros, cons);

    // Ako nema sastojaka uopste, ne mozemo oceniti — neutralno
    if (ingredientsLower.isEmpty && product.nutriments == null) {
      if (pros.isEmpty && cons.isEmpty) {
        pros.add('Nedovoljno podataka za detaljnu ocenu');
      }
    }

    score = score.clamp(0, 100);

    final rating = switch (score) {
      >= 75 => 'Preporuceno',
      >= 55 => 'Dobro',
      >= 35 => 'Prosecno',
      _ => 'Ne preporucuje se',
    };

    return FoodScore(
      product: product,
      score: score,
      pros: pros.toSet().toList(),
      cons: cons.toSet().toList(),
      rating: rating,
    );
  }

  static int _evaluateNutriments(
    PetFoodProduct product,
    PetCondition condition,
    List<String> pros,
    List<String> cons,
  ) {
    int bonus = 0;

    for (final g in condition.guidelines) {
      final nutrient = g.nutrient.toLowerCase();
      final rec = g.recommendation;

      if (nutrient.contains('mast') || nutrient.contains('fat')) {
        final fat = product.fatPer100g;
        if (fat != null) {
          if (rec == 'low' || rec == 'avoid') {
            if (fat < 8) {
              bonus += 8;
              pros.add('Nisko masti (${fat.toStringAsFixed(1)}g/100g)');
            } else if (fat > 15) {
              bonus -= 8;
              cons.add('Visoko masti (${fat.toStringAsFixed(1)}g/100g)');
            }
          } else if (rec == 'high') {
            if (fat > 12) {
              bonus += 6;
              pros.add('Dobar sadrzaj masti (${fat.toStringAsFixed(1)}g/100g)');
            }
          }
        }
      }

      if (nutrient.contains('protein')) {
        final protein = product.proteinPer100g;
        if (protein != null) {
          if (rec == 'high') {
            if (protein > 20) {
              bonus += 8;
              pros.add('Visok protein (${protein.toStringAsFixed(1)}g/100g)');
            }
          } else if (rec == 'low' || rec == 'moderate') {
            if (protein < 22) {
              bonus += 6;
              pros.add('Umeren protein (${protein.toStringAsFixed(1)}g/100g)');
            } else if (protein > 35) {
              bonus -= 6;
              cons.add('Previse proteina (${protein.toStringAsFixed(1)}g/100g)');
            }
          }
        }
      }

      if (nutrient.contains('vlakna') || nutrient.contains('fiber')) {
        final fiber = product.fiberPer100g;
        if (fiber != null && rec == 'high') {
          if (fiber > 2) {
            bonus += 6;
            pros.add('Dobra vlakna (${fiber.toStringAsFixed(1)}g/100g)');
          }
        }
      }

      if (nutrient.contains('natrijum') || nutrient.contains('sodium') || nutrient.contains('so')) {
        final salt = product.saltPer100g;
        if (salt != null && (rec == 'low' || rec == 'avoid')) {
          if (salt < 0.5) {
            bonus += 6;
            pros.add('Nisko soli (${salt.toStringAsFixed(2)}g/100g)');
          } else if (salt > 1.5) {
            bonus -= 8;
            cons.add('Previse soli (${salt.toStringAsFixed(2)}g/100g)');
          }
        }
      }

      if (nutrient.contains('kalorij') || nutrient.contains('energy')) {
        final kcal = product.energyKcal;
        if (kcal != null && rec == 'low') {
          if (kcal < 300) {
            bonus += 6;
            pros.add('Niskokaloricno (${kcal.toStringAsFixed(0)} kcal/100g)');
          } else if (kcal > 400) {
            bonus -= 6;
            cons.add('Visokokaloricno (${kcal.toStringAsFixed(0)} kcal/100g)');
          }
        }
      }
    }

    return bonus;
  }
}
