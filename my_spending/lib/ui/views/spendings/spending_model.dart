import 'package:flutter/material.dart';

class Spending {
  /// id tự sinh ra ngẫu nhiên
  String id =
      UniqueKey().hashCode.toUnsigned(20).toRadixString(16).padLeft(5, '0');

  final String title;
  final int desc;
  bool isDeleted = false;

  Spending(this.title, this.desc);

  /// Tên của bảng CSDL, nó nên được gán sẵn và có thể lấy ra từ data
  /// model mà không cần khởi tạo nên nó là static để dễ sử dung.
  static String get tableName => 'Spending';

  /// Chuỗi lệnh SQL để tạo bảng CSDL, nó nên được thiết lập để tạo bảng
  /// trong CSDL mà không cần khởi tạo nên nó là static để dễ sử dụng.
  static String get createTable =>
      'CREATE TABLE $tableName(`id` TEXT PRIMARY KEY,'
      ' `title` TEXT,'
      ' `desc` INTEGER,'
      ' `isDeleted` INTEGER DEFAULT 0)';

  /// Phương thức này được thiết lập để tạo nên danh sách các ghi chú
  /// được lấy về từ CSDL, nó được tạo dưới dạng danh sách các ghi chú
  /// theo cấu trúc Map mà không cần khởi tạo đối tượng nên nó là static.
  static List<Spending> fromList(List<Map<String, dynamic>> query) {
    List<Spending> items = List<Spending>();
    for (Map map in query) {
      items.add(Spending.fromMap(map));
    }
    return items;
  }

  /// Hàm tạo có tên, đây là một hàm tạo từ đối số là dữ liệu đưa vào
  /// dưới dạng Map
  Spending.fromMap(Map data)
      : id = data['id'],
        title = data['title'],
        desc = data['desc'],
        isDeleted = data['isDeleted'] == 1 ? true : false;

  /// Phương thức của đối tượng, nó cho phép tạo ra dữ liệu dạng Map từ
  /// dữ liệu của một đối tượng ghi chú.
  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'desc': desc,
        'isDeleted': isDeleted ? 1 : 0,
      };
}
