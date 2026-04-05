// ======================= MIDI EVENT MODEL =======================
// Centrale representatie van MIDI berichten binnen de app
import Foundation

struct MIDIEvent {
    let status: UInt8 // Status byte (bijv. Note On = 0x90, CC = 0xB0)
    let data1: UInt8  // Note number of CC number
    let data2: UInt8  // Velocity of value
    let timestamp: UInt64 // Timing info (voor future sequencing)
}
