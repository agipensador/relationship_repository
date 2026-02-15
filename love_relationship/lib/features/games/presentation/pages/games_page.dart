import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love_relationship/core/theme/app_colors.dart';
import 'package:love_relationship/features/games/presentation/bloc/games_bloc.dart';
import 'package:love_relationship/features/games/presentation/bloc/games_event.dart';
import 'package:love_relationship/features/games/presentation/cubit/games_state.dart';
import 'package:love_relationship/features/games/presentation/widgets/game_card.dart';

class GamesPage extends StatefulWidget {
  const GamesPage({super.key});

  @override
  State<GamesPage> createState() => _GamesPageState();
}

class _GamesPageState extends State<GamesPage> {
  late final PageController _pageController;
  static const double _carouselHeight = 500;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.82,
    ); // “peek” dos lados
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Games"),
        elevation: 2,
        shadowColor: AppColors.primary,
      ),
      body: BlocBuilder<GamesBloc, GamesState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.error != null) {
            return Center(child: Text('Erro: ${state.error}'));
          }
          if (state.items.isEmpty) {
            return const Center(child: Text('Sem jogos por enquanto.'));
          }
          final isGrid = state.mode == GamesViewMode.grid;

          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: título + botão de toggle
                Container(
                  color: AppColors.backgroundPrimary,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Sugestões de jogos',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        IconButton(
                          tooltip: isGrid ? 'Ver em carrossel' : 'Ver em grade',
                          icon: Icon(
                            isGrid
                                ? Icons.view_carousel_outlined
                                : Icons.grid_view_sharp,
                          ),
                          onPressed: () => context.read<GamesBloc>().add(const GamesToggleViewRequested()),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: PageTransitionSwitcher(
                    duration: const Duration(milliseconds: 350),
                    reverse: !isGrid, // direção consistente ao alternar
                    transitionBuilder: (child, primary, secondary) {
                      return FadeThroughTransition(
                        animation: primary,
                        secondaryAnimation: secondary,
                        fillColor: Colors.transparent,
                        child: child,
                      );
                    },
                    child: isGrid ? _buildGrid(state) : _buildCarousel(state),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildGrid(GamesState state) {
    return Align(
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: GridView.builder(
          key: const ValueKey('grid'),
          padding: const EdgeInsets.all(16),
          itemCount: state.items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 cards por linha
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.88, // ajusta proporção do card
          ),
          itemBuilder: (_, i) {
            final game = state.items[i];
            return GameCard(gameEntity: game, onTap: () => _onGameTap(game));
          },
        ),
      ),
    );
  }

  Widget _buildCarousel(GamesState state) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        height: _carouselHeight, // altura configurável solicitada
        child: PageView.builder(
          key: const ValueKey('carousel'),
          controller: _pageController,
          itemCount: state.items.length,
          padEnds: true,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            final game = state.items[index];
            return Padding(
              padding: const EdgeInsets.only(left: 16, right: 8, bottom: 8),
              child: GameCard(gameEntity: game, onTap: () => _onGameTap(game)),
            );
          },
        ),
      ),
    );
  }

  void _onGameTap(game) {
    // TODO navegue para a rota do jogo específico
    // ex: Navigator.pushNamed(context, '/games/${game.id}');
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Abrir: ${game.title}')));
  }
}
