import UIKit

class SendCell: UIView {
    static let defaultHeight: CGFloat = 72.0

    init() {
        super.init(frame: .zero)
        setupViews()
    }

    let accessoryView = UIView()
    let border = UIView(color: .secondaryShadow)

    private func setupViews() {
        addSubview(accessoryView)
        addSubview(border)
        accessoryView.constrain([
            accessoryView.constraint(.top, toView: self),
            accessoryView.constraint(.trailing, toView: self),
            accessoryView.heightAnchor.constraint(equalToConstant: SendCell.defaultHeight),
        ])
        border.constrainBottomCorners(height: 1.0)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
