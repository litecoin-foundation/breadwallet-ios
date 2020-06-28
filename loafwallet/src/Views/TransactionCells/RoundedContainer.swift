import UIKit

class RoundedContainer: UIView {
    var style: TransactionCellStyle = .middle {
        didSet {
            setNeedsLayout()
        }
    }

    override func layoutSubviews() {
        if #available(iOS 11.0, *) {
            guard let backgroundColor = UIColor(named: "lfBackgroundColor") else {
                NSLog("ERROR: Custom color not found")
                return
            }
            self.backgroundColor = backgroundColor
        }
        let maskLayer = CAShapeLayer()
        let corners: UIRectCorner
        switch style {
        case .first:
            corners = [.topLeft, .topRight]
        case .last:
            corners = [.bottomLeft, .bottomRight]
        case .single:
            corners = .allCorners
        case .middle:
            corners = []
        }
        maskLayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: 4.0, height: 4.0)).cgPath
        layer.mask = maskLayer
    }
}
