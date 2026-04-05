// ======================= APP INIT MET INPUT =======================

@main
struct MyMIDIApp: App {

    let midiService = MIDIService() // CoreMIDI service

    init() {
        midiService.startListening { event in
            print("Incoming MIDI: \(event)") // Debug input
        }
    }

    var body: some Scene {
        WindowGroup {
            KnobView(viewModel: KnobViewModel(midiService: midiService))
        }
    }
}
