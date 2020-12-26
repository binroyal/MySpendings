import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myspending/ui/views/spendings/spending_viewmodel.dart';
import 'package:stacked/stacked.dart';

class SpendingViewItemEdit extends ViewModelWidget<SpendingViewModel> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, model) {
    return Scaffold(
      appBar: AppBar(
        title: Text((model.editingItem.id != "")
            ? 'Cập nhật khoản chi'
            : 'Thêm mới khoản chi'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => model.state = SpendingViewState.listView,
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                (model.checkDesc() == true)
                    ? (model.editingItem.id != "")
                        ? model.saveItem()
                        : model.addItem()
                    : showAlertDialog2(context);
              })
        ],
      ),
      body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Nhập vào tên khoản chi',
                      labelText: "Tên khoản chi",
                    ),
                    validator: (String value) {
                      return value == ''
                          ? 'Tên khoản chi không được để trống'
                          : null;
                    },
                    controller: model.editingControllerTitle),
              ),
              SizedBox(height: 10),
              Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Nhập số tiền',
                      labelText: "Khoản chi",
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    controller: model.editingControllerDesc,
                  )),
            ],
          )),
    );
  }
}

showAlertDialog2(BuildContext context) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Đã có lỗi xảy ra"),
    content: Text("Số tiền không hợp lệ"),
    actions: [
      okButton,
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
