import 'package:flutter/material.dart';
import 'package:my_schedule/utils/theme/colorTheme.dart';

double btnHeight = 60;
double borderWidth = 1;

class RenameDialogContent extends StatefulWidget {
  String title;
  String cancelBtnTitle;
  String okBtnTitle;
  VoidCallback cancelBtnTap;
  VoidCallback okBtnTap;
  TextEditingController vc;
  RenameDialogContent(
      {required this.title,
      required this.cancelBtnTap,
      required this.okBtnTap,
      required this.vc,
      this.cancelBtnTitle = "Cancel",
      this.okBtnTitle = "Ok"});

  @override
  _RenameDialogContentState createState() => _RenameDialogContentState();
}

class _RenameDialogContentState extends State<RenameDialogContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 20),
        height: 200,
        width: 10000,
        alignment: Alignment.bottomCenter,
        child: Column(
          children: [
            Container(
                alignment: Alignment.center,
                child: Text(
                  widget.title,
                  style: TextStyle(color: Colors.grey),
                )),
            Spacer(),
            Padding(
              padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: TextField(
                style: TextStyle(color: Colors.black87),
                controller: widget.vc,
                decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: primary),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: primary),
                    )),
              ),
            ),
            Container(
              // color: Colors.red,
              height: btnHeight,
              margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
              child: Column(
                children: [
                  Container(
                    // 按钮上面的横线
                    width: double.infinity,
                    color: primary,
                    height: borderWidth,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          widget.vc.text = "";
                          widget.cancelBtnTap();
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          widget.cancelBtnTitle,
                          style: const TextStyle(fontSize: 22, color: primary),
                        ),
                      ),
                      Container(
                        // 按钮中间的竖线
                        width: borderWidth,
                        color: primary,
                        height: btnHeight - borderWidth - borderWidth,
                      ),
                      TextButton(
                          onPressed: () {
                            widget.okBtnTap();
                            Navigator.of(context).pop();
                            widget.vc.text = "";
                          },
                          child: Text(
                            widget.okBtnTitle,
                            style:
                                const TextStyle(fontSize: 22, color: primary),
                          )),
                    ],
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
