import Foundation

public extension Task where Success == Never, Failure == Never {
    static func repeatingTimer(
        interval: TimeInterval,
        operation: @escaping @MainActor () -> Void
    ) -> Task<Void, Never> {
        .init {
            do {
                repeat {
                    try await Task.sleep(for: .seconds(interval))
                    await operation()
                    try Task.checkCancellation()
                } while true
            } catch {}
        }
    }
}
