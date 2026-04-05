// ======================= MIDI ENGINE =======================
// Centrale orchestrator: verbindt input, routing en output

import Foundation

class MIDIEngine {

    private let midiService: MIDIService // CoreMIDI laag
    private let router: MIDIRouter       // Processing chain

    init(midiService: MIDIService) {
        self.midiService = midiService
        self.router = MIDIRouter()

        setupRouting()      // Configureer processors
        setupInputHandling()// Koppel input → routing
    }

    // ======================= ROUTING SETUP =======================
    private func setupRouting() {
        // Voorbeeld processor (kan je later dynamisch maken)
        let ccMapper = CCMapper(from: 1, to: 74) 
        // Mod wheel → cutoff

        router.addProcessor(ccMapper) // Voeg toe aan chain
    }

    // ======================= INPUT HANDLING =======================
    private func setupInputHandling() {

        midiService.startListening { [weak self] event in
            self?.handleIncoming(event: event) // Verwerk inkomend MIDI
        }
    }

    // ======================= MAIN PIPELINE =======================
    private func handleIncoming(event: MIDIEvent) {

        let processed = router.route(event: event) 
        // Door processor chain

        midiService.send(event: processed) 
        // Stuur naar output (THRU gedrag)
    }

    // ======================= UI INPUT =======================
    func sendFromUI(event: MIDIEvent) {

        let processed = router.route(event: event) 
        // Zelfde pipeline als externe input

        midiService.send(event: processed) 
        // Consistent gedrag
    }
}
