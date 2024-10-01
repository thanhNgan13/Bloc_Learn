import 'package:bloc_learn/presentation/home_screen/bloc/home_event.dart';
import 'package:bloc_learn/presentation/home_screen/bloc/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CalculatorBloc extends Bloc<CalculatorEvent, CalculatorState> {
  String _firstOperand = '';
  String _secondOperand = '';
  String _operator = '';
  String _display = '';
  int _flagOperatorCal = 0;

  CalculatorBloc() : super(const CalculatorInitialState()) {
    // Đăng ký các event với các handler tương ứng
    on<NumberPressed>((event, emit) {
      emit(_handleNumberPress(event.number));
    });

    on<OperatorPressed>((event, emit) {
      emit(_handleOperatorPress(event.operator));
    });

    on<CalculateResult>((event, emit) {
      emit(_handleCalculate());
    });

    on<Clear>((event, emit) {
      emit(_handleClear());
    });

    on<ClearEntry>((event, emit) {
      emit(_handleClearEntry()); // Xử lý nút CE
    });

    on<DeleteLastEntry>((event, emit) {
      emit(_handleDelete()); // Xử lý nút Del
    });
  }

  CalculatorState _handleNumberPress(String number) {
    // Nếu chưa có toán tử, đang nhập _firstOperand
    if (_operator.isEmpty) {
      // Nếu đã thực hiện phép toán và bắt đầu nhập lại, reset _firstOperand
      if (_flagOperatorCal == 1) {
        _firstOperand = number;
        _display = number;
        _flagOperatorCal = 0;
        return CalculatorInputState(_display, "");
      } else if (number == "0" &&
          _firstOperand.isEmpty &&
          _firstOperand == "0.0") {
        return const CalculatorInputState(
            "0", ""); // Bỏ qua nếu nhập "0" liên tục
      }
      // Kiểm tra nếu nhập dấu "." và _firstOperand trống, thì thêm "0."
      else if (number == "." && _firstOperand.isEmpty) {
        _firstOperand = "0."; // Tự động thêm "0." khi nhập "." đầu tiên
        _display = "0.";
      }
      // Kiểm tra nếu đã có dấu "." trong _firstOperand
      else if (number == "." && _firstOperand.contains(".")) {
        return CalculatorInputState(
            _display, _firstOperand); // Bỏ qua nếu đã có "."
      } else {
        _firstOperand += number;
        _display += number;
      }
      print("First operand: " + _firstOperand);

      return CalculatorInputState(_firstOperand, "");
    } else {
      // Đang nhập _secondOperand
      // Kiểm tra nếu nhập dấu "." và _secondOperand trống, thì thêm "0."
      if (number == "." && _secondOperand.isEmpty) {
        _secondOperand = "0."; // Tự động thêm "0." khi nhập "." đầu tiên
        _display += "0.";
      }
      // Kiểm tra nếu đã có dấu "." trong _secondOperand
      else if (number == "." && _secondOperand.contains(".")) {
        return CalculatorInputState(
            _secondOperand, _display); // Bỏ qua nếu đã có "."
      }
      _secondOperand += number;
      _display += number;
      print("Second operand: " + _secondOperand);

      return CalculatorInputState(_secondOperand, _display);
    }
  }

  CalculatorState _handleOperatorPress(String operator) {
    if (_flagOperatorCal == 1) {
      _flagOperatorCal = 0;
      _operator = operator;

      _display = _firstOperand;
      _display += operator;
      return CalculatorInputState(operator, _display);
    }
    if (_firstOperand.isNotEmpty) {
      _operator = operator;
      _display += operator;
    }
    return CalculatorInputState(operator, _display);
  }

  CalculatorState _handleCalculate() {
    double result = 0;
    double num1 = 0; // Giá trị mặc định cho _firstOperand
    double num2 = 0; // Giá trị mặc định cho _secondOperand

    // Kiểm tra nếu _firstOperand có giá trị, nếu không thì gán mặc định là 0
    if (_firstOperand.isNotEmpty) {
      num1 = double.parse(_firstOperand);
    } else {
      _display += '0'; // Hiển thị 0 nếu không có giá trị
    }

    // Nếu _secondOperand trống, mặc định num2 là 0
    if (_secondOperand.isNotEmpty) {
      num2 = double.parse(_secondOperand);
    }

    print("First operand: " + _firstOperand);
    print("Second operand: " + _secondOperand);

    // Nếu chỉ có _firstOperand, không có phép toán hay số thứ hai
    if (_operator.isEmpty) {
      result = num1; // Kết quả sẽ là chính _firstOperand
    } else if (_secondOperand.isEmpty) {
      result =
          num1; // Nếu không nhập số thứ hai và bấm "=" => kết quả là _firstOperand
    } else {
      // Kiểm tra phép chia cho 0 và phát lỗi
      if (_operator == '/' && num2 == 0) {
        return const CalculatorErrorState(
            "Error: Division by zero"); // Báo lỗi chia cho 0
      }

      // Thực hiện phép toán
      switch (_operator) {
        case '+':
          result = num1 + num2;
          break;
        case '-':
          result = num1 - num2;
          break;
        case '*':
          result = num1 * num2;
          break;
        case '/':
          result = num1 / num2;
          break;
        default:
          return const CalculatorErrorState(
              "Error: Invalid operation"); // Trường hợp phép toán không hợp lệ
      }
    }

    // Cập nhật kết quả và hiển thị
    _firstOperand = result.toString();
    _secondOperand = '';
    _operator = '';
    _display += "=";
    _flagOperatorCal = 1; // Đánh dấu rằng phép toán đã hoàn thành

    print("Result: " + _firstOperand);

    return CalculatorResultState(_firstOperand, _display);
  }

  CalculatorState _handleClear() {
    _firstOperand = '';
    _secondOperand = '';
    _operator = '';
    _display = '';
    _flagOperatorCal = 0;
    return const CalculatorInitialState();
  }

  CalculatorState _handleClearEntry() {
    if (_operator.isEmpty) {
      _firstOperand = '0';
    } else {
      _secondOperand = '0';
    }
    _display = '0'; // Xóa toàn bộ nội dung hiển thị
    return CalculatorInputState(_display, _firstOperand);
  }

  CalculatorState _handleDelete() {
    if (_flagOperatorCal == 1) {
      _display = _firstOperand;
      return CalculatorInputState(_display, '');
    }

    if (_operator.isEmpty) {
      if (_firstOperand.isNotEmpty) {
        _firstOperand = _firstOperand.substring(0, _firstOperand.length - 1);
      }
      _display = _firstOperand;
    } else {
      if (_secondOperand.isNotEmpty) {
        _secondOperand = _secondOperand.substring(0, _secondOperand.length - 1);
      }
      _display = _firstOperand + _operator + _secondOperand;
    }
    return CalculatorInputState(_display, '');
  }
}
