import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifter_track_app/components/button.dart';
import 'package:lifter_track_app/components/scrollableValuePicker.dart';
import 'package:lifter_track_app/components/text.dart';
import 'package:provider/provider.dart';

class WeightPlateSelectorSetForm extends StatefulWidget {
  final int initalWeight;
  final int initialReps;
  final void Function(int) onWeightChanged;
  final void Function(int) onRepsChanged;
  const WeightPlateSelectorSetForm(
      {Key key,
      this.initalWeight,
      this.initialReps,
      this.onRepsChanged,
      this.onWeightChanged})
      : super(key: key);

  @override
  _WeightPlateSelectorSetFormState createState() =>
      _WeightPlateSelectorSetFormState();
}

class WeightNotifier extends ChangeNotifier {
  int weight;
  List<String> _weights = ['45', '35', '25', '10', '5', '2.5'];
  Map<String, int> plateAmounts = {
    '45': 0,
    '35': 0,
    '25': 0,
    '10': 0,
    '5': 0,
    '2.5': 0,
  };
  List<String> allPlatesList = [];
  List<String> quantizedPlatesList = [];

  WeightNotifier({this.weight}) {
    _calculatePlateAmounts();
    _generateLists();
  }

  void setWeight(int weight) {
    this.weight = weight;
    _calculatePlateAmounts();
    _generateLists();
    notifyListeners();
  }

  void addPlate(String weight) {
    plateAmounts[weight] += 1;
    _generateLists();
    _calculateWeight();
    notifyListeners();
  }

  void clear() {
    for (String weight in _weights) {
      plateAmounts[weight] = 0;
    }
    _generateLists();
    _calculateWeight();
    notifyListeners();
  }

  void _calculatePlateAmounts() {
    double fullWeight = weight.toDouble();
    int fourtyFivesCount = fullWeight ~/ 45;
    fullWeight -= (fourtyFivesCount * 45);
    int thirtyFivesCount = fullWeight ~/ 35;
    fullWeight -= (thirtyFivesCount * 35);
    int twentyFivesCount = fullWeight ~/ 25;
    fullWeight -= (twentyFivesCount * 25);
    int tensCount = fullWeight ~/ 10;
    fullWeight -= (tensCount * 10);
    int fivesCount = fullWeight ~/ 5;
    fullWeight -= (fivesCount * 5);
    int twoPointFivesCount = fullWeight ~/ 2.5;

    plateAmounts['45'] = fourtyFivesCount;
    plateAmounts['35'] = thirtyFivesCount;
    plateAmounts['25'] = twentyFivesCount;
    plateAmounts['10'] = tensCount;
    plateAmounts['5'] = fivesCount;
    plateAmounts['2.5'] = twoPointFivesCount;
  }

  void _calculateWeight() {
    weight = 0;
    for (String weightString in _weights) {
      int quantity = plateAmounts[weightString];
      weight += (quantity * double.parse(weightString)).toInt();
    }
  }

  void _generateLists() {
    allPlatesList.clear();
    quantizedPlatesList.clear();
    _weights.forEach((weight) {
      allPlatesList
          .addAll(List.generate(plateAmounts[weight], (index) => weight));
      int quantity = plateAmounts[weight];
      if (quantity > 0) {
        quantizedPlatesList.add('$quantity x $weight');
      }
    });
  }
}

class _WeightPlateSelectorSetFormState
    extends State<WeightPlateSelectorSetForm> {
  List<String> weights = ['45', '35', '25', '10', '5', '2.5'];
  Map<String, int> plateAmounts = {};
  List<String> plateCountStrings = [];
  TextEditingController weightTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WeightNotifier(weight: widget.initalWeight),
      child: Consumer<WeightNotifier>(
          builder: (context, plateWeight, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            weightAndReps(plateWeight, weightTextController),
            Expanded(
              child: LayoutBuilder(builder: (context, constraints) {
                return ListView(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  children: [
                    Container(
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                child: button(
                                    text: 'Clear Weight',
                                    onPressed: () {
                                      plateWeight.clear();
                                      weightTextController.text =
                                          '${plateWeight.weight}';
                                      widget.onWeightChanged(plateWeight.weight);
                                    }),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.white, width: 2),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: ListView(
                                      physics: ClampingScrollPhysics(),
                                      children: ((plateWeight.quantizedPlatesList
                                                      .length ==
                                                  0)
                                              ? [
                                                  text('No plates added',
                                                      textAlign:
                                                          TextAlign.center)
                                                ]
                                              : plateWeight
                                                  .quantizedPlatesList
                                                  .map((item) => text(item,
                                                      textAlign:
                                                          TextAlign.center))
                                                  .toList())),
                                ),
                              ),
                            )
                          ],
                        ),
                        height: constraints.maxHeight / 2),
                    Container(
                      height: constraints.maxHeight / 2,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: weights.map((weight) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: GestureDetector(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: text(weight),
                                  width: constraints.maxHeight / 4,
                                  height: constraints.maxHeight / 4,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade600.withAlpha(50),
                                    border:
                                        Border.all(color: Colors.grey.shade600),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          constraints.maxHeight / 8),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  HapticFeedback.heavyImpact();
                                  plateWeight.addPlate(weight);
                                  weightTextController.text =
                                      '${plateWeight.weight}';
                                  widget.onWeightChanged(plateWeight.weight);
                                },
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    )
                  ],
                );
              }),
            )
          ],
        );
      }),
    );
  }

  

  Widget weightAndReps(WeightNotifier plateWeight,
      TextEditingController weightTextController) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: ScrollableValuePicker(
            value: plateWeight.weight,
            textController: weightTextController,
            increment: 5,
            onValueChanged: (value) {
              plateWeight.setWeight(value);
              widget.onWeightChanged(plateWeight.weight);
            },
          ),
        ),
        Container(
          width: 40,
          child: text('x', textAlign: TextAlign.center),
        ),
        Expanded(
          flex: 1,
          child: ScrollableValuePicker(
            value: widget.initialReps,
            increment: 1,
            onValueChanged: widget.onRepsChanged,
          ),
        ),
      ],
    );
  }
}
