import 'package:flutter/material.dart';
import 'package:myspending/ui/views/spendings/widget2/spending_view_item_add.dart';
import 'package:myspending/ui/views/spendings/widgets/spending_view_item.dart';
import 'package:myspending/ui/views/spendings/widgets/spending_view_item_edit.dart';
import 'package:stacked/stacked.dart';
import 'package:hexcolor/hexcolor.dart';

import 'spending_viewmodel.dart';
import 'spending_model.dart';

class SpendingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SpendingViewModel>.reactive(
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.white,
        appBar: (model.state == SpendingViewState.listView)
            ? AppBar(
                backgroundColor: HexColor("#932432"),
                title: Text(model.title),
              )
            : null,
        body: Stack(
          children: [
            model.state == SpendingViewState.listView
                ? ListView.builder(
                    itemCount: model.items.length,
                    itemBuilder: (BuildContext context, int index) {
                      Spending item = model.items[index];
                      return Ink(
                        color: HexColor('#4D774E'),
                        child: ListTile(
                            trailing: new IconButton(
                                icon: new Icon(Icons.delete),
                                color: Colors.red[400],
                                onPressed: () => {
                                      model.editingItem = item,
                                      showAlertDialog(context, model)
                                    }),
                            title: Text(
                              item.title,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              "${item.desc}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic),
                            ),
                            onTap: () {
                              model.editingItem = item;
                              model.state = SpendingViewState.itemView;
                            }),
                      );
                    },
                  )
                : model.state == SpendingViewState.itemView
                    ? SpendingViewItem()
                    : model.state == SpendingViewState.updateView
                        ? SpendingViewItemEdit()
                        : model.state == SpendingViewState.insertView
                            ? SpendingViewItemAdd()
                            : SizedBox(),
            Stack(
              children: <Widget>[
                model.state == SpendingViewState.listView
                    ? Positioned(
                        bottom: 0.0,
                        right: 0.0,
                        left: 0.0,
                        height: 55,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: Container(
                              color: HexColor("#12232E"),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Text(
                                      "TỔNG CHI PHÍ: ",
                                      style: TextStyle(
                                          color: HexColor('#e1b382'),
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0.0),
                                    child: Text(
                                      "${model.getTotal()}",
                                      style: TextStyle(
                                          color: HexColor('#e1b382'),
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      )
                    : SizedBox(),
              ],
            )
          ],
        ),
        floatingActionButton: model.state == SpendingViewState.listView
            ? FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () => {
                      model.editingControllerDesc.text = "",
                      model.editingControllerTitle.text = "",
                      model.editingItem = Spending("", 0),
                      model.state = SpendingViewState.insertView
                    })
            : null,
      ),
      viewModelBuilder: () => SpendingViewModel(),
    );
  }
}

showAlertDialog(BuildContext context, SpendingViewModel model) {
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("Hủy bỏ"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = FlatButton(
      child: Text("Xác nhận"),
      onPressed: () => (model.deleteItem())
          ? {Navigator.of(context, rootNavigator: true).pop(), cancelButton}
          : cancelButton);

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    backgroundColor: HexColor("#e1b382"),
    title: Text("Xác nhận"),
    content: Text("Bạn có chắc chắn muốn xóa bản ghi này?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
