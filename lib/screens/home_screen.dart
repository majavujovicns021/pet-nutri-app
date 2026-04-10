import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:html' as html;
import '../data/conditions_database.dart';
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
    final bySpecies = allConditions
        .where((c) => c.affectedSpecies.contains(_selectedPet))
        .toList();
    if (_searchQuery.isEmpty) return bySpecies;
    return bySpecies
        .where((c) => containsNormalized(c.name, _searchQuery))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(top: -60, right: -40,
            child: _GlowOrb(color: AppColors.primary, size: 220, opacity: 0.2)),
          Positioned(bottom: 80, left: -60,
            child: _GlowOrb(color: AppColors.accent, size: 180, opacity: 0.12)),
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
                        // Header with logo
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset('assets/images/logo.png', width: 48, height: 48),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('PetNutri',
                                  style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                                const SizedBox(height: 2),
                                Text('Pronadji najbolju hranu za ljubimca',
                                  style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary)),
                              ],
                            ),
                          ],
                        ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.15, end: 0),

                        const SizedBox(height: 20),

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
                                Text('Provera simptoma',
                                  style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                              ],
                            ),
                          ),
                        ).animate().fadeIn(delay: 250.ms, duration: 400.ms),

                        const SizedBox(height: 16),

                        // Gde kupiti sekcija
                        Text('Gde kupiti',
                          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                        ).animate().fadeIn(delay: 270.ms, duration: 400.ms),
                        const SizedBox(height: 10),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _ShopLink(label: 'Pet Centar', color: const Color(0xFFE65100),
                                onTap: () => html.window.open('https://www.pet-centar.rs/products/', '_blank')),
                              const SizedBox(width: 10),
                              _ShopLink(label: 'PetSpot', color: const Color(0xFF2E7D32),
                                onTap: () => html.window.open('https://petspot.rs/catalogsearch/result/?q=', '_blank')),
                              const SizedBox(width: 10),
                              _ShopLink(label: 'Premium Pet', color: const Color(0xFF1565C0),
                                onTap: () => html.window.open('https://www.premiumpet.rs/', '_blank')),
                              const SizedBox(width: 10),
                              _ShopLink(label: 'Ananas', color: const Color(0xFF6A1B9A),
                                onTap: () => html.window.open('https://ananas.rs/search?query=hrana+za+ljubimce', '_blank')),
                            ],
                          ),
                        ).animate().fadeIn(delay: 280.ms, duration: 400.ms),

                        const SizedBox(height: 24),

                        // Izbor vrste
                        Wrap(
                          spacing: 10, runSpacing: 10,
                          children: PetType.values.map((type) {
                            return _PetToggle(
                              label: petTypeLabel(type),
                              isSelected: _selectedPet == type,
                              onTap: () => setState(() { _selectedPet = type; _searchQuery = ''; }),
                            );
                          }).toList(),
                        ).animate().fadeIn(delay: 300.ms, duration: 400.ms),

                        const SizedBox(height: 20),

                        // Pretraga bolesti + naslov
                        Row(
                          children: [
                            Text('Zdravstvena stanja',
                              style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                            const Spacer(),
                            Text('${_filteredConditions.length}',
                              style: GoogleFonts.inter(fontSize: 14, color: AppColors.textMuted)),
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
                              hintText: 'Pretrazi bolesti...',
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
          color: isSelected ? AppColors.primary : AppColors.card,
          boxShadow: isSelected ? [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))] : null,
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
  final VoidCallback onTap;
  const _ConditionCard({required this.condition, required this.onTap});
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
                Text(condition.name, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Text(condition.description, maxLines: 2, overflow: TextOverflow.ellipsis,
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

class _ShopLink extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ShopLink({required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.shopping_bag_outlined, color: color, size: 18),
            const SizedBox(width: 6),
            Text(label, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: color)),
            const SizedBox(width: 4),
            Icon(Icons.open_in_new_rounded, color: color.withOpacity(0.6), size: 14),
          ],
        ),
      ),
    );
  }
}
