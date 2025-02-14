import SwiftUI
import SakatsuData
import UICore

public struct SettingsScreen: View {
    private let onLicensesButtonClick: () -> Void
    @StateObject private var viewModel: SettingsViewModel<DefaultSaunaTimeUserDefaultsClient, SakatsuValidator>

    @Environment(\.dismiss) private var dismiss

    public var body: some View {
        SettingsView(
            defaultSaunaTimes: viewModel.uiState.defaultSaunaTimes,
            onDefaultSaunaTimeChange: { defaultSaunaTime in
                viewModel.onDefaultSaunaTimeChange(defaultSaunaTime: defaultSaunaTime)
            }, onDefaultCoolBathTimeChange: { defaultCoolBathTime in
                viewModel.onDefaultCoolBathTimeChange(defaultCoolBathTime: defaultCoolBathTime)
            }, onDefaultRelaxationTimeChange: { defaultRelaxationTime in
                viewModel.onDefaultRelaxationTimeChange(defaultRelaxationTime: defaultRelaxationTime)
            }, onLicensesButtonClick: {
                onLicensesButtonClick()
            }
        )
        .navigationTitle(L10n.settings)
        .settingsScreenToolbar(onCloseButtonClick: { dismiss() })
        .errorAlert(
            error: viewModel.uiState.settingsError,
            onDismiss: { viewModel.onErrorAlertDismiss() }
        )
    }

    public init(onLicensesButtonClick: @escaping () -> Void) {
        self.onLicensesButtonClick = onLicensesButtonClick
        self._viewModel = StateObject(wrappedValue: SettingsViewModel())
    }
}

private extension View {
    func settingsScreenToolbar(
        onCloseButtonClick: @escaping () -> Void
    ) -> some View {
        toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    onCloseButtonClick()
                } label: {
                    Image(systemName: "xmark")
                }
            }
        }
    }
}

#if DEBUG
struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsScreen(onLicensesButtonClick: {})
        }
    }
}
#endif
