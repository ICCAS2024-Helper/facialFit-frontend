import 'dart:math';

class StageManager {
  final List<List<String>> stages = [
    ['눈웃음'], // 1단계
    ['눈웃음', '입 벌리기'], // 2단계
    ['눈웃음', '눈 감기'], // 3단계
    ['눈썹 들어올리기', '볼 부풀리기', '입 벌리기'], // 4단계
    ['입 벌리기', '눈 웃음', '눈 감기'], // 5단계
    ['웃기', '볼 부풀리기', '눈 찡그리기'] // 6단계
  ];

  String selectRandomExpression(int stage) {
    var expressions = stages[stage - 1];
    return expressions[Random().nextInt(expressions.length)];
  }

  int getRequiredImagesForStage(int stage) {
    switch (stage) {
      case 1:
        return 1;
      case 2:
      case 3:
        return 2;
      case 4:
      case 5:
      case 6:
        return 3;
      default:
        return 1;
    }
  }
}
