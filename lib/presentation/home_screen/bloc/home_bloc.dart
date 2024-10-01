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
  }

  CalculatorState _handleNumberPress(String number) {
    if (_operator.isEmpty) {
      if (_flagOperatorCal == 1) {
        _firstOperand = number;
        _display = number;
        _flagOperatorCal = 0;
        return CalculatorInputState(_display);
      }
      _firstOperand += number;
      print("First Num: " + _firstOperand);
      _display += number;
      return CalculatorInputState(_display);
    } else {
      _secondOperand += number;
      print("Second num: " + _secondOperand);
      _display += number;
      return CalculatorInputState(_display);
    }
  }

  CalculatorState _handleOperatorPress(String operator) {
    if (_firstOperand.isNotEmpty) {
      _operator = operator;
      _display += operator;
    }
    return CalculatorInputState(_display);
  }

  CalculatorState _handleCalculate() {
    double result = 0;
    if (_firstOperand.isNotEmpty && _secondOperand.isNotEmpty) {
      double num1 = double.parse(_firstOperand);
      double num2 = double.parse(_secondOperand);

      // Kiểm tra phép chia cho 0 và phát lỗi
      if (_operator == '/' && num2 == 0) {
        return const CalculatorErrorState("Error"); // Báo lỗi chia cho 0
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
              "Error"); // Trường hợp phép toán không hợp lệ
      }

      // Cập nhật kết quả và hiển thị
      _firstOperand = result.toString();
      _secondOperand = '';
      _operator = '';
      _display = result.toString();
      _flagOperatorCal = 1;

      print("Result: " + _display);

      return CalculatorResultState(_display);
    }
    return const CalculatorErrorState("Error"); // Khi thiếu dữ liệu
  }

  CalculatorState _handleClear() {
    _firstOperand = '';
    _secondOperand = '';
    _operator = '';
    _display = '';
    _flagOperatorCal = 0;
    return const CalculatorInitialState();
  }
}
