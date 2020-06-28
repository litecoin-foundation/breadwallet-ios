extension Country: CustomStringConvertible {
    public var description: String {
        return name
    }
}

extension Province: CustomStringConvertible {
    public var description: String {
        return rawValue
    }
}
