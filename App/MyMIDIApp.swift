// ======================= MAIN APP =======================
import SwiftUI

@main
struct MyMIDIApp: App {

    let midiService = MIDIService() // Shared service

    var body: some Scene {
        WindowGroup {
            KnobView(viewModel: KnobViewModel(midiService: midiService))
            // Inject dependency
        }
    }
}
