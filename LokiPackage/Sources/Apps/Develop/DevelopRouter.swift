import SwiftUI
import SakatsuFeature
import SettingsFeature
import UICore

@MainActor
public final class DevelopRouter {
    public static let shared = DevelopRouter()
    
    private init() {}
    
    public func firstScreen() -> some View {
        NavigationStack {
            makeSakatsuListScreen()
        }
    }
}

extension DevelopRouter: SakatsuRouterProtocol {
    public func settingsScreen() -> some View {
        NavigationStack {
            makeSettingsScreen()
        }
    }
}

// MARK: - Screen factory

private extension DevelopRouter {
    func makeSakatsuListScreen() -> some View {
        SakatsuListScreen(router: Self.shared)
    }
    
    func makeSettingsScreen() -> some View {
        SettingsScreen()
    }
}