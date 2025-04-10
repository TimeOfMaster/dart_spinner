import 'dart:io';
import 'dart:async';
import '../lib/terminal_spinner.dart';

Future<void> main() async {
  print('Terminal Spinner Demo\n');
  print('Demonstrating built-in spinner styles:\n');

  // Demo 1: Default ASCII Spinner
  print('1. Default ASCII Spinner:');
  await TerminalSpinner.run<void>(
    () => Future.delayed(const Duration(seconds: 2)),
    startMessage: 'Default ASCII spinner',
    doneMessage: '✓ Default spinner complete',
  );

  stdout.write('\n');

  // Demo 2: First Braille Pattern
  print('2. Braille Pattern Set 1:');
  await TerminalSpinner.run<void>(
    () => Future.delayed(const Duration(seconds: 2)),
    startMessage: 'Braille spinner 1',
    doneMessage: '✓ Braille spinner 1 complete',
    frames: TerminalSpinner.brailleFrames,
    interval: const Duration(milliseconds: 80),
  );

  stdout.write('\n');

  // Demo 3: Second Braille Pattern
  print('3. Braille Pattern Set 2:');
  await TerminalSpinner.run<void>(
    () => Future.delayed(const Duration(seconds: 2)),
    startMessage: 'Braille spinner 2',
    doneMessage: '✓ Braille spinner 2 complete',
    frames: TerminalSpinner.brailleFrames2,
    interval: const Duration(milliseconds: 100),
  );

  stdout.write('\n');

  // Demo 4: Manual Control Example
  print('4. Manual Control Demo:');
  final duration = 5; // Total seconds to run
  final manualSpinner = TerminalSpinner(
    message: 'Running for $duration more seconds',
    frames: TerminalSpinner.brailleFrames,
    interval: const Duration(milliseconds: 80),
  );

  manualSpinner.start();
  
  // Count down the seconds
  for (var i = duration; i >= 0; i--) {
    await Future.delayed(const Duration(seconds: 1));
    // Stop and restart spinner with new message to ensure clean update
    manualSpinner.stop();
    if (i > 0) {
      manualSpinner.message = 'Running for $i more seconds';
      manualSpinner.start();
    }
  }

  // Final cleanup
  manualSpinner.stop();
  print('✓ Manual control demo complete');

  print('\nDemo completed - all spinner types shown.');
  print('See documentation for more customization options.');
}