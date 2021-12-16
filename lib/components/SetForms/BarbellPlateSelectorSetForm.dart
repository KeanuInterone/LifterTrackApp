import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifter_track_app/components/ValueField.dart';
import 'package:lifter_track_app/components/button.dart';
import 'package:lifter_track_app/components/hide_if.dart';
import 'package:lifter_track_app/components/scrollableValuePicker.dart';
import 'package:lifter_track_app/components/text.dart';
import 'package:provider/provider.dart';

class BarbellPlateSelectorSetForm extends StatefulWidget {
  final int initalWeight;
  final int initialReps;
  final void Function(int) onWeightChanged;
  final void Function(int) onRepsChanged;
  const BarbellPlateSelectorSetForm(
      {Key key,
      this.initalWeight,
      this.initialReps,
      this.onRepsChanged,
      this.onWeightChanged})
      : super(key: key);

  @override
  _BarbellPlateSelectorSetFormState createState() =>
      _BarbellPlateSelectorSetFormState();
}

class BarbellWeightNotifier extends ChangeNotifier {
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

  BarbellWeightNotifier({this.weight}) {
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
    _weights.forEach((weight) {
      plateAmounts[weight] = 0;
    });
    _generateLists();
    _calculateWeight();
    notifyListeners();
  }

  void _calculatePlateAmounts() {
    if (weight < 45) weight = 45;
    int plateWeight = weight - 45;
    double persideWeight = plateWeight.toDouble() / 2.0;
    int fourtyFivesCount = persideWeight ~/ 45;
    persideWeight -= (fourtyFivesCount * 45);
    int thirtyFivesCount = persideWeight ~/ 35;
    persideWeight -= (thirtyFivesCount * 35);
    int twentyFivesCount = persideWeight ~/ 25;
    persideWeight -= (twentyFivesCount * 25);
    int tensCount = persideWeight ~/ 10;
    persideWeight -= (tensCount * 10);
    int fivesCount = persideWeight ~/ 5;
    persideWeight -= (fivesCount * 5);
    int twoPointFivesCount = persideWeight ~/ 2.5;

    plateAmounts['45'] = fourtyFivesCount;
    plateAmounts['35'] = thirtyFivesCount;
    plateAmounts['25'] = twentyFivesCount;
    plateAmounts['10'] = tensCount;
    plateAmounts['5'] = fivesCount;
    plateAmounts['2.5'] = twoPointFivesCount;
  }

  void _calculateWeight() {
    weight = 45;
    for (String weightString in _weights) {
      int quantity = plateAmounts[weightString] * 2;
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

class _BarbellPlateSelectorSetFormState
    extends State<BarbellPlateSelectorSetForm> {
  List<String> weights = ['45', '35', '25', '10', '5', '2.5'];
  Map<String, int> plateAmounts = {};
  List<String> plateCountStrings = [];
  TextEditingController barweightTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BarbellWeightNotifier(weight: widget.initalWeight),
      child: Consumer<BarbellWeightNotifier>(
          builder: (context, barbellWeight, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            weightAndReps(barbellWeight, barweightTextController),
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
                        barbellWeight.clear();
                        barweightTextController.text =
                            '${barbellWeight.weight}';
                        widget.onWeightChanged(barbellWeight.weight);
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
                        int plateAmount = barbellWeight.plateAmounts[weight];
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
                                        barbellWeight.addPlate(weight);
                                        barweightTextController.text =
                                            '${barbellWeight.weight}';
                                        widget.onWeightChanged(
                                            barbellWeight.weight);
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

  Widget weightAndReps(BarbellWeightNotifier barbellWieght,
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
              value: barbellWieght.weight,
              textController: barWeightTextController,
              onValueChanged: (value) {
                barbellWieght.setWeight(value);
                widget.onWeightChanged(barbellWieght.weight);
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
