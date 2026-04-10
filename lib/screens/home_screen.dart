import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:html' as html;
import '../data/conditions_database.dart';
import '../l10n/app_localizations.dart';
import '../l10n/localized_condition.dart';
import '../l10n/locale_provider.dart';
import '../main.dart';
import '../theme/app_theme.dart';
import '../utils/text_utils.dart';
import 'condition_screen.dart';
import 'symptom_checker_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PetType _selectedPet = PetType.dog;
  String _searchQuery = '';

  List<PetCondition> get _filteredConditions {
    final lang = localeProvider.locale.languageCode;
    final bySpecies = allConditions
        .where((c) => c.affectedSpecies.contains(_selectedPet))
        .toList();
    if (_searchQuery.isEmpty) return bySpecies;
    return bySpecies
        .where((c) => containsNormalized(localizedName(c, lang), _searchQuery))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lang = l.lang;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(top: -60, right: -40,
            child: _GlowOrb(color: Colors.white, size: 220, opacity: 0.1)),
          Positioned(bottom: 80, left: -60,
            child: _GlowOrb(color: Colors.white, size: 180, opacity: 0.08)),
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header with logo + language toggle
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset('assets/images/logo.png', width: 48, height: 48),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(l.appTitle,
                                    style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white)),
                                  const SizedBox(height: 2),
                                  Text(l.appSubtitle,
                                    style: GoogleFonts.inter(fontSize: 14, color: Colors.white70)),
                                ],
                              ),
                            ),
                            // Language toggle
                            GestureDetector(
                              onTap: () => localeProvider.toggleLocale(),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                                ),
                                child: Text(
                                  lang == 'sr' ? '🇬🇧 EN' : '🇷🇸 SR',
                                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.15, end: 0),

                        const SizedBox(height: 20),

                        // Pretraga prodavnica dugme
                        _ShopSearchButton(l: l),

                        const SizedBox(height: 12),

                        // Find a vet button
                        _FindVetButton(l: l),

                        const SizedBox(height: 12),

                        // Provera simptoma dugme
                        GestureDetector(
                          onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const SymptomCheckerScreen())),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [AppColors.primary, Color(0xFF5B4AE0)]),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 16, offset: const Offset(0, 6))],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.search_rounded, color: Colors.white, size: 22),
                                const SizedBox(width: 10),
                                Text(l.symptomChecker,
                                  style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                              ],
                            ),
                          ),
                        ).animate().fadeIn(delay: 250.ms, duration: 400.ms),

                        const SizedBox(height: 24),

                        // Izbor vrste
                        Wrap(
                          spacing: 10, runSpacing: 10,
                          children: PetType.values.map((type) {
                            return _PetToggle(
                              label: _localizedPetType(type, l),
                              isSelected: _selectedPet == type,
                              onTap: () => setState(() { _selectedPet = type; _searchQuery = ''; }),
                            );
                          }).toList(),
                        ).animate().fadeIn(delay: 300.ms, duration: 400.ms),

                        const SizedBox(height: 20),

                        // Pretraga bolesti + naslov
                        Row(
                          children: [
                            Text(l.healthConditions,
                              style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
                            const Spacer(),
                            Text('${_filteredConditions.length}',
                              style: GoogleFonts.inter(fontSize: 14, color: Colors.white70)),
                          ],
                        ).animate().fadeIn(delay: 350.ms, duration: 400.ms),

                        const SizedBox(height: 10),

                        // Search field
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.glassBorder),
                          ),
                          child: TextField(
                            style: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 15),
                            decoration: InputDecoration(
                              hintText: l.searchConditions,
                              hintStyle: GoogleFonts.inter(color: AppColors.textMuted),
                              prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textMuted, size: 20),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            ),
                            onChanged: (v) => setState(() => _searchQuery = v),
                          ),
                        ).animate().fadeIn(delay: 380.ms, duration: 400.ms),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                // Condition cards
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final condition = _filteredConditions[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _ConditionCard(
                            condition: condition,
                            lang: lang,
                            onTap: () => Navigator.push(context,
                              MaterialPageRoute(builder: (_) => ConditionScreen(condition: condition))),
                          ),
                        ).animate()
                            .fadeIn(delay: Duration(milliseconds: 400 + index * 60), duration: 400.ms)
                            .slideY(begin: 0.1, end: 0);
                      },
                      childCount: _filteredConditions.length,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 32)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _localizedPetType(PetType type, AppLocalizations l) {
    switch (type) {
      case PetType.dog: return l.dogs;
      case PetType.cat: return l.cats;
      case PetType.rabbit: return l.rabbits;
      case PetType.rodent: return l.rodents;
      case PetType.bird: return l.birds;
      case PetType.terrarium: return l.terrarium;
      case PetType.aquarium: return l.aquarium;
    }
  }
}

class _GlowOrb extends StatelessWidget {
  final Color color;
  final double size;
  final double opacity;
  const _GlowOrb({required this.color, required this.size, required this.opacity});
  @override
  Widget build(BuildContext context) {
    return Container(width: size, height: size,
      decoration: BoxDecoration(shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color.withOpacity(opacity), color.withOpacity(0)])));
  }
}

class _PetToggle extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _PetToggle({required this.label, required this.isSelected, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isSelected ? AppColors.accent : AppColors.card,
          boxShadow: isSelected ? [BoxShadow(color: AppColors.accent.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))] : null,
        ),
        child: Text(label,
          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.textSecondary)),
      ),
    );
  }
}

class _ConditionCard extends StatelessWidget {
  final PetCondition condition;
  final String lang;
  final VoidCallback onTap;
  const _ConditionCard({required this.condition, required this.lang, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(width: 50, height: 50,
              decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.12), borderRadius: BorderRadius.circular(14)),
              child: Center(child: Text(condition.icon, style: const TextStyle(fontSize: 26)))),
            const SizedBox(width: 16),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(localizedName(condition, lang), style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Text(localizedDescription(condition, lang), maxLines: 2, overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(fontSize: 13, color: AppColors.textMuted, height: 1.3)),
              ]),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textMuted, size: 16),
          ],
        ),
      ),
    );
  }
}

class _ShopSearchButton extends StatefulWidget {
  final AppLocalizations l;
  const _ShopSearchButton({required this.l});
  @override
  State<_ShopSearchButton> createState() => _ShopSearchButtonState();
}

class _ShopSearchButtonState extends State<_ShopSearchButton> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final l = widget.l;
    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF1E3A5F), Color(0xFF2C5282)]),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: const Color(0xFF1E3A5F).withOpacity(0.3), blurRadius: 16, offset: const Offset(0, 6))],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.shopping_bag_rounded, color: Colors.white, size: 22),
                const SizedBox(width: 10),
                Text(l.shopSearch,
                  style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                const SizedBox(width: 8),
                AnimatedRotation(
                  turns: _expanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white70, size: 22),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              children: [
                _ShopTile(label: 'Pet Centar', icon: Icons.shopping_bag_outlined, color: const Color(0xFFE65100),
                  onTap: () => html.window.open('https://www.pet-centar.rs/products/', '_blank')),
                const SizedBox(height: 8),
                _ShopTile(label: 'PetSpot', icon: Icons.shopping_bag_outlined, color: const Color(0xFF2E7D32),
                  onTap: () => html.window.open('https://petspot.rs/catalogsearch/result/?q=', '_blank')),
                const SizedBox(height: 8),
                _ShopTile(label: 'Premium Pet', icon: Icons.shopping_bag_outlined, color: const Color(0xFF1565C0),
                  onTap: () => html.window.open('https://www.premiumpet.rs/', '_blank')),
                const SizedBox(height: 8),
                _ShopTile(label: 'Ananas', icon: Icons.shopping_bag_outlined, color: const Color(0xFF6A1B9A),
                  onTap: () => html.window.open('https://ananas.rs/search?query=hrana+za+ljubimce', '_blank')),
              ],
            ),
          ),
          crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 250),
        ),
      ],
    );
  }
}

class _ShopTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _ShopTile({required this.label, required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: color)),
            ),
            Icon(Icons.open_in_new_rounded, color: color.withOpacity(0.6), size: 16),
          ],
        ),
      ),
    );
  }
}

class _FindVetButton extends StatefulWidget {
  final AppLocalizations l;
  const _FindVetButton({required this.l});
  @override
  State<_FindVetButton> createState() => _FindVetButtonState();
}

class _FindVetButtonState extends State<_FindVetButton> {
  bool _loading = false;

  void _findVet() {
    setState(() => _loading = true);

    html.window.navigator.geolocation.getCurrentPosition().then((position) {
      final lat = position.coords!.latitude;
      final lng = position.coords!.longitude;
      final query = Uri.encodeComponent('veterinar');
      html.window.open(
        'https://www.google.com/maps/search/$query/@$lat,$lng,14z',
        '_blank',
      );
      setState(() => _loading = false);
    }).catchError((_) {
      // Fallback: open Google Maps search without coordinates
      final query = Uri.encodeComponent('veterinar near me');
      html.window.open('https://www.google.com/maps/search/$query', '_blank');
      setState(() => _loading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = widget.l;
    return GestureDetector(
      onTap: _loading ? null : _findVet,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF059669), Color(0xFF10B981)]),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: const Color(0xFF059669).withOpacity(0.3), blurRadius: 16, offset: const Offset(0, 6))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_loading)
              const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            else
              const Icon(Icons.local_hospital_rounded, color: Colors.white, size: 22),
            const SizedBox(width: 10),
            Text(l.findVetNearby,
              style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 270.ms, duration: 400.ms);
  }
}
