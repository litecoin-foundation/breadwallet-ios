import Foundation

#if os(Linux) && !swift(>=3.1)
    typealias NSRegularExpression = RegularExpression
#endif

fileprivate var regex: NSRegularExpression!

extension String {
    public func countryFromURL()throws -> Country? {
        if regex == nil {
            regex = try NSRegularExpression(pattern: "http(?:s)?:\\/\\/(?:(?:.*?)\\.)?(?:[^\\/]*?)(?:\\.co)?\\.(.*?)(?:\\/|$).*", options: [])
        }
        let code = regex.stringByReplacingMatches(
            in: self,
            options: [],
            range: NSMakeRange(0, self.utf8.count),
            withTemplate: "$1"
        )
        switch code {
        case "uk": return Country.unitedKingdom
        case "com": return Country.unitedStates
        default: return Country(rawValue: code)
        }
    }
    
    public func countryFromURL(`default`: Country = .allCountries)throws -> Country {
        return try self.countryFromURL() ?? `default`
    }
}
