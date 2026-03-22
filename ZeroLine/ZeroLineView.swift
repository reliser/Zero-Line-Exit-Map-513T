import SwiftUI

struct ZeroLineView: View {

    @State private var connectivity = ConnectivityWatcher()
    @State private var linkLoader = RemoteLinkLoader()
    @State private var hasTriggeredFetch = false

    var body: some View {
        Group {
            if let destination = linkLoader.resolvedURL {
                InlineBrowserView(targetURL: destination)
            } else if connectivity.hasResolved && !connectivity.isReachable {
                offlinePanel
            } else {
                loadingPanel
            }
        }
        .onChange(of: connectivity.isReachable) { _, connected in
            guard connected, linkLoader.resolvedURL == nil else { return }
            linkLoader.obtainLink()
        }
        .onAppear {
            guard !hasTriggeredFetch else { return }
            hasTriggeredFetch = true
            if connectivity.isReachable {
                linkLoader.obtainLink()
            }
        }
    }

    private var offlinePanel: some View {
        VStack(spacing: 18) {
            Image(systemName: "wifi.slash")
                .font(.system(size: 56, weight: .thin))
                .foregroundStyle(.secondary)
            Text("No Internet Connection")
                .font(.title3.weight(.medium))
            Text("Waiting for network…")
                .font(.subheadline)
                .foregroundStyle(.tertiary)
            ProgressView()
                .padding(.top, 6)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }

    private var loadingPanel: some View {
        VStack(spacing: 14) {
            ProgressView()
                .controlSize(.large)
            Text("Loading…")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}
