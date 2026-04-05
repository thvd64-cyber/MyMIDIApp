// ======================= MIDI SERVICE =======================
// Abstractie boven CoreMIDI (placeholder voor echte implementatie)
import Foundation
import CoreMIDI

class MIDIService {

    private var client = MIDIClientRef() // CoreMIDI client
    private var outputPort = MIDIPortRef() // Output port

    init() {
        MIDIClientCreate("MyMIDIClient" as CFString, nil, nil, &client) 
        // Maak MIDI client
        
        MIDIOutputPortCreate(client, "OutputPort" as CFString, &outputPort) 
        // Maak output port
    }

    func send(event: MIDIEvent) {
        var packet = MIDIPacket() // MIDI packet container
        
        packet.timeStamp = 0
        packet.length = 3
        packet.data.0 = event.status
        packet.data.1 = event.data1
        packet.data.2 = event.data2
        
        var packetList = MIDIPacketList(numPackets: 1, packet: packet)
        
        // TODO: connect naar echte endpoint
        // MIDISend(outputPort, destination, &packetList)
    }

    func startListening(callback: @escaping (MIDIEvent) -> Void) {
        // TODO: Input port + callback implementeren
    }
}
