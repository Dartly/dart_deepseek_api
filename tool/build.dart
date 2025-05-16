import 'dart:io';

void main() async {
  // 运行构建命令生成JSON序列化代码
  final buildProcess = await Process.start('dart', [
    'run',
    'build_runner',
    'build',
    '--delete-conflicting-outputs',
  ], mode: ProcessStartMode.inheritStdio);

  // 等待构建完成
  final exitCode = await buildProcess.exitCode;
  print('构建完成，退出码: $exitCode');

  exit(exitCode);
}
