// ======================= MIDI PROCESSOR PROTOCOL =======================
// Interface voor alle MIDI processing modules
protocol MIDIProcessor {
    func process(event: MIDIEvent) -> MIDIEvent // Elke processor transformeert een event
}
