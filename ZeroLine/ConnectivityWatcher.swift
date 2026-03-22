import Foundation
import Network

@Observable
final class ConnectivityWatcher {

    private(set) var isReachable = false
    private(set) var hasResolved = false

    private let pathMonitor: NWPathMonitor
    private let monitorQueue = DispatchQueue(label: "connectivity.watcher.queue")

    init() {
        pathMonitor = NWPathMonitor()
        startObserving()
    }

    deinit {
        pathMonitor.cancel()
    }

    private func startObserving() {
        pathMonitor.pathUpdateHandler = { [weak self] updatedPath in
            DispatchQueue.main.async {
                self?.isReachable = updatedPath.status == .satisfied
                self?.hasResolved = true
            }
        }
        pathMonitor.start(queue: monitorQueue)
    }
}
