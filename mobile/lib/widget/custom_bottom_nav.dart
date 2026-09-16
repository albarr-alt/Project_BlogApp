import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTapNav;
  final VoidCallback onAddPost;
  final VoidCallback onOpenProfile;

  static const Color paper = Color(0xffFBFAF5);
  static const Color ink = Color(0xff1A1B18);
  static const Color accent = Color(0xff3F5D4E);
  static const Color meta = Color(0xff8C8676);
  static const Color line = Color(0xffE6E3D6);

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTapNav,
    required this.onAddPost,
    required this.onOpenProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 36),
      decoration: BoxDecoration(
        color: paper.withValues(alpha: 0.96),
        border: const Border(top: BorderSide(color: line, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Beranda
          _NavHoverItem(
            icon: Icons.home_filled,
            label: 'Beranda',
            isActive: currentIndex == 0,
            onTap: () => onTapNav(0),
          ),

          // Tombol Tengah Tambah (+) dengan Hover
          _FabHoverButton(onTap: onAddPost),

          // Profil
          _NavHoverItem(
            icon: Icons.person_outline_rounded,
            label: 'Profil',
            isActive: false,
            onTap: onOpenProfile,
          ),
        ],
      ),
    );
  }
}

class _NavHoverItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavHoverItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_NavHoverItem> createState() => _NavHoverItemState();
}

class _NavHoverItemState extends State<_NavHoverItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: _isHovered
                ? const Color(0xffF1EFE6).withValues(alpha: 0.8)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                size: 24,
                color: widget.isActive
                    ? const Color(0xff3F5D4E)
                    : (_isHovered
                        ? const Color(0xff1A1B18)
                        : const Color(0xff8C8676)),
              ),
              const SizedBox(height: 3),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: widget.isActive
                      ? const Color(0xff1A1B18)
                      : (_isHovered
                          ? const Color(0xff1A1B18)
                          : const Color(0xff8C8676)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FabHoverButton extends StatefulWidget {
  final VoidCallback onTap;

  const _FabHoverButton({required this.onTap});

  @override
  State<_FabHoverButton> createState() => _FabHoverButtonState();
}

class _FabHoverButtonState extends State<_FabHoverButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          margin: const EdgeInsets.only(bottom: 16),
          width: _isHovered ? 56 : 52,
          height: _isHovered ? 56 : 52,
          decoration: BoxDecoration(
            color: _isHovered
                ? const Color(0xff3F5D4E)
                : const Color(0xff1A1B18),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xff14140f).withValues(
                  alpha: _isHovered ? 0.42 : 0.28,
                ),
                blurRadius: _isHovered ? 20 : 15,
                offset: Offset(0, _isHovered ? 8 : 6),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.add,
              color: Color(0xffFBFAF5),
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}
