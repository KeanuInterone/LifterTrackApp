import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifter_track_app/components/ValueField.dart';
import 'package:lifter_track_app/components/button.dart';
import 'package:lifter_track_app/components/hide_if.dart';
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
            SizedBox(height: 30),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  button(
                      text: 'Clear Weight',
                      borderWidth: 1,
                      fontWeight: FontWeight.normal,
                      fontSize: 17,
                      height: 48,
                      onPressed: () {
                        plateWeight.clear();
                        weightTextController.text =
                            '${plateWeight.weight}';
                        widget.onWeightChanged(plateWeight.weight);
                      }),
                  SizedBox(height: 20),
                  text('Per side', textAlign: TextAlign.center),
                  Expanded(
                    child: GridView.count(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      crossAxisCount: 3,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                      childAspectRatio: 0.82,
                      children: weights.map((weight) {
                        int plateAmount = plateWeight.plateAmounts[weight];
                        return Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 30,
                                child: hideIf(
                                    condition: plateAmount == 0,
                                    child: text('x $plateAmount', fontWeight: FontWeight.bold)),
                              ),
                              Expanded(
                                child: LayoutBuilder(
                                    builder: (context, constraints) {
                                  double size = constraints.maxHeight >
                                          constraints.maxWidth
                                      ? constraints.maxWidth
                                      : constraints.maxHeight;
                                  return Center(
                                    child: GestureDetector(
                                      child: Container(
                                        height: size,
                                        width: size,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade800,
                                          border: Border.all(
                                            color: Colors.white,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(size / 2)),
                                        ),
                                        child: Center(
                                          child: text('$weight',
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      onTap: () {
                                        HapticFeedback.heavyImpact();
                                        plateWeight.addPlate(weight);
                                        weightTextController.text =
                                            '${plateWeight.weight}';
                                        widget.onWeightChanged(
                                            plateWeight.weight);
                                      },
                                    ),
                                  );
                                }),
                              )
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),
            )
          ],
        );
      }),
    );
  }

  Widget weightAndReps(WeightNotifier plateWeight,
      TextEditingController barWeightTextController) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: Column(children: [
            text('Weight', fontSize: 15, fontWeight: FontWeight.bold),
            SizedBox(
              height: 5,
            ),
            ValueField(
              value: plateWeight.weight,
              textController: barWeightTextController,
              onValueChanged: (value) {
                plateWeight.setWeight(value);
                widget.onWeightChanged(plateWeight.weight);
              },
            ),
          ]),
        ),
        Container(
          width: 40,
          child: text('x', textAlign: TextAlign.center),
        ),
        Expanded(
          flex: 1,
          child: Column(children: [
            text('Reps', fontSize: 15, fontWeight: FontWeight.bold),
            SizedBox(
              height: 5,
            ),
            ValueField(
              value: widget.initialReps,
              onValueChanged: widget.onRepsChanged,
            ),
          ]),
        ),
      ],
    );
  }
}
