import WatchKit

class BRAWWeakTimerTarget: NSObject {
    weak var target: AnyObject?
    var selector: Selector?

    init(initTarget: AnyObject, initSelector: Selector) {
        super.init()
        target = initTarget
        selector = initSelector
    }

    @objc func timerDidFire() {
        if target != nil && selector != nil && target!.responds(to: selector!) {
            _ = target!.perform(selector!)
        }
    }
}
