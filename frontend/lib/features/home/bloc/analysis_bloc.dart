import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tiki_analysis_app/features/home/model/analysis_model.dart';
import 'package:tiki_analysis_app/features/home/service/http_service.dart';

part 'analysis_event.dart';
part 'analysis_state.dart';

class AnalysisBloc extends Bloc<AnalysisEvent, AnalysisState> {
  final HttpService _httpService;

  AnalysisBloc({HttpService? httpService})
    : _httpService = httpService ?? HttpService(),
      super(AnalysisInitial()) {
    on<GetAnalysisEvent>(_onGetAnalysis);
  }

  void _onGetAnalysis(
    GetAnalysisEvent event,
    Emitter<AnalysisState> emit,
  ) async {
    emit(AnalysisLoading());
    try {
      final analysis = await _httpService.getAnalysis(event.productId);
      emit(AnalysisLoaded(analysis: analysis));
    } catch (e) {
      emit(AnalysisError(message: e.toString()));
    }
  }
}
