// ======================= KNOB VIEW =======================
import SwiftUI

struct KnobView: View {

    @ObservedObject var viewModel: KnobViewModel // Binding naar VM

    var body: some View {
        VStack {
            Slider(value: $viewModel.value, in: 0...1) // UI slider
                .onChange(of: viewModel.value) { _ in
                    viewModel.valueChanged() // Trigger MIDI
                }
            
            Text("Value: \(viewModel.value)") // Debug output
        }
        .padding()
    }
}
