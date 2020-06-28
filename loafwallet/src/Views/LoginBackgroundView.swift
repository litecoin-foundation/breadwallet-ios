import UIKit

class LoginBackgroundView: UIView, GradientDrawable {
    init() {
        super.init(frame: .zero)
        backgroundColor = .liteWalletBlue
    }

    private var hasSetup = false

    override func layoutSubviews() {
        guard !hasSetup else { return }
    }

    override func draw(_: CGRect) {}

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
