import 'package:flutter/material.dart';
import 'package:myspending/ui/views/spendings/spending_viewmodel.dart';
import 'package:stacked/stacked.dart';

class SpendingViewItemAdd extends ViewModelWidget<SpendingViewModel> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, model) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm mới khoản chi'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => model.state = SpendingViewState.listView,
        ),
        actions: [
          IconButton(icon: Icon(Icons.save), onPressed: () => model.addItem())
        ],
      ),
      body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Nhập tên khoản chi',
                  ),
                  controller: model.editingControllerTitle),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Nhập số tiền',
                ),
                controller: model.editingControllerDesc,
              )
            ],
          )),
    );
  }
}
