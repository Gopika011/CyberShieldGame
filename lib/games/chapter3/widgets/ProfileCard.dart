import 'package:flutter/material.dart';

class ProfileCard extends StatefulWidget {
  final String image, username, bio;
  final VoidCallback onSelected;
  
  const ProfileCard({
    super.key,
    required this.image,
    required this.username,
    required this.bio,
    required this.onSelected,
  });

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late AnimationController _scanController;
  late Animation<double> _hoverAnimation;
  late Animation<double> _scanAnimation;
  bool _isHovered = false;
  bool _isSelected = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _scanController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
    
    _hoverAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );
    
    _scanAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scanController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _scanController.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isSelected = true;
    });
    widget.onSelected();
  }

  Widget _buildScanLine() {
    return AnimatedBuilder(
      animation: _scanAnimation,
      builder: (context, child) {
        return Positioned(
          top: _scanAnimation.value * 200,
          left: 0,
          right: 0,
          child: Container(
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  const Color(0xFF00D4FF).withOpacity(0.8),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileImage() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: _isSelected 
              ? const Color(0xFF00FF88) 
              : const Color(0xFF00D4FF),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: (_isSelected 
                ? const Color(0xFF00FF88) 
                : const Color(0xFF00D4FF)).withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipOval(
        child: Stack(
          children: [
            Image.asset(
              widget.image,
              fit: BoxFit.cover,
              width: 80,
              height: 80,
            ),
            if (!_isSelected)
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      const Color(0xFF00D4FF).withOpacity(0.2),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    return Column(
      children: [
        // Username
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF0A1A2A),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: const Color(0xFF00D4FF).withOpacity(0.5),
            ),
          ),
          child: Text(
            widget.username,
            style: const TextStyle(
              color: Color(0xFF00D4FF),
              fontWeight: FontWeight.bold,
              fontSize: 14,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(height: 8),
        
        // Bio
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF0A1A2A).withOpacity(0.5),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: const Color(0xFF00D4FF).withOpacity(0.3),
            ),
          ),
          child: Text(
            widget.bio,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectButton() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: ElevatedButton(
        onPressed: _isSelected ? null : _handleTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: _isSelected 
              ? const Color(0xFF00FF88) 
              : const Color(0xFF0A1A2A),
          foregroundColor: _isSelected 
              ? const Color(0xFF0A1A2A) 
              : const Color(0xFF00D4FF),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
            side: BorderSide(
              color: _isSelected 
                  ? const Color(0xFF00FF88) 
                  : const Color(0xFF00D4FF),
              width: 1,
            ),
          ),
          elevation: _isSelected ? 0 : 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isSelected) ...[
              const Icon(Icons.check_circle, size: 16),
              const SizedBox(width: 4),
            ],
            Text(
              _isSelected ? 'SELECTED' : 'ANALYZE',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _hoverAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _hoverAnimation.value,
          child: GestureDetector(
            onTapDown: (_) => setState(() => _isHovered = true),
            onTapUp: (_) => setState(() => _isHovered = false),
            onTapCancel: () => setState(() => _isHovered = false),
            child: Container(
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFF0A1A2A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isSelected 
                      ? const Color(0xFF00FF88) 
                      : (_isHovered 
                          ? const Color(0xFF00D4FF) 
                          : const Color(0xFF00D4FF).withOpacity(0.5)),
                  width: _isSelected ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (_isSelected 
                        ? const Color(0xFF00FF88) 
                        : const Color(0xFF00D4FF)).withOpacity(0.2),
                    blurRadius: _isSelected ? 15 : 8,
                    spreadRadius: _isSelected ? 3 : 1,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Main content
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildProfileImage(),
                        const SizedBox(height: 12),
                        _buildInfoSection(),
                        const SizedBox(height: 16),
                        _buildSelectButton(),
                      ],
                    ),
                  ),
                  
                  // Scanning line effect
                  if (!_isSelected) _buildScanLine(),
                  
                  // Corner decorations
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: const Color(0xFF00D4FF), width: 2),
                          left: BorderSide(color: const Color(0xFF00D4FF), width: 2),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: const Color(0xFF00D4FF), width: 2),
                          right: BorderSide(color: const Color(0xFF00D4FF), width: 2),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: const Color(0xFF00D4FF), width: 2),
                          left: BorderSide(color: const Color(0xFF00D4FF), width: 2),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: const Color(0xFF00D4FF), width: 2),
                          right: BorderSide(color: const Color(0xFF00D4FF), width: 2),
                        ),
                      ),
                    ),
                  ),
                  
                  // Status indicator
                  if (_isSelected)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00FF88),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Color(0xFF0A1A2A),
                          size: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}