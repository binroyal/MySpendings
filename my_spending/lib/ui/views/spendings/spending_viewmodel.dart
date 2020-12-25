import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:myspending/ui/views/spendings/spending_repository.dart';
import 'package:stacked/stacked.dart';

import 'spending_model.dart';

/// Trạng thái của view
enum SpendingViewState { listView, itemView, insertView, updateView }

class SpendingViewModel extends BaseViewModel {
  final title = 'Quản lý tiêu dùng';

  /// Danh sách các bản ghi được load bất đồng bộ bên trong view model,
  /// khi load thành công thì thông báo đến view để cập nhật trạng thái
  var _items = <Spending>[];

  /// ### Danh sách các bản ghi dùng để hiển thị trên ListView
  /// Vì quá trình load items là bất đồng bộ nên phải tạo một getter
  /// `get items => _items` để tránh xung đột
  List<Spending> get items => _items;

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
    var timestamp = DateTime.now();
    var title = timestamp.millisecondsSinceEpoch.toString();
    var desc = timestamp.toLocal().toString();

    var item = Spending(title, desc);
    repo.insert(item).then((value) {
      reloadItems();
    });
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
    editingControllerDesc.text = editingItem.desc;
    state = SpendingViewState.updateView;
  }

  void saveItem() {
    var title = editingControllerTitle.text;
    var desc = editingControllerDesc.text;
    var item = Spending(title, desc);
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
