// ======================= CC MAPPER =======================
// Zet een CC om naar een andere CC
class CCMapper: MIDIProcessor {

    let fromCC: UInt8 // Bron CC
    let toCC: UInt8   // Doel CC

    init(from: UInt8, to: UInt8) {
        self.fromCC = from
        self.toCC = to
    }

    func process(event: MIDIEvent) -> MIDIEvent {
        guard event.status == 0xB0, event.data1 == fromCC else {
            return event // Alleen aanpassen als CC matcht
        }

        return MIDIEvent(
            status: event.status,
            data1: toCC, // Nieuwe CC
            data2: event.data2,
            timestamp: event.timestamp
        )
    }
}
