// ======================= KNOB VIEWMODEL =======================
import Foundation
import SwiftUI

class KnobViewModel: ObservableObject {

    @Published var value: Float = 0.0 // UI waarde 0.0 - 1.0

    private let midiService: MIDIService // MIDI dependency

    init(midiService: MIDIService) {
        self.midiService = midiService
    }

    func valueChanged() {
        let midiValue = UInt8(value * 127) // Map naar MIDI range
        
        let event = MIDIEvent(
            status: 0xB0, // CC
            data1: 74,    // Cutoff
            data2: midiValue,
            timestamp: 0
        )
        
        midiService.send(event: event) // Verstuur MIDI
    }
}
