import UIKit

class BlinkingView: UIView {
    init(blinkColor: UIColor) {
        self.blinkColor = blinkColor
        super.init(frame: .zero)
    }

    func startBlinking() {
        timer = Timer.scheduledTimer(timeInterval: 0.53, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }

    func stopBlinking() {
        timer?.invalidate()
    }

    @objc private func update() {
        backgroundColor = backgroundColor == .clear ? blinkColor : .clear
    }

    private let blinkColor: UIColor
    private var timer: Timer?

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
