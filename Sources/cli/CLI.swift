import ArgumentParser
import Foundation
import TerminalUtilities

#if canImport(Darwin)
import Darwin
#else
import Glibc
#endif

@main
struct TerminalUtilitiesCLI: AsyncParsableCommand {
    static var configuration: CommandConfiguration {
        CommandConfiguration(subcommands: [
            SizeCommand.self,
            SizeObserverCommand.self,
            AnimateCommand.self,
            RepeatingTimer.self
        ])
    }

    mutating func run() async throws {}
}

struct SizeCommand: ParsableCommand {
    static var configuration: CommandConfiguration {
        CommandConfiguration(commandName: "size")
    }

    mutating func run() {
        print("Current window dimensions:", Terminal.size(), separator: "\n")
    }
}

struct SizeObserverCommand: ParsableCommand {
    static var configuration: CommandConfiguration {
        CommandConfiguration(commandName: "size-observer")
    }

    mutating func run() {
        print("Running size observer, change the size of your terminal window to see the output change")
        print("Press Ctrl+C to stop")

        Terminal.showCursor(false)
        defer { Terminal.showCursor(true) }
        Terminal.onInterruptionExit {
            Terminal.showCursor(true)
        }

        func currentSizeMessage(_ size: Size) -> String {
            "Current window dimensions: \(size)"
        }

        var lastSizeMessageLength: Int?

        let initialSizeMessage = currentSizeMessage(Terminal.size())
        lastSizeMessageLength = initialSizeMessage.count
        print(initialSizeMessage)
        Terminal.cursorUp()

        Terminal.onSizeChange { size in
            if let lastSizeMessageLength {
                Terminal.eraseChars(lastSizeMessageLength)
            }
            let sizeMessage = currentSizeMessage(size)
            lastSizeMessageLength = sizeMessage.count
            print(sizeMessage, terminator: "")
            fflush(stdout)
        }

        Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in }
        RunLoop.current.run()
    }
}

struct AnimateCommand: AsyncParsableCommand {
    static var configuration: CommandConfiguration {
        CommandConfiguration(
            commandName: "animate",
            abstract: "Perform a small animation, demonstrating clearing characters and hiding the cursor"
        )
    }

    mutating func run() async throws {
        Terminal.showCursor(false)
        defer { Terminal.showCursor(true) }
        Terminal.onInterruptionExit {
            Terminal.showCursor(true)
        }

        print("\n")

        var currentFrame = 0

        while currentFrame <= 40 {
            let toPrint = String(repeating: "_", count: currentFrame) + "⚽"
            let spaces = String(repeating: "_", count: 40 - currentFrame) + "🥅"
            print(toPrint + spaces, terminator: "")
            fflush(stdout)
            try await Task.sleep(for: .seconds(0.04))
            if currentFrame == 40 { break }
            Terminal.eraseChars(toPrint.count + spaces.count + 2)
            currentFrame += 1
        }

        print("\n")
        print("🎉_________________GOAL!_________________🎉")
        print("\n")
    }
}

struct RepeatingTimer: AsyncParsableCommand {
    static var configuration: CommandConfiguration {
        CommandConfiguration(
            commandName: "timer",
            abstract: "Run a repeating timer for 5 seconds"
        )
    }

    func run() async throws {
        print(">>> Starting timer. Press ctrl+c to exit.\n")
        Terminal.onInterruptionExit {
            print("Bye 🙂")
        }

        var index = 0
        let timerTask = Task.repeatingTimer(interval: 1) {
            print("\(index)...")
            index += 1
        }

        await timerTask.value
    }
}
