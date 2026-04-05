// ======================= APP MET ENGINE =======================

import SwiftUI

@main
struct MyMIDIApp: App {

    let midiService = MIDIService() // CoreMIDI
    let engine: MIDIEngine          // Centrale engine

    init() {
        engine = MIDIEngine(midiService: midiService) 
        // Koppel alles aan elkaar
    }

    var body: some Scene {
        WindowGroup {
            KnobView(viewModel: KnobViewModel(engine: engine))
            // Inject engine
        }
    }
}
