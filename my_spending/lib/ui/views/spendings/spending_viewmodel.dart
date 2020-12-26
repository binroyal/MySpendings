import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:myspending/ui/views/spendings/spending_repository.dart';
import 'package:stacked/stacked.dart';

import 'spending_model.dart';

/// Trạng thái của view
enum SpendingViewState { listView, itemView, insertView, updateView }

class SpendingViewModel extends BaseViewModel {
  final title = 'QUẢN LÝ TIÊU DÙNG';

  /// Danh sách các bản ghi được load bất đồng bộ bên trong view model,
  /// khi load thành công thì thông báo đến view để cập nhật trạng thái
  var _items = <Spending>[];

  /// ### Danh sách các bản ghi dùng để hiển thị trên ListView
  /// Vì quá trình load items là bất đồng bộ nên phải tạo một getter
  /// `get items => _items` để tránh xung đột
  List<Spending> get items => _items;

  Spending _spending;
  Spending get spending {
    if (_spending == null) {
      _spending = Spending("", 0); // Instantiate the object if its null.
    }
    return _spending;
  }

  /// Trạng thái mặc định của view là listView, nó có thể thay đổi
  /// bên trong view model
  var _state = SpendingViewState.listView;

  /// Khi thay đổi trạng thái thì sẽ báo cho view biết để cập nhật
  /// nên cần tạo một setter để vừa nhận giá trị vừa thông báo đến view
  set state(value) {
    // Cập nhật giá trị cho biến _state
    _state = value;

    // Thông báo cho view biết để cập nhật trạng thái của widget
    notifyListeners();
  }

  /// Cần có một getter để lấy ra trạng thái view cục bộ cho view
  SpendingViewState get state => _state;

  Spending editingItem;

  var editingControllerTitle = TextEditingController();
  var editingControllerDesc = TextEditingController();

  ///
  var repo = SpendingRepository();

  Future init() async {
    return reloadItems();
  }

  Future reloadItems() async {
    return repo.items().then((value) {
      _items = value;
      notifyListeners();
    });
  }

  void addItem() {
    var title = editingControllerTitle.text;
    var desc = int.parse(editingControllerDesc.text);

    var item = Spending(title, desc);
    repo.insert(item).then((value) {
      reloadItems();
    });
    state = SpendingViewState.listView;
  }

  void addItem2() {
    editingControllerTitle.text = "";
    editingControllerDesc.text = "";
    editingItem = null;
    editingItem.id = null;
    state = SpendingViewState.insertView;
  }

  void updateItem() {
    editingControllerTitle.text = editingItem.title;
    editingControllerDesc.text = editingItem.desc.toString();
    state = SpendingViewState.updateView;
  }

  String getTotal() {
    int t = 0;
    for (Spending a in items) {
      t += a.desc;
    }
    return t.toString();
  }

  bool checkDesc() {
    var title = editingControllerTitle.text;
    var x = int.parse(editingControllerDesc.text);
    if (x >= 0 && title != "") return true;
    return false;
  }

  void saveItem() {
    var title = editingControllerTitle.text;
    var desc = editingControllerDesc.text;
    var item = Spending(title, int.parse(desc));
    item.id = editingItem.id;
    repo.update(item).then((value) {
      reloadItems();
    });
    state = SpendingViewState.listView;
  }

  bool deleteItem() {
    log(editingItem.id);
    repo.delete(editingItem).then((value) {
      reloadItems();
      state = SpendingViewState.listView;
      return true;
    });
    return false;
  }

  void logItem() {
    log(editingItem.id);
  }
}
