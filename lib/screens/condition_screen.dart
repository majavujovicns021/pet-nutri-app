import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:html' as html;
import '../data/conditions_database.dart';
import '../services/food_scorer.dart';
import '../services/pet_food_api.dart';
import '../theme/app_theme.dart';

class ConditionScreen extends StatefulWidget {
  final PetCondition condition;

  const ConditionScreen({super.key, required this.condition});

  @override
  State<ConditionScreen> createState() => _ConditionScreenState();
}

class _ConditionScreenState extends State<ConditionScreen> {
  final _searchController = TextEditingController();
  List<FoodScore> _allResults = [];
  List<FoodScore> _filteredResults = [];
  bool _loading = false;
  bool _initialLoaded = false;
  String? _error;
  Timer? _debounce;
  String _scoreFilter = 'all'; // all, recommended, good, average, bad

  @override
  void initState() {
    super.initState();
    if (widget.condition.affectedSpecies.contains(PetType.dog) ||
        widget.condition.affectedSpecies.contains(PetType.cat)) {
      _loadInitialFood();
    }
  }

  Future<void> _loadInitialFood() async {
    setState(() { _loading = true; _error = null; });
    try {
      final products = await PetFoodApi.search('pet food');
      final scores = products
          .map((p) => FoodScorer.evaluate(p, widget.condition))
          .toList()
        ..sort((a, b) => b.score.compareTo(a.score));
      setState(() {
        _allResults = scores;
        _filteredResults = scores;
        _loading = false;
        _initialLoaded = true;
      });
    } catch (e) {
      setState(() {
        _error = 'Greska pri ucitavanju. Proveri internet konekciju.';
        _loading = false;
      });
    }
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    if (query.trim().isEmpty) {
      setState(() => _filteredResults = _allResults);
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _search(query.trim());
    });
  }

  Future<void> _search(String query) async {
    setState(() { _loading = true; _error = null; });
    try {
      final products = await PetFoodApi.search(query);
      final scores = products
          .map((p) => FoodScorer.evaluate(p, widget.condition))
          .toList()
        ..sort((a, b) => b.score.compareTo(a.score));
      setState(() {
        _filteredResults = scores;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Greska pri pretrazi. Proveri internet konekciju.';
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Color _scoreColor(int score) {
    if (score >= 75) return AppColors.success;  // zeleno — isto kao dobro
    if (score >= 55) return AppColors.success;  // zeleno
    if (score >= 35) return AppColors.warning;  // narandzasta
    return AppColors.danger;                    // crvena
  }

  String _scoreLabel(int score) {
    if (score >= 75) return 'Preporuceno';
    if (score >= 55) return 'Dobro';
    if (score >= 35) return 'Prosecno';
    return 'Izbegavaj';
  }

  IconData _scoreIcon(int score) {
    if (score >= 75) return Icons.star_rounded;  // zvezdica za preporuceno
    if (score >= 55) return Icons.check_circle_outline_rounded;
    if (score >= 35) return Icons.info_outline_rounded;
    return Icons.dangerous_rounded;
  }

  Color _scoreIconColor(int score) {
    if (score >= 75) return AppColors.warning; // zuta zvezdica
    return _scoreColor(score);
  }

  List<FoodScore> get _visibleResults {
    if (_scoreFilter == 'all') return _filteredResults;
    return _filteredResults.where((fs) {
      switch (_scoreFilter) {
        case 'recommended': return fs.score >= 75;
        case 'good': return fs.score >= 55 && fs.score < 75;
        case 'average': return fs.score >= 35 && fs.score < 55;
        case 'bad': return fs.score < 35;
        default: return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.condition;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -40,
            left: -40,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Top bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: GlassCard(
                          padding: const EdgeInsets.all(10),
                          borderRadius: 14,
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: AppColors.textSecondary,
                            size: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${c.icon} ${c.name}',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      const SizedBox(height: 8),

                      // Description
                      Text(
                        c.description,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ).animate().fadeIn(duration: 400.ms),

                      const SizedBox(height: 20),

                      // Dietary guidelines
                      Text(
                        'Dijetetske smernice',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ).animate().fadeIn(delay: 100.ms, duration: 400.ms),

                      const SizedBox(height: 12),

                      ...c.guidelines.asMap().entries.map((entry) {
                        final g = entry.value;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: GlassCard(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              children: [
                                _RecommendationBadge(g.recommendation),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        g.nutrient,
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        g.reason,
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          color: AppColors.textMuted,
                                          height: 1.3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                            .animate()
                            .fadeIn(
                              delay: Duration(
                                milliseconds: 200 + entry.key * 80,
                              ),
                              duration: 400.ms,
                            );
                      }),

                      const SizedBox(height: 24),

                      // Treatment section
                      Text(
                        'Lecenje i terapija',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ).animate().fadeIn(delay: 300.ms, duration: 400.ms),

                      const SizedBox(height: 12),

                      GlassCard(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.medical_services_rounded,
                                    color: AppColors.primary, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'Preporucena terapija',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              c.treatment,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(delay: 350.ms, duration: 400.ms),

                      const SizedBox(height: 24),

                      // Search section - only for dogs and cats
                      if (c.affectedSpecies.contains(PetType.dog) || c.affectedSpecies.contains(PetType.cat)) ...[
                      Text(
                        'Pretrazi hranu',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Ukucaj naziv hrane da vidis koliko je pogodna za ${c.name.toLowerCase()}',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Search input - live search
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.glassBorder),
                        ),
                        child: TextField(
                          controller: _searchController,
                          style: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 15),
                          decoration: InputDecoration(
                            hintText: 'npr. Royal Canin, Whiskas...',
                            hintStyle: GoogleFonts.inter(color: AppColors.textMuted),
                            prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textMuted, size: 20),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          ),
                          onChanged: _onSearchChanged,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Score filter chips
                      if (_filteredResults.isNotEmpty)
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _FilterChip(label: 'Sve', isSelected: _scoreFilter == 'all',
                                onTap: () => setState(() => _scoreFilter = 'all')),
                              const SizedBox(width: 8),
                              _FilterChip(label: '⭐ Preporuceno', isSelected: _scoreFilter == 'recommended',
                                color: AppColors.success,
                                onTap: () => setState(() => _scoreFilter = 'recommended')),
                              const SizedBox(width: 8),
                              _FilterChip(label: '✓ Dobro', isSelected: _scoreFilter == 'good',
                                color: AppColors.success,
                                onTap: () => setState(() => _scoreFilter = 'good')),
                              const SizedBox(width: 8),
                              _FilterChip(label: 'Prosecno', isSelected: _scoreFilter == 'average',
                                color: AppColors.warning,
                                onTap: () => setState(() => _scoreFilter = 'average')),
                              const SizedBox(width: 8),
                              _FilterChip(label: '✕ Izbegavaj', isSelected: _scoreFilter == 'bad',
                                color: AppColors.danger,
                                onTap: () => setState(() => _scoreFilter = 'bad')),
                            ],
                          ),
                        ),

                      const SizedBox(height: 12),

                      // Results
                      if (_loading)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32),
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          ),
                        ),

                      if (_error != null)
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            _error!,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: AppColors.danger,
                              fontSize: 14,
                            ),
                          ),
                        ),

                      if (_initialLoaded && _visibleResults.isEmpty && !_loading)
                        Padding(
                          padding: const EdgeInsets.all(32),
                          child: Text(
                            'Nema rezultata za izabrani filter.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: AppColors.textMuted,
                              fontSize: 14,
                            ),
                          ),
                        ),

                      if (_visibleResults.isNotEmpty)
                        ...(_visibleResults.asMap().entries.map((entry) {
                          final fs = entry.value;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _FoodResultCard(
                              foodScore: fs,
                              scoreColor: _scoreColor(fs.score),
                              scoreLabel: _scoreLabel(fs.score),
                              scoreIcon: _scoreIcon(fs.score),
                              scoreIconColor: _scoreIconColor(fs.score),
                            ),
                          )
                              .animate()
                              .fadeIn(
                                delay: Duration(
                                  milliseconds: entry.key * 80,
                                ),
                                duration: 400.ms,
                              )
                              .slideY(begin: 0.05, end: 0);
                        })),
                      ], // end search section if

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RecommendationBadge extends StatelessWidget {
  final String recommendation;
  const _RecommendationBadge(this.recommendation);

  @override
  Widget build(BuildContext context) {
    final (color, label) = switch (recommendation) {
      'high' => (AppColors.success, '↑ Visok'),
      'moderate' => (AppColors.accent, '~ Umeren'),
      'low' => (AppColors.warning, '↓ Nizak'),
      'avoid' => (AppColors.danger, '✕ Izbegavaj'),
      _ => (AppColors.textMuted, recommendation),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _FoodResultCard extends StatelessWidget {
  final FoodScore foodScore;
  final Color scoreColor;
  final String scoreLabel;
  final IconData scoreIcon;
  final Color scoreIconColor;

  const _FoodResultCard({
    required this.foodScore,
    required this.scoreColor,
    required this.scoreLabel,
    required this.scoreIcon,
    required this.scoreIconColor,
  });

  @override
  Widget build(BuildContext context) {
    final fs = foodScore;
    final product = fs.product;

    return GestureDetector(
      onTap: () {
        html.window.open(product.productUrl, '_blank');
      },
      child: GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Product image or placeholder
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: product.imageUrl != null
                    ? Image.network(
                        product.imageUrl!,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _ImagePlaceholder(),
                      )
                    : _ImagePlaceholder(),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      product.brand,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              // Score label
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: scoreColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: scoreColor.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    Icon(scoreIcon, color: scoreIconColor, size: 20),
                    const SizedBox(height: 2),
                    Text(
                      scoreLabel,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: scoreColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Pros
          if (fs.pros.isNotEmpty) ...[
            const SizedBox(height: 10),
            ...fs.pros.take(3).map(
                  (p) => Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle_rounded,
                            color: AppColors.success, size: 14),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            p,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          ],

          // Cons
          if (fs.cons.isNotEmpty) ...[
            const SizedBox(height: 6),
            ...fs.cons.take(3).map(
                  (c) => Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Row(
                      children: [
                        const Icon(Icons.cancel_rounded,
                            color: AppColors.danger, size: 14),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            c,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          ],
        ],
      ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color? color;
  final VoidCallback onTap;
  const _FilterChip({required this.label, required this.isSelected, this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.primary;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? c.withOpacity(0.15) : AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? c.withOpacity(0.5) : AppColors.glassBorder),
        ),
        child: Text(label,
          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600,
            color: isSelected ? c : AppColors.textMuted)),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.pets_rounded,
        color: AppColors.textMuted,
        size: 24,
      ),
    );
  }
}
