import Foundation

@Observable
final class RemoteLinkLoader {

    private(set) var resolvedURL: URL?
    private(set) var isBusy = false

    private let persistenceKey = "persisted_link"
    private let endpointString = "https://t-zero-line-exit-map-default-rtdb.firebaseio.com/pam.json?AIzaSyDhc0r1_-5DOBkkg14PCORX5AABGfcqpqk"

    var hasCachedLink: Bool {
        UserDefaults.standard.string(forKey: persistenceKey) != nil
    }

    func obtainLink() {
        if let stored = UserDefaults.standard.string(forKey: persistenceKey),
           let cached = URL(string: stored) {
            resolvedURL = cached
            return
        }
        fetchFromRemote()
    }

    private func fetchFromRemote() {
        guard !isBusy else { return }
        isBusy = true

        guard let endpoint = URL(string: endpointString) else {
            isBusy = false
            return
        }

        let task = URLSession.shared.dataTask(with: endpoint) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.handleRemoteResponse(data: data, response: response, error: error)
            }
        }
        task.resume()
    }

    private struct EndpointPayload: Decodable {
        let line: String
    }

    private func handleRemoteResponse(data: Data?, response: URLResponse?, error: Error?) {
        defer { isBusy = false }

        guard error == nil,
              let data,
              let payload = try? JSONDecoder().decode(EndpointPayload.self, from: data),
              let destination = URL(string: payload.line) else {
            return
        }

        UserDefaults.standard.set(payload.line, forKey: persistenceKey)
        resolvedURL = destination
    }
}
