import 'package:flutter/material.dart';
import 'package:myspending/ui/views/spendings/spending_model.dart';
import 'package:myspending/ui/views/spendings/spending_viewmodel.dart';
import 'package:stacked/stacked.dart';

class SpendingViewItem extends ViewModelWidget<SpendingViewModel> {
  @override
  Widget build(BuildContext context, model) {
    return Scaffold(
      appBar: AppBar(
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
          title: Text(model.editingItem.title),
          subtitle: Text(model.editingItem.desc),
        ),
      ),
    );
  }
}
