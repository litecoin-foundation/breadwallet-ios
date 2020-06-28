import BRCore
import Foundation

struct SimpleUTXO {
    let hash: UInt256
    let index: UInt32
    let script: [UInt8]
    let satoshis: UInt64

    init?(json: [String: Any]) {
        guard let txid = json["txid"] as? String,
            let vout = json["vout"] as? Int,
            let scriptPubKey = json["scriptPubKey"] as? String,
            let satoshis = json["satoshis"] as? UInt64 else { return nil }
        guard let hashData = txid.hexToData,
            let scriptData = scriptPubKey.hexToData else { return nil }

        hash = hashData.reverse.uInt256
        index = UInt32(vout)
        script = [UInt8](scriptData)
        self.satoshis = satoshis
    }
}
