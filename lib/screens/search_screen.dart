import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:html' as html;
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).popUntil((route) => route.isFirst),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      ClipRRect(borderRadius: BorderRadius.circular(10),
                        child: Image.asset('assets/images/logo.png', width: 32, height: 32)),
                      const SizedBox(width: 8),
                      Text(l.appTitle, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    ]),
                  ),
                ),
                const SizedBox(height: 8),
                Row(children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: GlassCard(padding: const EdgeInsets.all(10), borderRadius: 14,
                      child: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textSecondary, size: 18))),
                  const SizedBox(width: 12),
                  Text(l.shopSearch, style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                ]),
              ]),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  Text(l.searchShopsHint, style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary))
                      .animate().fadeIn(duration: 400.ms),
                  const SizedBox(height: 16),
                  _ShopTile(label: 'Pet Centar', color: const Color(0xFFE65100),
                    onTap: () => html.window.open('https://www.pet-centar.rs/', '_blank')),
                  const SizedBox(height: 10),
                  _ShopTile(label: 'PetSpot', color: const Color(0xFF2E7D32),
                    onTap: () => html.window.open('https://petspot.rs/catalogsearch/result/?q=', '_blank')),
                  const SizedBox(height: 10),
                  _ShopTile(label: 'Premium Pet', color: const Color(0xFF1565C0),
                    onTap: () => html.window.open('https://www.premiumpet.rs/', '_blank')),
                  const SizedBox(height: 10),
                  _ShopTile(label: 'Ananas', color: const Color(0xFF6A1B9A),
                    onTap: () => html.window.open('https://ananas.rs/search?query=hrana+za+ljubimce', '_blank')),
                  const SizedBox(height: 10),
                  _ShopTile(label: 'Plus Plus', color: const Color(0xFFD32F2F),
                    onTap: () => html.window.open('https://www.plusplus.co.rs/', '_blank')),
                  const SizedBox(height: 10),
                  _ShopTile(label: 'dm', color: const Color(0xFF008FD5),
                    onTap: () => html.window.open('https://www.dm.rs/search?query=kucni%20ljubimci&searchProviderType=dm-products', '_blank')),
                  const SizedBox(height: 10),
                  _ShopTile(label: 'iHerb', color: const Color(0xFF3B7A57),
                    onTap: () => html.window.open('https://www.iherb.com/c/pet-care', '_blank')),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShopTile extends StatefulWidget {
  final String label; final Color color; final VoidCallback onTap;
  const _ShopTile({required this.label, required this.color, required this.onTap});
  @override
  State<_ShopTile> createState() => _ShopTileState();
}

class _ShopTileState extends State<_ShopTile> {
  bool _hovering = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          transform: _hovering ? (Matrix4.identity()..translate(4.0, 0.0)) : Matrix4.identity(),
          decoration: BoxDecoration(
            color: _hovering ? AppColors.card.withOpacity(0.95) : AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _hovering ? widget.color.withOpacity(0.3) : AppColors.glassBorder),
            boxShadow: _hovering ? [BoxShadow(color: widget.color.withOpacity(0.12), blurRadius: 16, offset: const Offset(0, 4))] : null,
          ),
          child: Row(children: [
            Container(width: 44, height: 44,
              decoration: BoxDecoration(color: widget.color.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
              child: Icon(Icons.shopping_bag_outlined, color: widget.color, size: 22)),
            const SizedBox(width: 14),
            Expanded(child: Text(widget.label, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary))),
            Icon(Icons.open_in_new_rounded, color: _hovering ? widget.color : AppColors.textMuted, size: 18),
          ]),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms);
  }
}
