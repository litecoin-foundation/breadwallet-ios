import QuartzCore
import UIKit

extension UIView {
    @objc convenience init(color: UIColor) {
        self.init(frame: .zero)
        backgroundColor = color
    }

    var imageRepresentation: UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0.0)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let tempImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tempImage!
    }
}
