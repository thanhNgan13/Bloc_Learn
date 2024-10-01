import 'package:equatable/equatable.dart';

/// Lớp trừu tượng CalculatorState
/// Tất cả các trạng thái khác sẽ kế thừa lớp này.
abstract class CalculatorState extends Equatable {
  const CalculatorState();
  @override
  List<Object> get props => [];
}

/// Lớp trạng thái ban đầu
/// Khi ứng dụng mới khởi động, trạng thái sẽ là trạng thái ban đầu.
class CalculatorInitialState extends CalculatorState {
  final String display;
  final String subDisplay;

  const CalculatorInitialState()
      : display = "0",
        subDisplay = "";
  @override
  List<Object> get props => [display];
}

/// Lớp hiện thị khi người dùng nhập số hoặc toán tử
/// Khi người dùng nhập số hoặc toán tử, trạng thái sẽ chuyển sang trạng thái này.
class CalculatorInputState extends CalculatorState {
  final String display;
  final String subDisplay;

  const CalculatorInputState(this.display, this.subDisplay);

  @override
  List<Object> get props => [display];
}

/// Lớp trạng thái hiển thị kết quả
/// Khi người dùng nhấn nút "=" để xem kết quả, trạng thái sẽ chuyển sang trạng thái này.
class CalculatorResultState extends CalculatorState {
  final String display;
  final String subDisplay;

  const CalculatorResultState(this.display, this.subDisplay);

  @override
  List<Object> get props => [display];
}

/// Lớp trạng thái hiển thị lỗi
/// Khi người dùng thực hiện phép tính không hợp lệ, trạng thái sẽ chuyển sang trạng thái này.
class CalculatorErrorState extends CalculatorState {
  final String error;

  const CalculatorErrorState(this.error);

  @override
  List<Object> get props => [error];
}
