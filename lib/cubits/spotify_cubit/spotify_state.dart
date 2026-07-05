class SpotifyState {
  SpotifyState({
    this.isLoading = false,
  });

  final bool isLoading;

  SpotifyState copyWith({
    bool? isLoading,
  }) {
    return SpotifyState(
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
