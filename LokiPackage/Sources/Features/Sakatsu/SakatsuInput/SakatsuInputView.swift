import SwiftUI
import Algorithms
import SakatsuData

struct SakatsuInputView: View {
    let sakatsu: Sakatsu

    let onAddNewSaunaSetButtonClick: (() -> Void)
    let onFacilityNameChange: ((String) -> Void)
    let onVisitingDateChange: ((Date) -> Void)
    let onForewordChange: ((String?) -> Void)
    let onSaunaTitleChange: ((Int, String) -> Void)
    let onSaunaTimeChange: ((Int, TimeInterval?) -> Void)
    let onCoolBathTitleChange: ((Int, String) -> Void)
    let onCoolBathTimeChange: ((Int, TimeInterval?) -> Void)
    let onRelaxationTitleChange: ((Int, String) -> Void)
    let onRelaxationTimeChange: ((Int, TimeInterval?) -> Void)
    let onRemoveSaunaSetButtonClick: ((Int) -> Void)
    let onAfterwordChange: ((String?) -> Void)
    let onTemperatureTitleChange: (Int, String) -> Void
    let onTemperatureChange: (Int, Decimal?) -> Void
    let onTemperatureDelete: (IndexSet) -> Void
    let onAddNewTemperatureButtonClick: (() -> Void)

    var body: some View {
        Form {
            generalSection
            forewordSection
            saunaSetSections
            newSaunaSetSection
            afterwordSection
            temperaturesSection
        }
    }

    private var generalSection: some View {
        Section {
            HStack {
                Text(L10n.facilityName)
                TextField(L10n.required, text: .init(get: {
                    sakatsu.facilityName
                }, set: { newValue in
                    onFacilityNameChange(newValue)
                }))
            }
            DatePicker(
                L10n.visitingDate,
                selection: .init(get: {
                    sakatsu.visitingDate
                }, set: { newValue in
                    onVisitingDateChange(newValue)
                }),
                displayedComponents: [.date]
            )
        }
    }

    private var forewordSection: some View {
        Section {
            TextField(
                L10n.optional,
                text: .init(
                    get: {
                        sakatsu.foreword ?? ""
                    }, set: { newValue in
                        onForewordChange(newValue)
                    }
                ),
                axis: .vertical
            )
        } header: {
            Text(L10n.foreword)
        }
    }

    private var saunaSetSections: some View {
        ForEach(sakatsu.saunaSets.indexed(), id: \.index) { saunaSetIndex, saunaSet in
            Section {
                saunaSetItemTimeInputView(
                    saunaSetIndex: saunaSetIndex,
                    saunaSetItem: saunaSet.sauna,
                    onTitleChange: onSaunaTitleChange,
                    onTimeChange: onSaunaTimeChange
                )
                saunaSetItemTimeInputView(
                    saunaSetIndex: saunaSetIndex,
                    saunaSetItem: saunaSet.coolBath,
                    onTitleChange: onCoolBathTitleChange,
                    onTimeChange: onCoolBathTimeChange
                )
                saunaSetItemTimeInputView(
                    saunaSetIndex: saunaSetIndex,
                    saunaSetItem: saunaSet.relaxation,
                    onTitleChange: onRelaxationTitleChange,
                    onTimeChange: onRelaxationTimeChange
                )
            } header: {
                Text(L10n.setLld(saunaSetIndex + 1))
            } footer: {
                Button(L10n.deleteSet, role: .destructive) {
                    onRemoveSaunaSetButtonClick(saunaSetIndex)
                }
                .font(.footnote)
            }
        }
    }

    private var newSaunaSetSection: some View {
        Section {
            Button(L10n.addNewSet, action: onAddNewSaunaSetButtonClick)
        }
    }

    private var afterwordSection: some View {
        Section {
            TextField(
                L10n.optional,
                text: .init(
                    get: {
                        sakatsu.afterword ?? ""
                    }, set: { newValue in
                        onAfterwordChange(newValue)
                    }
                ),
                axis: .vertical
            )
        } header: {
            Text(L10n.afterword)
        }
    }

    private var temperaturesSection: some View {
        Section {
            ForEach(sakatsu.saunaTemperatures.indexed(), id: \.index) { saunaTemperatureIndex, saunaTemperature in
                saunaTemperatureInputView(
                    saunaTemperatureIndex: saunaTemperatureIndex,
                    saunaTemperature: saunaTemperature,
                    onTitleChange: onTemperatureTitleChange,
                    onTemperatureChange: onTemperatureChange
                )
            }
            .onDelete { offsets in
                onTemperatureDelete(offsets)
            }
            Button(L10n.addNewSaunaTemperatures, action: onAddNewTemperatureButtonClick)
                .font(.footnote)
        } header: {
            Text(L10n.temperatures)
        }
    }

    private func saunaSetItemTimeInputView(
        saunaSetIndex: Int,
        saunaSetItem: any SaunaSetItemProtocol,
        onTitleChange: @escaping (Int, String) -> Void,
        onTimeChange: @escaping (Int, TimeInterval?) -> Void
    ) -> some View {
        HStack {
            HStack(spacing: 0) {
                Text("\(saunaSetItem.emoji)")
                TextField(L10n.optional, text: .init(get: {
                    saunaSetItem.title
                }, set: { newValue in
                    onTitleChange(saunaSetIndex, newValue)
                }))
            }
            TextField(L10n.optional, value: .init(get: {
                saunaSetItem.time
            }, set: { newValue in
                onTimeChange(saunaSetIndex, newValue)
            }), format: .number)
            .keyboardType(.decimalPad)
            .multilineTextAlignment(.trailing)
            Text(saunaSetItem.unit)
        }
    }

    private func saunaTemperatureInputView(
        saunaTemperatureIndex: Int,
        saunaTemperature: SaunaTemperature,
        onTitleChange: @escaping (Int, String) -> Void,
        onTemperatureChange: @escaping (Int, Decimal?) -> Void
    ) -> some View {
        HStack {
            HStack(spacing: 0) {
                Text("\(saunaTemperature.emoji)")
                TextField(L10n.optional, text: .init(get: {
                    saunaTemperature.title
                }, set: { newValue in
                    onTitleChange(saunaTemperatureIndex, newValue)
                }))
            }
            TextField(L10n.optional, value: .init(get: {
                saunaTemperature.temperature
            }, set: { newValue in
                onTemperatureChange(saunaTemperatureIndex, newValue)
            }), format: .number)
            .keyboardType(.decimalPad)
            .multilineTextAlignment(.trailing)
            Text("℃")
        }
    }
}

#if DEBUG
struct SakatsuInputView_Previews: PreviewProvider {
    static var previews: some View {
        SakatsuInputView(
            sakatsu: .preview,
            onAddNewSaunaSetButtonClick: {},
            onFacilityNameChange: { _ in },
            onVisitingDateChange: { _ in },
            onForewordChange: { _ in },
            onSaunaTitleChange: { _, _ in },
            onSaunaTimeChange: { _, _ in },
            onCoolBathTitleChange: { _, _ in },
            onCoolBathTimeChange: { _, _ in },
            onRelaxationTitleChange: { _, _ in },
            onRelaxationTimeChange: { _, _ in },
            onRemoveSaunaSetButtonClick: { _ in },
            onAfterwordChange: { _ in },
            onTemperatureTitleChange: { _, _ in },
            onTemperatureChange: { _, _ in },
            onTemperatureDelete: { _ in },
            onAddNewTemperatureButtonClick: {}
        )
    }
}
#endif
