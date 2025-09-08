import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love_relationship/core/ads/repositories/premium_repository.dart';

class PremiumState {
  final bool isPremium;
  const PremiumState(this.isPremium);
}

class PremiumCubit extends Cubit<PremiumState> {
  final PremiumRepository premiumRepository;
  PremiumCubit(this.premiumRepository) : super(const PremiumState(false));

  Future<void> load() async {
    emit(PremiumState(await premiumRepository.isPremium()));
  }

  Future<void> set(bool value) async {
    emit(PremiumState(value));
    await premiumRepository.setPremium(value);
  }

  void toggle() => set(!state.isPremium);
}
