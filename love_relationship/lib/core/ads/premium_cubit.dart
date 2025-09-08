import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love_relationship/features/auth/domain/entities/premium_tier.dart';
import 'package:love_relationship/features/auth/domain/repositories/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

class PremiumState {
  final bool loading;
  final PremiumTier premiumTier;
  const PremiumState({
    this.loading = false,
    this.premiumTier = PremiumTier.none,
  });

  bool get isPremium => premiumTier.isPremium;

  PremiumState copyWith({bool? isLoading, PremiumTier? tier}) => PremiumState(
    loading: isLoading ?? loading,
    premiumTier: tier ?? premiumTier,
  );
}

class PremiumCubit extends Cubit<PremiumState> {
  final UserRepository userRepository;
  fb.FirebaseAuth auth;

  PremiumCubit(this.userRepository, this.auth) : super(const PremiumState());

  Future<void> load() async {
    final uid = auth.currentUser?.uid;
    if (uid == null) return;
    emit(state.copyWith(isLoading: true));
    final result = await userRepository.getById(uid);

    result.fold(
      (_) => emit(state.copyWith(isLoading: false, tier: PremiumTier.none)),
      (user) => emit(state.copyWith(isLoading: false, tier: user.tier)),
    );
  }

  Future<void> setTier(PremiumTier tierSet) async {
    final uid = auth.currentUser?.uid;
    if (uid == null) return;
    emit(state.copyWith(isLoading: true));

    final current = await userRepository.getById(uid);

    await current.fold((_) async => emit(state.copyWith(isLoading: false)), (
      user,
    ) async {
      final updated = user.copyWith(
        id: user.id,
        email: user.email,
        name: user.name,
        tier: tierSet,
      );
      final res = await userRepository.update(updated);
      res.fold(
        (_) => emit(state.copyWith(isLoading: false)),
        (u) => emit(state.copyWith(isLoading: false, tier: u.tier)),
      );
    });
  }
}
