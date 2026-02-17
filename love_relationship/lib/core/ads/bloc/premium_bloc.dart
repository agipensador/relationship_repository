import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love_relationship/core/services/auth_session.dart';
import 'package:love_relationship/features/auth/domain/entities/premium_tier.dart';
import 'package:love_relationship/features/auth/domain/repositories/user_repository.dart';
import 'package:love_relationship/core/ads/bloc/premium_event.dart';
import 'package:love_relationship/core/ads/bloc/premium_state.dart';

class PremiumBloc extends Bloc<PremiumEvent, PremiumState> {
  final UserRepository userRepository;
  final AuthSession authSession;

  PremiumBloc(this.userRepository, this.authSession) : super(const PremiumState()) {
    on<PremiumLoadRequested>(_onLoad);
    on<PremiumSetTierRequested>(_onSetTier);
  }

  Future<void> _onLoad(
    PremiumLoadRequested event,
    Emitter<PremiumState> emit,
  ) async {
    final uid = authSession.currentUidOrNull();
    if (uid == null) return;
    emit(state.copyWith(loading: true));
    final result = await userRepository.getById(uid);

    result.fold(
      (_) => emit(state.copyWith(loading: false, premiumTier: PremiumTier.none)),
      (user) =>
          emit(state.copyWith(loading: false, premiumTier: user.tier)),
    );
  }

  Future<void> _onSetTier(
    PremiumSetTierRequested event,
    Emitter<PremiumState> emit,
  ) async {
    final uid = authSession.currentUidOrNull();
    if (uid == null) return;
    emit(state.copyWith(loading: true));

    final current = await userRepository.getById(uid);

    await current.fold(
      (_) async => emit(state.copyWith(loading: false)),
      (user) async {
        final updated = user.copyWith(
          id: user.id,
          email: user.email,
          name: user.name,
          tier: event.tier,
        );
        final res = await userRepository.update(updated);
        res.fold(
          (_) => emit(state.copyWith(loading: false)),
          (u) => emit(state.copyWith(loading: false, premiumTier: u.tier)),
        );
      },
    );
  }
}
