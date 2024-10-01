import 'package:equatable/equatable.dart';

abstract class CalculatorEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class NumberPressed extends CalculatorEvent {
  final String number;
  NumberPressed(this.number);
  @override
  List<Object> get props => [number];
}

class OperatorPressed extends CalculatorEvent {
  final String operator;
  OperatorPressed(this.operator);
  @override
  List<Object> get props => [operator];
}

class CalculateResult extends CalculatorEvent {}

class Clear extends CalculatorEvent {}

class ClearEntry extends CalculatorEvent {}

class DeleteLastEntry extends CalculatorEvent {}
