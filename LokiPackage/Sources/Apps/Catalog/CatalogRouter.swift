import SwiftUI
import PlaybookUI
import SakatsuFeature
import SettingsFeature
import UICore

@MainActor
public final class CatalogRouter {
    public static let shared = CatalogRouter()

    private init() {}
    
    public func firstScreen() -> some View {
        makePlaybookScreen()
            .task {
                Playbook.default.add(AllScenarios.self)
            }
    }
}

extension CatalogRouter {
    func sakatsuListScreen() -> some View {
        NavigationStack {
            makeSakatsuListScreen()
        }
    }
}

extension CatalogRouter: SakatsuRouterProtocol {
    public func settingsScreen() -> some View {
        NavigationStack {
            makeSettingsScreen()
        }
    }
}

// MARK: - Screen factory

private extension CatalogRouter {
    func makePlaybookScreen() -> some View {
        PlaybookScreen()
    }

    func makeSakatsuListScreen() -> some View {
        SakatsuListScreen(router: Self.shared)
    }

    func makeSettingsScreen() -> some View {
        SettingsScreen()
    }
}