// ======================= MIDI SERVICE (FULL IMPLEMENTATION) =======================
// Volledige CoreMIDI implementatie met input, output en virtual ports

import Foundation
import CoreMIDI

class MIDIService {

    // ======================= CORE MIDI REFERENCES =======================
    private var client = MIDIClientRef()              // MIDI client (root object)
    private var inputPort = MIDIPortRef()             // Input port voor ontvangen events
    private var outputPort = MIDIPortRef()            // Output port voor verzenden

    private var virtualSource = MIDIEndpointRef()     // Virtual output (naar andere apps)
    private var virtualDestination = MIDIEndpointRef()// Virtual input (van andere apps)

    private var inputCallback: ((MIDIEvent) -> Void)? // Callback naar app layer

    // ======================= INIT =======================
    init() {
        setupMIDI() // Initialiseer alles
    }

    // ======================= SETUP =======================
    private func setupMIDI() {

        // Maak MIDI client
        MIDIClientCreate("MyMIDIClient" as CFString, nil, nil, &client)

        // Maak output port (voor versturen naar externe devices)
        MIDIOutputPortCreate(client, "OutputPort" as CFString, &outputPort)

        // Maak input port (voor ontvangen van devices)
        MIDIInputPortCreate(client, "InputPort" as CFString, midiReadCallback, UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque()), &inputPort)

        // ======================= VIRTUAL PORTS =======================

        // Virtual SOURCE = andere apps zien dit als output van jouw app
        MIDISourceCreate(client, "My Virtual MIDI Out" as CFString, &virtualSource)

        // Virtual DESTINATION = andere apps sturen MIDI naar jouw app
        MIDIDestinationCreate(client, "My Virtual MIDI In" as CFString, midiReadCallback, UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque()), &virtualDestination)

        // ======================= CONNECT TO ALL INPUT DEVICES =======================

        let sourceCount = MIDIGetNumberOfSources() // Aantal beschikbare MIDI bronnen

        for i in 0..<sourceCount {
            let source = MIDIGetSource(i) // Haal bron op
            MIDIPortConnectSource(inputPort, source, nil) // Verbind met input port
        }
    }

    // ======================= SEND MIDI =======================
    func send(event: MIDIEvent) {

        var packet = MIDIPacket() // Maak packet
        
        packet.timeStamp = 0
        packet.length = 3
        packet.data.0 = event.status
        packet.data.1 = event.data1
        packet.data.2 = event.data2

        var packetList = MIDIPacketList(numPackets: 1, packet: packet)

        // ======================= SEND TO ALL DESTINATIONS =======================

        let destinationCount = MIDIGetNumberOfDestinations()

        for i in 0..<destinationCount {
            let destination = MIDIGetDestination(i)
            MIDISend(outputPort, destination, &packetList) // Stuur naar device
        }

        // ======================= SEND TO VIRTUAL SOURCE =======================
        MIDIReceived(virtualSource, &packetList) // Stuur naar andere apps
    }

    // ======================= START LISTENING =======================
    func startListening(callback: @escaping (MIDIEvent) -> Void) {
        self.inputCallback = callback // Sla callback op
    }

    // ======================= HANDLE INCOMING =======================
    private func handle(packetList: UnsafePointer<MIDIPacketList>) {

        var packet = packetList.pointee.packet // Eerste packet

        for _ in 0..<packetList.pointee.numPackets {

            let event = MIDIEvent(
                status: packet.data.0,
                data1: packet.data.1,
                data2: packet.data.2,
                timestamp: packet.timeStamp
            )

            inputCallback?(event) // Geef door aan app

            packet = MIDIPacketNext(&packet).pointee // Volgende packet
        }
    }
}

// ======================= C CALLBACK BRIDGE =======================
// CoreMIDI gebruikt C callbacks → brug naar Swift class
private func midiReadCallback(
    packetList: UnsafePointer<MIDIPacketList>,
    readProcRefCon: UnsafeMutableRawPointer?,
    srcConnRefCon: UnsafeMutableRawPointer?
) {

    let midiService = Unmanaged<MIDIService>
        .fromOpaque(readProcRefCon!)
        .takeUnretainedValue() // Haal Swift instance terug

    midiService.handle(packetList: packetList) // Forward naar class
}
