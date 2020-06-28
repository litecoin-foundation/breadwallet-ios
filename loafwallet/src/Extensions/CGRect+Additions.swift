import UIKit

extension CGRect {
    var center: CGPoint {
        return CGPoint(x: midX, y: midY)
    }

    func expandVertically(_ deltaY: CGFloat) -> CGRect {
        var newFrame = self
        newFrame.origin.y = newFrame.origin.y - deltaY
        newFrame.size.height = newFrame.size.height + deltaY
        return newFrame
    }
}
