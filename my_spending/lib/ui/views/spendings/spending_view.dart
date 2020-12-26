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
        backgroundColor: HexColor('#B73225'),
        appBar: (model.state == SpendingViewState.listView)
            ? AppBar(title: Text(model.title))
            : null,
        body: Stack(
          children: [
            model.state == SpendingViewState.listView
                ? ListView.builder(
                    itemCount: model.items.length,
                    itemBuilder: (BuildContext context, int index) {
                      Spending item = model.items[index];
                      return Ink(
                        color: Colors.lightGreen,
                        child: ListTile(
                            trailing: new IconButton(
                                icon: new Icon(Icons.delete),
                                color: Colors.red,
                                onPressed: () => {
                                      model.editingItem = item,
                                      showAlertDialog(context, model)
                                    }),
                            title: Text(item.title),
                            subtitle: Text("${item.desc}"),
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
          ],
        ),
        floatingActionButton: model.state == SpendingViewState.listView
            ? FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () => {
                      model.editingControllerDesc.text = "",
                      model.editingControllerTitle.text = "",
                      model.editingItem = null,
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
    backgroundColor: Colors.grey,
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
