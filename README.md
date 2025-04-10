# Dart Terminal Spinner

A customizable terminal spinner library for Dart applications. Create loading animations with various styles and manual control options.

## Features

- Multiple built-in spinner styles (ASCII and Braille patterns)
- Customizable animation speed
- Manual control for complex progress sequences
- Automatic cleanup on completion
- Support for custom frame patterns

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  dart_spinner: ^1.0.0
```

## Usage

### Basic Usage

```dart
import 'package:dart_spinner/terminal_spinner.dart';

// Simple spinner with default style
await TerminalSpinner.run(
  () => Future.delayed(const Duration(seconds: 2)),
  startMessage: 'Loading...',
  doneMessage: '✓ Complete',
);
```

### Built-in Spinner Styles

```dart
// ASCII Style (default)
// Frames: | / - \

// Braille Pattern Set 1
// Frames: ⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏
await TerminalSpinner.run(
  () => yourAsyncTask(),
  frames: TerminalSpinner.brailleFrames,
  interval: const Duration(milliseconds: 80),
);

// Braille Pattern Set 2
// Frames: ⠿ ⠷ ⠯ ⠟ ⠻ ⠽ ⠾
await TerminalSpinner.run(
  () => yourAsyncTask(),
  frames: TerminalSpinner.brailleFrames2,
  interval: const Duration(milliseconds: 100),
);
```

### Manual Control

```dart
final spinner = TerminalSpinner(
  message: 'Processing...',
  frames: TerminalSpinner.brailleFrames,
);

spinner.start();
// Do some work
spinner.message = 'Almost done...';
// Do more work
spinner.stop(finalMessage: '✓ Complete');
```

## API Reference

### TerminalSpinner Class

#### Constructor

```dart
TerminalSpinner({
  String message = '',
  Duration interval = const Duration(milliseconds: 100),
  List<String>? frames,
})
```

#### Static Methods

- `run<T>()`: Run an async task with a spinner
- `defaultFrames`: Default ASCII spinner frames
- `brailleFrames`: First set of Braille pattern frames
- `brailleFrames2`: Second set of Braille pattern frames

#### Instance Methods

- `start()`: Start the spinner animation
- `stop({String? finalMessage})`: Stop the spinner and optionally show a final message
