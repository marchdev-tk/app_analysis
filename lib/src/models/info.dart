import 'data.dart';
import 'extremums.dart';

class AnalysisInfo {
  factory AnalysisInfo({
    required AnalysisData data,
    required AnalysisExtremums extremums,
  }) {
    return AnalysisInfo._(
      id: '', // TODO generate random id
      data: data,
      extremums: extremums,
    );
  }

  const AnalysisInfo._({
    required this.id,
    required this.data,
    required this.extremums,
  });

  final String id;
  final AnalysisData data;
  final AnalysisExtremums extremums;
}
