import 'package:flutter/material.dart';
import 'package:lifter_track_app/components/scrollableValuePicker.dart';
import 'package:lifter_track_app/components/text.dart';
import 'package:provider/provider.dart';

class BarbellSetForm extends StatefulWidget {
  final int initalWeight;
  final int initialReps;
  final void Function(int) onWeightChanged;
  final void Function(int) onRepsChanged;
  const BarbellSetForm(
      {Key key,
      this.initalWeight,
      this.initialReps,
      this.onRepsChanged,
      this.onWeightChanged})
      : super(key: key);

  @override
  _BarbellSetFormState createState() => _BarbellSetFormState();
}

class BarbellWeightNotifier extends ChangeNotifier {
  int weight;
  BarbellWeightNotifier({this.weight});
  void setWeight(int weight) {
    this.weight = weight;
    notifyListeners();
  }
}

class _BarbellSetFormState extends State<BarbellSetForm> {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BarbellWeightNotifier(weight: widget.initalWeight),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 20,
          ),
          Expanded(child: barbell()),
          weightAndReps(),
        ],
      ),
    );
  }

  Widget barbell() {
    return LayoutBuilder(builder: (context, constraints) {
      double height = constraints.maxHeight;
      double width = constraints.maxWidth;
      return Container(
        //color: Colors.red,
        height: height,
        width: width,
        child: Consumer<BarbellWeightNotifier>(
            builder: (context, barbellWeight, child) {
          List<String> plateStrings =
              getBarbellPlateAmounts(barbellWeight.weight);
          double start = 70;
          double plateWidth = 30;
          double fullPlateHeight = 200;
          double fiveHeight = 100;
          double twoPointFiveHeight = 50;
          List<Positioned> plates = [];
          for (var i = 0; i < plateStrings.length; i++) {
            double plateHeight;
            Color plateColor;
            switch (plateStrings[i]) {
              case '45':
                plateHeight = fullPlateHeight;
                plateColor = Colors.blue;
                break;
              case '25':
                plateHeight = fullPlateHeight;
                plateColor = Colors.green;
                break;
              case '10':
                plateHeight = fullPlateHeight;
                plateColor = Colors.grey.shade800;
                break;
              case '5':
                plateHeight = fiveHeight;
                plateColor = Colors.black;
                break;
              case '2.5':
                plateHeight = twoPointFiveHeight;
                plateColor = Colors.black;
                break;
              default:
            }
            plates.add(
              Positioned(
                right: start + plateWidth * i,
                top: height / 2 - plateHeight / 2,
                child: Container(
                  height: plateHeight,
                  width: plateWidth,
                  decoration: BoxDecoration(
                    color: plateColor,
                    border: Border.all(color: Colors.white, width: 0.5),
                  ),
                ),
              ),
            );
          }
          return Stack(
            children: [
                  Positioned(
                    right: 0,
                    top: height / 2 - 10,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade800,
                        border: Border.all(color: Colors.white, width: 0.5),
                      ),
                      height: 20,
                      width: 50,
                    ),
                  ),
                  Positioned(
                    right: 50,
                    top: height / 2 - 25,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade800,
                        border: Border.all(color: Colors.white, width: 0.5),
                      ),
                      height: 50,
                      width: 20,
                    ),
                  ),
                  Positioned(
                    right: 70,
                    top: height / 2 - 15,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade800,
                        border: Border.all(color: Colors.white, width: 0.5),
                      ),
                      height: 30,
                      width: 250,
                    ),
                  ),
                ] +
                plates,
          );
        }),
      );
    });
  }

  Widget weightAndReps() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0,0,0,30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: WeightSelector(
              initialWeight: widget.initalWeight,
              onValueChanged: widget.onWeightChanged,
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
      ),
    );
  }

  List<String> getBarbellPlateAmounts(int value) {
    if (value <= 45) return [];
    print(value);
    int plateWeight = value - 45;
    double persideWeight = plateWeight.toDouble() / 2.0;
    int fourtyFivesCount = persideWeight ~/ 45;
    persideWeight -= (fourtyFivesCount * 45);
    int twentyFivesCount = persideWeight ~/ 25;
    persideWeight -= (twentyFivesCount * 25);
    int tensCount = persideWeight ~/ 10;
    persideWeight -= (tensCount * 10);
    int fivesCount = persideWeight ~/ 5;
    persideWeight -= (fivesCount * 5);
    int twoPointFivesCount = persideWeight ~/ 2.5;

    List<String> plates = [];
    plates.addAll(List.generate(fourtyFivesCount, (index) => '45'));
    plates.addAll(List.generate(twentyFivesCount, (index) => '25'));
    plates.addAll(List.generate(tensCount, (index) => '10'));
    plates.addAll(List.generate(fivesCount, (index) => '5'));
    plates.addAll(List.generate(twoPointFivesCount, (index) => '2.5'));

    return plates;
  }
}

class WeightSelector extends StatelessWidget {
  final int initialWeight;
  final Function(int) onValueChanged;
  const WeightSelector({Key key, this.initialWeight, this.onValueChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScrollableValuePicker(
      value: initialWeight,
      increment: 5,
      onValueChanged: (value) {
        onValueChanged(value);
        Provider.of<BarbellWeightNotifier>(context, listen: false)
            .setWeight(value);
      },
    );
  }
}
