extension Country: CustomStringConvertible {
    public var description: String {
        return self.name
    }
}

extension Province: CustomStringConvertible {
    public var description: String {
        return self.rawValue
    }
}
