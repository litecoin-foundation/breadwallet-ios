import Foundation

struct Setting {
    let title: String
    let accessoryText: (() -> String)?
    let callback: () -> Void
}

extension Setting {
    init(title: String, callback: @escaping () -> Void) {
        self.title = title
        accessoryText = nil
        self.callback = callback
    }
}
