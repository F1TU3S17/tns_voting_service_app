import 'package:flutter/foundation.dart';
import '../client/api/voting_client.dart';
import 'mock_voting_repository.dart';
import 'voting_repository.dart';
import 'voting_repository_impl.dart';

class RepositoryProvider {
  static bool _useMock = false; // Флаг для переключения между моком и реальным API
  static VotingRepository? _repository;

  /// Получение экземпляра репозитория
  static VotingRepository getRepository() {
    if (_repository != null) return _repository!;

    if (_useMock) {
      _repository = MockVotingRepository();
    } else {
      final client = VotingClient(
        baseUrl: 'https://n8yd98-5-101-181-183.ru.tuna.am',
      );
      _repository = VotingRepositoryImpl(client: client);
    }

    return _repository!;
  }

  /// Метод для переключения между моком и реальным API
  static void toggleMockMode(bool useMock) {
    if (_useMock != useMock) {
      _useMock = useMock;
      _repository = null; // Сброс репозитория для пересоздания

      if (kDebugMode) {
        print('Репозиторий переключен на ${useMock ? "мок" : "реальный API"}');
      }
    }
  }
}
