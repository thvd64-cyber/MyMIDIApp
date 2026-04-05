// ======================= KNOB VIEWMODEL (ENGINE CONNECTIE) =======================

class KnobViewModel: ObservableObject {

    @Published var value: Float = 0.0 // UI waarde

    private let engine: MIDIEngine // Gebruik engine i.p.v. direct service

    init(engine: MIDIEngine) {
        self.engine = engine
    }

    func valueChanged() {

        let midiValue = UInt8(value * 127) // Map naar MIDI

        let event = MIDIEvent(
            status: 0xB0, // CC
            data1: 74,    // Cutoff
            data2: midiValue,
            timestamp: 0
        )

        engine.sendFromUI(event: event) // Via centrale pipeline
    }
}
