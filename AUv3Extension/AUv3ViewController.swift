// ======================= AUv3 UI CONTROLLER =======================
import UIKit
import SwiftUI

class AUv3ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let midiService = MIDIService()
        let vm = KnobViewModel(midiService: midiService)

        let view = KnobView(viewModel: vm)
        let host = UIHostingController(rootView: view)

        addChild(host)
        host.view.frame = self.view.bounds
        self.view.addSubview(host.view)
        host.didMove(toParent: self)
    }
}
