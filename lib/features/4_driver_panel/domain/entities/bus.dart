import 'package:equatable/equatable.dart';

class Bus extends Equatable {
  final String name;

  const Bus({required this.name});

  @override
  List<Object?> get props => [name];
}