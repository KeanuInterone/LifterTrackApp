import 'package:flutter/material.dart';
import 'package:lifter_track_app/components/AppBar.dart';
import 'package:lifter_track_app/components/background.dart';
import 'package:lifter_track_app/components/button.dart';
import 'package:lifter_track_app/components/formField.dart';
import 'package:lifter_track_app/components/hide_if.dart';
import 'package:lifter_track_app/components/keyboardDefocuser.dart';
import 'package:lifter_track_app/components/navigator.dart';
import 'package:lifter_track_app/components/text.dart';
import 'package:lifter_track_app/models/Notifiers/tags_notifier.dart';
import 'package:lifter_track_app/models/response.dart';
import 'package:lifter_track_app/models/tag.dart';
import 'package:provider/provider.dart';

class AddTagPage extends StatefulWidget {
  const AddTagPage({Key key}) : super(key: key);

  @override
  _AddTagPageState createState() => _AddTagPageState();
}

class _AddTagPageState extends State<AddTagPage> {
  Tag tag = Tag(name: '');
  bool isLoading = false;
  String inputErrorMessage = '';
  String errorMessage = '';
  @override
  Widget build(BuildContext context) {
    return keyboardDefocuser(
      context,
      child: background(
        context,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  appBar(
                    context,
                    centerChild: text('New Tag', fontSize: 20),
                  ),
                  SizedBox(height: 20),
                  formField(
                    placeholder: 'Tag Name',
                    autofocus: true,
                    textCapitalization: TextCapitalization.words,
                    onChanged: (value) {
                      setState(() {
                        inputErrorMessage = '';
                      });
                      tag.name = value;
                      Tag tagMatch =
                          Provider.of<TagsNotifier>(context, listen: false)
                              .tags
                              .firstWhere(
                                (t) =>
                                    t.name.toLowerCase() == value.toLowerCase(),
                                orElse: () => null,
                              );
                      if (tagMatch != null) {
                        setState(() {
                          inputErrorMessage =
                              'Tag with that name already exists';
                        });
                      }
                      setState(() {
                        errorMessage = '';
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  hideIf(
                    condition: inputErrorMessage == '',
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: text(inputErrorMessage,
                          color: Colors.red, textAlign: TextAlign.center),
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  hideIf(
                    condition: errorMessage == '',
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: text(errorMessage,
                          color: Colors.red, textAlign: TextAlign.center),
                    ),
                  ),
                  SizedBox(height: 20),
                  button(
                    text: 'Add Tag',
                    height: 60,
                    color: Theme.of(context).focusColor,
                    fillColor: Theme.of(context).focusColor.withAlpha(50),
                    isLoading: isLoading,
                    onPressed: () async {
                      if (inputErrorMessage != '') return;
                      if (tag.name == '') {
                        setState(() {
                          errorMessage = 'Tag name cannot be empty';
                        });
                        return;
                      }
                      setState(() {
                        isLoading = true;
                      });
                      Response res = await Provider.of<TagsNotifier>(context,
                              listen: false)
                          .addTag(tag);
                      if (!res.success) {
                        setState(() {
                          errorMessage = res.errMessage;
                        });
                        return;
                      }
                      pop(context);
                    },
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget header(context) {
    return Container(
      height: 80,
      child: Stack(
        children: [
          Container(
            constraints: BoxConstraints.expand(width: 24),
            child: IconButton(
              onPressed: () {
                pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
          Center(
            child: text('New Tag', fontSize: 20),
          )
        ],
      ),
    );
  }
}
