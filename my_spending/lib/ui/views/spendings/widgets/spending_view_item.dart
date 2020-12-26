import 'package:flutter/material.dart';
import 'package:myspending/ui/views/spendings/spending_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:hexcolor/hexcolor.dart';

class SpendingViewItem extends ViewModelWidget<SpendingViewModel> {
  @override
  Widget build(BuildContext context, model) {
    return Scaffold(
      backgroundColor: HexColor('#e1b382'),
      appBar: AppBar(
        backgroundColor: HexColor("#932432"),
        title: Text("Chi tiết khoản chi"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => model.state = SpendingViewState.listView,
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.edit), onPressed: () => model.updateItem())
        ],
      ),
      body: Center(
        child: ListTile(
          title: Text(
            "Tên khoản chi: " + model.editingItem.title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            "Số tiền: " + model.editingItem.desc.toString(),
            style: TextStyle(
              fontSize: 13,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ),
    );
  }
}
