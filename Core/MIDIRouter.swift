// ======================= MIDI ROUTER =======================
// Stuurt MIDI events door een chain van processors
class MIDIRouter {

    private var processors: [MIDIProcessor] = [] // Lijst van processing stappen

    func addProcessor(_ processor: MIDIProcessor) {
        processors.append(processor) // Voeg processor toe aan chain
    }

    func route(event: MIDIEvent) -> MIDIEvent {
        var current = event // Start met origineel event
        
        for processor in processors {
            current = processor.process(event: current) 
            // Pas elke processor toe
        }
        
        return current // Resultaat na processing
    }
}
