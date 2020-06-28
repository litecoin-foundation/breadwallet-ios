import Foundation
import UIKit

class DonationSetupCell: UIView {
    static let defaultHeight: CGFloat = 72.0

    init(store: Store, isLTCSwapped: Bool) {
        self.store = store
        self.isLTCSwapped = isLTCSwapped
        donateButton = ShadowButton(title: S.Donate.title, type: .tertiary)
        super.init(frame: .zero)
        setupViews()
    }

    let border = UIView(color: .secondaryShadow)
    var isLTCSwapped: Bool
    var donateButton = ShadowButton(title: S.Donate.title, type: .tertiary)
    var didTapToDonate: (() -> Void)?
    private let store: Store

    private func setupViews() {
        addSubview(donateButton)
        addSubview(border)

        donateButton.translatesAutoresizingMaskIntoConstraints = false
        donateButton.addTarget(self, action: #selector(donateToLF), for: .touchUpInside)

        guard let fiatSymbol = store.state.currentRate?.currencySymbol else { return }
        donateButton.title = String(format: S.Donate.title, isLTCSwapped ? "\(fiatSymbol)" : "Ł")

        let viewsDictionary = ["donateButton": donateButton, "border": border]
        var viewConstraints = [NSLayoutConstraint]()

        let constraintsHorizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:|-25-[donateButton(190)]-25-|", options: [], metrics: nil, views: viewsDictionary)
        viewConstraints += constraintsHorizontal

        let descriptionConstraintVertical = NSLayoutConstraint.constraints(withVisualFormat: "V:|-16-[donateButton]-16-|", options: [], metrics: nil, views: viewsDictionary)

        viewConstraints += descriptionConstraintVertical
        border.constrainBottomCorners(height: 1.0)
        NSLayoutConstraint.activate(viewConstraints)
    }

    @objc func donateToLF() {
        didTapToDonate?()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
