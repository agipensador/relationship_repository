import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:love_relationship/core/theme/app_colors.dart';
import 'package:love_relationship/features/games/domain/entities/game_entity.dart';

class GameCard extends StatelessWidget {
  final GameEntity gameEntity;
  final VoidCallback onTap;

  const GameCard({super.key, required this.gameEntity, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              spreadRadius: 1,
              offset: const Offset(0, 4),
              color: AppColors.blackDefault,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: SvgPicture.asset(
                  'assets/images/${gameEntity.assetSvg}',
                  color: AppColors.backgroundPrimary,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                gameEntity.title,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.whiteDefault,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
