# Terminal Utilities

A Swift library providing utilities for terminal manipulation, information, and control.

To learn more about the reasoning behind this library, and the implementation, read the article on _SwiftToolkit.dev_: [Techniques for Engaging CLIs with the Terminal Utilities Package](https://swifttoolkit.dev/posts/terminal-utilities).

## Installation

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/swifttoolkit/terminal-utilities.git", from: "0.1.0")
]
```

And then add the dependency to your target:

```swift
targets: [
    .executableTarget(
        name: "YourTarget",
        dependencies: [
            .product(name: "TerminalUtilities", package: "terminal-utilities"),
        ]
    )
]
```

## Usage

```swift
import TerminalUtilities

// Get terminal size
let size = Terminal.size()
print("Terminal: \(size.width) x \(size.height)")

// Cursor control
Terminal.showCursor(false)  // Hide cursor
Terminal.cursorUp(3)        // Move up 3 lines
Terminal.eraseChars(10)     // Erase 10 characters
Terminal.eraseScreen()      // Erase the entire screen

// Size change events
Terminal.onSizeChange { newSize in
    print("Resized to: \(newSize)")
}

// Interruption exit events (Ctrl+C)
Terminal.onInterruptionExit {
    Terminal.showCursor(true)
}
```

## Sample CLI Tool

This package includes a sample CLI tool that you can use to test the package capabilities directly in your terminal:

```bash
# Print the current size
swift run terminal-utilities-cli size           

# Demo animation
swift run terminal-utilities-cli animate       

# Monitor size changes in real-time
swift run terminal-utilities-cli size-observer 
```
