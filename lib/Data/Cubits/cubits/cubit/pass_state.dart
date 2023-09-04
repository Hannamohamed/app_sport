part of 'pass_cubit.dart';

@immutable
sealed class PassState {}

final class PasswordHidden extends PassState {}

final class PasswordVisible extends PassState {}
