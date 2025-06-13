part of 'analysis_bloc.dart';

sealed class AnalysisEvent extends Equatable {
  const AnalysisEvent();

  @override
  List<Object> get props => [];
}

final class GetAnalysisEvent extends AnalysisEvent {
  final String productId;
  const GetAnalysisEvent({required this.productId});

  @override
  List<Object> get props => [productId];
}
