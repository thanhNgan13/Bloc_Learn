import 'package:bloc_learn/presentation/home_screen/bloc/home_bloc.dart';
import 'package:bloc_learn/presentation/home_screen/bloc/home_event.dart';
import 'package:bloc_learn/presentation/home_screen/bloc/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_size_text/auto_size_text.dart';

class HomeScreen extends StatelessWidget {
  final List<String> buttons = [
    '7',
    '8',
    '9',
    '/',
    '4',
    '5',
    '6',
    '*',
    '1',
    '2',
    '3',
    '-',
    '.',
    '0',
    '%',
    '+',
    'CE',
    'C',
    'Del',
    '=',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculator')),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: BlocBuilder<CalculatorBloc, CalculatorState>(
              builder: (context, state) {
                String displayText = '';
                // Kiểm tra nếu state là CalculatorInitialState và lấy display từ đó
                if (state is CalculatorInitialState) {
                  displayText = state
                      .display; // Lấy giá trị 'display' từ CalculatorInitialState
                } else if (state is CalculatorInputState) {
                  displayText = state
                      .display; // Lấy giá trị 'display' từ CalculatorInputState
                } else if (state is CalculatorResultState) {
                  displayText = state
                      .display; // Lấy giá trị 'display' từ CalculatorResultState
                } else if (state is CalculatorErrorState) {
                  displayText = state.error; // Hiển thị lỗi nếu có lỗi
                }

                return Container(
                  alignment: Alignment.bottomRight,
                  padding: EdgeInsets.all(32),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal, // Cho phép cuộn ngang
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: 0,
                        maxWidth: MediaQuery.of(context)
                            .size
                            .width, // Giới hạn chiều rộng
                      ),
                      child: AutoSizeText(
                        displayText,
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1, // Giới hạn chỉ 1 dòng
                        minFontSize: 18, // Kích thước chữ nhỏ nhất khi thu nhỏ
                        overflow: TextOverflow
                            .clip, // Không thêm dấu '...', cho phép cuộn
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            flex: 3,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
              ),
              itemCount: buttons.length,
              itemBuilder: (context, index) {
                // Nếu là dấu "=" thì tô màu đỏ, ngược lại tô màu mặc định
                Color tileColor = (buttons[index] == '=')
                    ? const Color.fromARGB(255, 126, 154, 244)
                    : const Color.fromARGB(255, 238, 238, 238);

                return GestureDetector(
                  onTap: () {
                    _onButtonPressed(
                        context, buttons[index]); // Gọi hàm xử lý khi nhấn nút
                  },
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: tileColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        buttons[index],
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _onButtonPressed(BuildContext context, String value) {
    final calculatorBloc = context.read<CalculatorBloc>();

    if (value == 'C') {
      calculatorBloc.add(Clear());
    } else if (value == '+' || value == '-' || value == '*' || value == '/') {
      calculatorBloc.add(OperatorPressed(value));
    } else if (value == '=') {
      calculatorBloc.add(CalculateResult());
    } else {
      calculatorBloc.add(NumberPressed(value));
    }
  }
}
