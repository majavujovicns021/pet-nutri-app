import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:html' as html;
import '../data/conditions_database.dart';
import '../l10n/app_localizations.dart';
import '../l10n/localized_condition.dart';
import '../main.dart';
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
  String _scoreFilter = 'all';

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
      setState(() { _allResults = scores; _filteredResults = scores; _loading = false; _initialLoaded = true; });
    } catch (e) {
      final l = AppLocalizations.of(context);
      setState(() { _error = l.errorLoading; _loading = false; });
    }
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    if (query.trim().isEmpty) { setState(() => _filteredResults = _allResults); return; }
    _debounce = Timer(const Duration(milliseconds: 500), () => _search(query.trim()));
  }

  Future<void> _search(String query) async {
    setState(() { _loading = true; _error = null; });
    try {
      final products = await PetFoodApi.search(query);
      final scores = products.map((p) => FoodScorer.evaluate(p, widget.condition)).toList()
        ..sort((a, b) => b.score.compareTo(a.score));
      setState(() { _filteredResults = scores; _loading = false; });
    } catch (e) {
      final l = AppLocalizations.of(context);
      setState(() { _error = l.errorSearch; _loading = false; });
    }
  }

  @override
  void dispose() { _debounce?.cancel(); _searchController.dispose(); super.dispose(); }

  Color _scoreColor(int score) {
    if (score >= 75) return AppColors.success;
    if (score >= 55) return AppColors.success;
    if (score >= 35) return AppColors.warning;
    return AppColors.danger;
  }

  String _scoreLabel(int score, AppLocalizations l) {
    if (score >= 75) return l.recommended;
    if (score >= 55) return l.good;
    if (score >= 35) return l.average;
    return l.avoid;
  }

  IconData _scoreIcon(int score) {
    if (score >= 75) return Icons.star_rounded;
    if (score >= 55) return Icons.check_circle_outline_rounded;
    if (score >= 35) return Icons.info_outline_rounded;
    return Icons.dangerous_rounded;
  }

  Color _scoreIconColor(int score) {
    if (score >= 75) return AppColors.warning;
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
    final l = AppLocalizations.of(context);
    final lang = l.lang;
    final cName = localizedName(c, lang);
    final cDesc = localizedDescription(c, lang);
    final cTreatment = localizedTreatment(c, lang);
    final cGuidelines = localizedGuidelines(c, lang);

    return Scaffold(
      body: Stack(
        children: [
          Positioned(top: -40, left: -40,
            child: Container(width: 200, height: 200,
              decoration: BoxDecoration(shape: BoxShape.circle,
                gradient: RadialGradient(colors: [AppColors.primary.withOpacity(0.15), Colors.transparent])))),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: GlassCard(padding: const EdgeInsets.all(10), borderRadius: 14,
                          child: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textSecondary, size: 18))),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text('${c.icon} $cName',
                          style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                          overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      const SizedBox(height: 8),
                      Text(cDesc, style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary, height: 1.5))
                          .animate().fadeIn(duration: 400.ms),
                      const SizedBox(height: 20),
                      Text(l.dietaryGuidelines, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary))
                          .animate().fadeIn(delay: 100.ms, duration: 400.ms),
                      const SizedBox(height: 12),
                      ...cGuidelines.asMap().entries.map((entry) {
                        final g = entry.value;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: GlassCard(
                            padding: const EdgeInsets.all(14),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Row(children: [
                                _RecommendationBadge(g.recommendation, l),
                                const SizedBox(width: 10),
                                Expanded(child: Text(g.nutrient, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary))),
                              ]),
                              const SizedBox(height: 8),
                              Text(g.reason, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted, height: 1.3)),
                            ]),
                          ),
                        ).animate().fadeIn(delay: Duration(milliseconds: 200 + entry.key * 80), duration: 400.ms);
                      }),
                      const SizedBox(height: 24),
                      Text(l.treatmentAndTherapy, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary))
                          .animate().fadeIn(delay: 300.ms, duration: 400.ms),
                      const SizedBox(height: 12),
                      GlassCard(
                        padding: const EdgeInsets.all(16),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(children: [
                            Icon(Icons.medical_services_rounded, color: AppColors.primary, size: 20),
                            const SizedBox(width: 8),
                            Text(l.recommendedTherapy, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primary)),
                          ]),
                          const SizedBox(height: 10),
                          Text(cTreatment, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary, height: 1.6)),
                        ]),
                      ).animate().fadeIn(delay: 350.ms, duration: 400.ms),
                      const SizedBox(height: 24),

                      // Search section - only for dogs and cats
                      if (c.affectedSpecies.contains(PetType.dog) || c.affectedSpecies.contains(PetType.cat)) ...[
                        Text(l.searchFood, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                        const SizedBox(height: 6),
                        Text(l.searchFoodHint(cName), style: GoogleFonts.inter(fontSize: 13, color: AppColors.textMuted)),
                        const SizedBox(height: 14),
                        Container(
                          decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.glassBorder)),
                          child: TextField(
                            controller: _searchController,
                            style: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 15),
                            decoration: InputDecoration(
                              hintText: l.searchFoodPlaceholder,
                              hintStyle: GoogleFonts.inter(color: AppColors.textMuted),
                              prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textMuted, size: 20),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14)),
                            onChanged: _onSearchChanged)),
                        const SizedBox(height: 20),
                        if (_filteredResults.isNotEmpty)
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(children: [
                              _FilterChip(label: l.all, isSelected: _scoreFilter == 'all', onTap: () => setState(() => _scoreFilter = 'all')),
                              const SizedBox(width: 8),
                              _FilterChip(label: '⭐ ${l.recommended}', isSelected: _scoreFilter == 'recommended', color: AppColors.success, onTap: () => setState(() => _scoreFilter = 'recommended')),
                              const SizedBox(width: 8),
                              _FilterChip(label: '✓ ${l.good}', isSelected: _scoreFilter == 'good', color: AppColors.success, onTap: () => setState(() => _scoreFilter = 'good')),
                              const SizedBox(width: 8),
                              _FilterChip(label: l.average, isSelected: _scoreFilter == 'average', color: AppColors.warning, onTap: () => setState(() => _scoreFilter = 'average')),
                              const SizedBox(width: 8),
                              _FilterChip(label: '✕ ${l.avoid}', isSelected: _scoreFilter == 'bad', color: AppColors.danger, onTap: () => setState(() => _scoreFilter = 'bad')),
                            ])),
                        const SizedBox(height: 12),
                        if (_loading) const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator(color: AppColors.primary))),
                        if (_error != null) Padding(padding: const EdgeInsets.all(16), child: Text(_error!, textAlign: TextAlign.center, style: GoogleFonts.inter(color: AppColors.danger, fontSize: 14))),
                        if (_initialLoaded && _visibleResults.isEmpty && !_loading)
                          Padding(padding: const EdgeInsets.all(32), child: Text(l.noResultsForFilter, textAlign: TextAlign.center, style: GoogleFonts.inter(color: AppColors.textMuted, fontSize: 14))),
                        if (_visibleResults.isNotEmpty)
                          ...(_visibleResults.asMap().entries.map((entry) {
                            final fs = entry.value;
                            return Padding(padding: const EdgeInsets.only(bottom: 12),
                              child: _FoodResultCard(foodScore: fs, scoreColor: _scoreColor(fs.score), scoreLabel: _scoreLabel(fs.score, l), scoreIcon: _scoreIcon(fs.score), scoreIconColor: _scoreIconColor(fs.score), l: l))
                                .animate().fadeIn(delay: Duration(milliseconds: entry.key * 80), duration: 400.ms).slideY(begin: 0.05, end: 0);
                          })),
                      ],
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
  final AppLocalizations l;
  const _RecommendationBadge(this.recommendation, this.l);

  @override
  Widget build(BuildContext context) {
    final (color, label) = switch (recommendation) {
      'high' => (AppColors.success, l.highLabel),
      'moderate' => (AppColors.accent, l.moderateLabel),
      'low' => (AppColors.warning, l.lowLabel),
      'avoid' => (AppColors.danger, l.avoidLabel),
      _ => (AppColors.textMuted, recommendation),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
      child: Text(label, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
    );
  }
}

class _FoodResultCard extends StatelessWidget {
  final FoodScore foodScore;
  final Color scoreColor;
  final String scoreLabel;
  final IconData scoreIcon;
  final Color scoreIconColor;
  final AppLocalizations l;

  const _FoodResultCard({required this.foodScore, required this.scoreColor, required this.scoreLabel, required this.scoreIcon, required this.scoreIconColor, required this.l});

  @override
  Widget build(BuildContext context) {
    final fs = foodScore;
    final product = fs.product;
    return GestureDetector(
      onTap: () => html.window.open(product.productUrl, '_blank'),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            ClipRRect(borderRadius: BorderRadius.circular(12),
              child: product.imageUrl != null
                  ? Image.network(product.imageUrl!, width: 56, height: 56, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _ImagePlaceholder())
                  : _ImagePlaceholder()),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(product.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              const SizedBox(height: 2),
              Text(product.brand, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted)),
            ])),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(color: scoreColor.withOpacity(0.12), borderRadius: BorderRadius.circular(12), border: Border.all(color: scoreColor.withOpacity(0.3))),
              child: Column(children: [
                Icon(scoreIcon, color: scoreIconColor, size: 20),
                const SizedBox(height: 2),
                Text(scoreLabel, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: scoreColor)),
              ]),
            ),
          ]),
          const SizedBox(height: 10),
          if (fs.pros.isNotEmpty) ...[
            const SizedBox(height: 10),
            ...fs.pros.take(3).map((p) => Padding(padding: const EdgeInsets.only(bottom: 3),
              child: Row(children: [
                const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 14),
                const SizedBox(width: 6),
                Expanded(child: Text(p, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary))),
              ]))),
          ],
          if (fs.cons.isNotEmpty) ...[
            const SizedBox(height: 6),
            ...fs.cons.take(3).map((c) => Padding(padding: const EdgeInsets.only(bottom: 3),
              child: Row(children: [
                const Icon(Icons.cancel_rounded, color: AppColors.danger, size: 14),
                const SizedBox(width: 6),
                Expanded(child: Text(c, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary))),
              ]))),
          ],
          const SizedBox(height: 12),
          Text('${l.whereToBuy}:', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textMuted)),
          const SizedBox(height: 6),
          _ScrollableShopRow(
            children: [
              _ShopButton(label: 'Pet Centar', color: const Color(0xFFE65100), onTap: () {
                final brand = product.brand;
                final q = (brand.isNotEmpty && brand != 'Nepoznat brend') ? Uri.encodeComponent(brand).toLowerCase().replaceAll('%20', '-') : '';
                html.window.open('https://www.pet-centar.rs/products/$q', '_blank');
              }),
              const SizedBox(width: 8),
              _ShopButton(label: 'PetSpot', color: const Color(0xFF2E7D32), onTap: () {
                final brand = product.brand;
                final q = (brand.isNotEmpty && brand != 'Nepoznat brend') ? Uri.encodeComponent(brand) : '';
                html.window.open('https://petspot.rs/catalogsearch/result/?q=$q', '_blank');
              }),
              const SizedBox(width: 8),
              _ShopButton(label: 'Premium Pet', color: const Color(0xFF1565C0), onTap: () {
                final brand = product.brand;
                final q = (brand.isNotEmpty && brand != 'Nepoznat brend') ? Uri.encodeComponent(brand) : '';
                html.window.open('https://www.premiumpet.rs/g/f/Search=$q', '_blank');
              }),
              const SizedBox(width: 8),
              _ShopButton(label: 'Ananas', color: const Color(0xFF6A1B9A), onTap: () {
                final brand = product.brand;
                final q = (brand.isNotEmpty && brand != 'Nepoznat brend') ? Uri.encodeComponent(brand) : '';
                html.window.open('https://ananas.rs/search?query=$q', '_blank');
              }),
            ],
          ),
        ]),
      ),
    );
  }
}

class _ShopButton extends StatefulWidget {
  final String label; final Color color; final VoidCallback onTap;
  const _ShopButton({required this.label, required this.color, required this.onTap});
  @override
  State<_ShopButton> createState() => _ShopButtonState();
}

class _ShopButtonState extends State<_ShopButton> {
  bool _hovering = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: widget.color.withOpacity(_hovering ? 0.25 : 0.15),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: widget.color.withOpacity(_hovering ? 0.6 : 0.3))),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.shopping_bag_outlined, color: widget.color, size: 14),
            const SizedBox(width: 4),
            Text(widget.label, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: widget.color)),
          ]))));
  }
}

class _FilterChip extends StatefulWidget {
  final String label; final bool isSelected; final Color? color; final VoidCallback onTap;
  const _FilterChip({required this.label, required this.isSelected, this.color, required this.onTap});
  @override
  State<_FilterChip> createState() => _FilterChipState();
}

class _FilterChipState extends State<_FilterChip> {
  bool _hovering = false;
  @override
  Widget build(BuildContext context) {
    final c = widget.color ?? AppColors.primary;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(onTap: widget.onTap,
      child: AnimatedContainer(duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: widget.isSelected ? c.withOpacity(0.15) : _hovering ? c.withOpacity(0.08) : AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: widget.isSelected ? c.withOpacity(0.5) : _hovering ? c.withOpacity(0.3) : AppColors.glassBorder)),
        child: Text(widget.label, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600,
          color: widget.isSelected ? c : _hovering ? c.withOpacity(0.8) : AppColors.textMuted)))));
  }
}

class _ScrollableShopRow extends StatefulWidget {
  final List<Widget> children;
  const _ScrollableShopRow({required this.children});
  @override
  State<_ScrollableShopRow> createState() => _ScrollableShopRowState();
}

class _ScrollableShopRowState extends State<_ScrollableShopRow> {
  final _scrollController = ScrollController();
  bool _showArrow = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final atEnd = _scrollController.offset >= _scrollController.position.maxScrollExtent - 10;
    if (atEnd && _showArrow) setState(() => _showArrow = false);
    if (!atEnd && !_showArrow) setState(() => _showArrow = true);
  }

  @override
  void dispose() { _scrollController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        SingleChildScrollView(controller: _scrollController, scrollDirection: Axis.horizontal,
          child: Row(children: widget.children)),
        if (_showArrow)
          Positioned(right: 0,
            child: IgnorePointer(
              child: Container(
                padding: const EdgeInsets.only(left: 24, right: 4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [AppColors.card.withOpacity(0), AppColors.card])),
                child: const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textMuted, size: 14)))),
      ],
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 56, height: 56,
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(12)),
      child: const Icon(Icons.pets_rounded, color: AppColors.textMuted, size: 24));
  }
}
