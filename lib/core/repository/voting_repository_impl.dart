import '../client/api/voting_client.dart';
import '../models/login_model.dart';
import '../models/question_model.dart';
import 'voting_repository.dart';

class VotingRepositoryImpl implements VotingRepository {
  final VotingClient _client;

  VotingRepositoryImpl({required VotingClient client}) : _client = client;

  @override
  Future<LoginResponse> login(String username, String password) async {
    return await _client.login(username, password);
  }

  @override
  Future<List<QuestionShort>> getQuestions() async {
    return await _client.getQuestions();
  }

  @override
  Future<QuestionDetail> getQuestionDetails(String questionId) async {
    return await _client.getQuestionDetails(questionId);
  }

  @override
  Future<String> downloadFile(String fileId, String fileName) async {
    return await _client.downloadFile(fileId, fileName);
  }

  @override
  Future<void> vote(String questionId, int answerId) async {
    await _client.vote(questionId, answerId);
  }

  @override
  Future<List<QuestionDetail>> getVotingHistory() async {
    return await _client.getVotingHistory();
  }

  @override
  bool get isAuthenticated => _client.isAuthenticated;

  @override
  void logout() {
    _client.logout();
  }
}
