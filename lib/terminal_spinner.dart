import 'dart:io';
import 'dart:async';

/// Creates an animated spinner effect in the terminal.
///
/// The class comes with three built-in frame sets:
/// - [defaultFrames]: Basic ASCII spinner ['|', '/', '-', '\']
/// - [brailleFrames]: Braille animation ['⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏']
/// - [brailleFrames2]: Alternative Braille dots animation ['⠿', '⠷', '⠯', '⠟', '⠻', '⠽', '⠾']
class TerminalSpinner {
  final List<String> _frames;
  final Duration _interval;
  String message;

  static const List<String> defaultFrames = ['|', '/', '-', r'\'];
  static const List<String> brailleFrames = ['⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏'];
  static const List<String> brailleFrames2 = ['⠿', '⠷', '⠯', '⠟', '⠻', '⠽', '⠾'];

  Timer? _timer;
  int _frameIndex = 0;
  bool _isRunning = false;
  String _currentOutput = '';
  int _lastOutputLength = 0; // To track length for proper clearing

  /// Creates a terminal spinner.
  ///
  /// - [message]: Text to display before the spinner. Defaults to empty string.
  /// - [interval]: How often the spinner frame updates. Defaults to 100ms.
  /// - [frames]: The sequence of characters to cycle through for the animation.
  ///            Defaults to [defaultFrames] if not specified.
  TerminalSpinner({
    this.message = '', // Default to empty if no message needed
    Duration interval = const Duration(milliseconds: 100),
    List<String>? frames,
  }) : _frames = frames ?? defaultFrames,
       _interval = interval; // Initialize _interval

  /// Starts the spinner animation.
  void start() {
    if (_isRunning) return; // Already running

    // Ensure cursor is visible if it might have been hidden
    // Note: Hiding/showing cursor might not work on all terminals
    // stdout.write('\x1B[?25h'); // Show cursor ANSI code (optional)

    _isRunning = true;
    _frameIndex = 0;
    _lastOutputLength = 0; // Reset length tracking
    _timer?.cancel(); // Cancel any potentially existing timer (safety)
    _timer = Timer.periodic(_interval, _tick);
    _tick(null); // Initial print
  }

  /// Stops the spinner animation and clears the line.
  ///
  /// - [finalMessage]: Optional message to print *after* clearing the spinner line.
  ///                   If null, the line is just cleared.
  /// - [clearLine]: Whether to clear the line occupied by the spinner. Defaults to true.
  void stop({String? finalMessage, bool clearLine = true}) {
    if (!_isRunning) return; // Already stopped

    _timer?.cancel();
    _isRunning = false;

    if (clearLine) {
      // Move cursor to beginning, clear line, move cursor back
      stdout.write('\r${' ' * _lastOutputLength}\r');
    }

    // Ensure cursor is visible after stopping (optional)
    // stdout.write('\x1B[?25h'); // Show cursor ANSI code

    if (finalMessage != null) {
      print(finalMessage); // Print a final status message if provided
    }
  }

  // Internal method called by the timer to update the frame
  void _tick(Timer? timer) {
    if (!_isRunning) return;

    final frame = _frames[_frameIndex % _frames.length];
    // Add a space between message and frame if message is not empty
    final messageSeparator = message.isNotEmpty ? ' ' : '';
    _currentOutput = '$message$messageSeparator$frame';
    _lastOutputLength = _currentOutput.length;

    // '\r' moves the cursor to the beginning of the line
    stdout.write('\r$_currentOutput');

    _frameIndex++;
  }

  /// A convenience static method to run an asynchronous task with a spinner.
  ///
  /// Example:
  /// ```
  /// await TerminalSpinner.run(
  ///   () => Future.delayed(Duration(seconds: 2)),
  ///   startMessage: "Working...",
  ///   doneMessage: "Finished!",
  ///   frames: ['⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏']
  /// );
  /// ```
  static Future<T> run<T>(
      Future<T> Function() task, {
        String startMessage = 'Working...',
        String? doneMessage = 'Done.', // Null message means no final output on stop
        String errorMessage = 'Error.', // Message shown if task throws exception
        Duration interval = const Duration(milliseconds: 100),
        List<String>? frames,
      }) async {
    final spinner = TerminalSpinner(
      message: startMessage,
      interval: interval,
      frames: frames,
    );
    spinner.start();
    try {
      final result = await task();
      spinner.stop(finalMessage: doneMessage);
      return result;
    } catch (e, s) { // Catch error and stack trace
      spinner.stop(finalMessage: '$errorMessage\nError details: $e');
      // Optionally print stack trace for debugging: print(s);
      rethrow; // Re-throw the original error
    }
  }
}