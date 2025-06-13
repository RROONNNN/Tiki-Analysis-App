import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/analysis_bloc.dart';
import '../model/analysis_model.dart';

class HomePages extends StatefulWidget {
  const HomePages({super.key});

  @override
  State<HomePages> createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> {
  final TextEditingController _textController = TextEditingController();
  int touchedGroupIndex = -1;
  int rotationTurns = 1;
  final shadowColor = const Color(0xFFCCCCCC);

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  BarChartGroupData generateBarGroup(
    int x,
    Color color,
    double value,
    double shadowValue,
  ) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(toY: value, color: color, width: 6),
        BarChartRodData(toY: shadowValue, color: shadowColor, width: 6),
      ],
      showingTooltipIndicators: touchedGroupIndex == x ? [0] : [],
    );
  }

  List<_BarData> getBarData(AnalysisModel analysis) {
    return [
      _BarData(
        Colors.red,
        analysis.spam_count.toDouble(),
        analysis.spam_count.toDouble() * 0.8,
      ),
      _BarData(
        Colors.green,
        analysis.positive_spam.toDouble(),
        analysis.positive_spam.toDouble() * 0.8,
      ),
      _BarData(
        Colors.orange,
        analysis.neutral_spam.toDouble(),
        analysis.neutral_spam.toDouble() * 0.8,
      ),
      _BarData(
        Colors.pink,
        analysis.negative_spam.toDouble(),
        analysis.negative_spam.toDouble() * 0.8,
      ),
      _BarData(
        Colors.blue,
        analysis.positive_not_spam.toDouble(),
        analysis.positive_not_spam.toDouble() * 0.8,
      ),
      _BarData(
        Colors.purple,
        analysis.neutral_not_spam.toDouble(),
        analysis.neutral_not_spam.toDouble() * 0.8,
      ),
      _BarData(
        Colors.teal,
        analysis.negative_not_spam.toDouble(),
        analysis.negative_not_spam.toDouble() * 0.8,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AnalysisBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Tiki Analysis',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              letterSpacing: 1.2,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          elevation: 6,
          backgroundColor: Colors.blueAccent,
          shadowColor: Colors.blueGrey.withOpacity(0.4),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline, color: Colors.white),
              tooltip: 'About',
              onPressed: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'Tiki Analysis',
                  applicationVersion: '1.0.0',
                  applicationIcon: const Icon(
                    Icons.analytics,
                    size: 40,
                    color: Colors.blueAccent,
                  ),
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Text(
                        'Analyze product comments for spam and sentiment insights.',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<AnalysisBloc, AnalysisState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: TextField(
                      controller: _textController,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                        letterSpacing: 1.0,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Enter product ID',
                        labelStyle: const TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        hintText: 'e.g. 123456',
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.blueAccent,
                        ),
                        filled: true,
                        fillColor: Colors.blue[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.blueAccent,
                            width: 2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.blueAccent,
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.deepPurple,
                            width: 2.5,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 18,
                          horizontal: 16,
                        ),
                      ),
                      cursorColor: Colors.deepPurple,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          context.read<AnalysisBloc>().add(
                            GetAnalysisEvent(productId: value),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 40,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 6,
                      shadowColor: Colors.deepPurpleAccent.withOpacity(0.3),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    onPressed: () {
                      if (_textController.text.isNotEmpty) {
                        context.read<AnalysisBloc>().add(
                          GetAnalysisEvent(productId: _textController.text),
                        );
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.analytics, color: Colors.white),
                        SizedBox(width: 10),
                        Text('Analyze', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (state is AnalysisLoading)
                    CircularProgressIndicator()
                  else if (state is AnalysisLoaded)
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(child: Container()),

                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Tooltip(
                                      message:
                                          'Rotate the chart 90 degrees (cw)',
                                      child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            rotationTurns += 1;
                                          });
                                        },
                                        icon: RotatedBox(
                                          quarterTurns: rotationTurns - 1,
                                          child: const Icon(
                                            Icons.rotate_90_degrees_cw,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Text(
                                textAlign: TextAlign.center,
                                state.analysis.product_name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),
                            SizedBox(
                              height: MediaQuery.of(context).size.width * 0.8,
                              child: BarChart(
                                BarChartData(
                                  alignment: BarChartAlignment.spaceBetween,
                                  rotationQuarterTurns: rotationTurns,
                                  borderData: FlBorderData(
                                    show: true,
                                    border: Border.symmetric(
                                      horizontal: BorderSide(
                                        color: Colors.black.withOpacity(0.2),
                                      ),
                                    ),
                                  ),
                                  titlesData: FlTitlesData(
                                    show: true,
                                    leftTitles: const AxisTitles(
                                      drawBelowEverything: true,
                                      sideTitles: SideTitles(
                                        maxIncluded: false,
                                        showTitles: true,
                                        reservedSize: 30,
                                      ),
                                    ),
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 36,
                                        getTitlesWidget: (value, meta) {
                                          final index = value.toInt();
                                          final labels = [
                                            '',
                                            '',
                                            '',
                                            '',
                                            '',
                                            '',
                                            '',
                                          ];
                                          return SideTitleWidget(
                                            space: 5,
                                            meta: meta,
                                            child: _IconWidget(
                                              color:
                                                  getBarData(
                                                    state.analysis,
                                                  )[index].color,
                                              isSelected:
                                                  touchedGroupIndex == index,
                                              label: labels[index],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    rightTitles: const AxisTitles(),
                                    topTitles: const AxisTitles(),
                                  ),
                                  gridData: FlGridData(
                                    show: true,
                                    drawVerticalLine: false,
                                    getDrawingHorizontalLine:
                                        (value) => FlLine(
                                          color: Colors.black.withOpacity(0.2),
                                          strokeWidth: 1,
                                        ),
                                  ),
                                  barGroups:
                                      getBarData(
                                        state.analysis,
                                      ).asMap().entries.map((e) {
                                        final index = e.key;
                                        final data = e.value;
                                        return generateBarGroup(
                                          index,
                                          data.color,
                                          data.value,
                                          data.shadowValue,
                                        );
                                      }).toList(),
                                  maxY:
                                      state.analysis.spam_count.toDouble() *
                                      1.2,
                                  barTouchData: BarTouchData(
                                    enabled: true,
                                    handleBuiltInTouches: false,
                                    touchTooltipData: BarTouchTooltipData(
                                      getTooltipColor:
                                          (group) => Colors.transparent,
                                      tooltipMargin: 0,
                                      getTooltipItem: (
                                        BarChartGroupData group,
                                        int groupIndex,
                                        BarChartRodData rod,
                                        int rodIndex,
                                      ) {
                                        return BarTooltipItem(
                                          rod.toY.toString(),
                                          TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: rod.color,
                                            fontSize: 18,
                                            shadows: const [
                                              Shadow(
                                                color: Colors.black26,
                                                blurRadius: 12,
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                    touchCallback: (event, response) {
                                      if (event.isInterestedForInteractions &&
                                          response != null &&
                                          response.spot != null) {
                                        setState(() {
                                          touchedGroupIndex =
                                              response
                                                  .spot!
                                                  .touchedBarGroupIndex;
                                        });
                                      } else {
                                        setState(() {
                                          touchedGroupIndex = -1;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Wrap(
                                spacing: 16,
                                runSpacing: 8,
                                alignment: WrapAlignment.center,
                                children: [
                                  _LegendItem(color: Colors.red, label: 'Spam'),
                                  _LegendItem(
                                    color: Colors.green,
                                    label: 'Tích cực - spam',
                                  ),
                                  _LegendItem(
                                    color: Colors.orange,
                                    label: 'Trung tính - spam',
                                  ),
                                  _LegendItem(
                                    color: Colors.pink,
                                    label: 'Tiêu cực - spam',
                                  ),
                                  _LegendItem(
                                    color: Colors.blue,
                                    label: 'Tích cực - không spam',
                                  ),
                                  _LegendItem(
                                    color: Colors.purple,
                                    label: 'Trung tính - không spam',
                                  ),
                                  _LegendItem(
                                    color: Colors.teal,
                                    label: 'Tiêu cực - không spam',
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    )
                  else if (state is AnalysisError)
                    Text(state.message),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _BarData {
  const _BarData(this.color, this.value, this.shadowValue);

  final Color color;
  final double value;
  final double shadowValue;
}

class _IconWidget extends ImplicitlyAnimatedWidget {
  const _IconWidget({
    required this.color,
    required this.isSelected,
    required this.label,
  }) : super(duration: const Duration(milliseconds: 300));

  final Color color;
  final bool isSelected;
  final String label;

  @override
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() =>
      _IconWidgetState();
}

class _IconWidgetState extends AnimatedWidgetBaseState<_IconWidget> {
  Tween<double>? _rotationTween;

  @override
  Widget build(BuildContext context) {
    final rotation = math.pi * 4 * _rotationTween!.evaluate(animation);
    final scale = 1 + _rotationTween!.evaluate(animation) * 0.5;
    return Transform(
      transform: Matrix4.rotationZ(rotation).scaled(scale, scale),
      origin: const Offset(14, 14),
      child: Column(
        mainAxisSize: MainAxisSize.min,

        children: [
          Icon(
            widget.isSelected ? Icons.face_retouching_natural : Icons.face,
            color: widget.color,
            size: 28,
          ),
        ],
      ),
    );
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _rotationTween =
        visitor(
              _rotationTween,
              widget.isSelected ? 1.0 : 0.0,
              (dynamic value) => Tween<double>(
                begin: value as double,
                end: widget.isSelected ? 1.0 : 0.0,
              ),
            )
            as Tween<double>?;
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.black87),
        ),
      ],
    );
  }
}
