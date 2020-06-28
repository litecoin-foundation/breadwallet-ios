import BRCore
import Foundation

// MARK: - Txn Metadata

// Txn metadata stores additional information about a given transaction
open class TxMetaData: BRKVStoreObject, BRCoding {
    var classVersion: Int = 2

    var blockHeight: Int = 0
    var exchangeRate: Double = 0
    var exchangeRateCurrency: String = ""
    var feeRate: Double = 0
    var size: Int = 0
    var created: Date = Date.zeroValue()
    var deviceId: String = ""
    var comment = ""

    public required init?(coder decoder: BRCoder) {
        classVersion = decoder.decode("classVersion")
        if classVersion == Int.zeroValue() {
            print("[BRTxMetadataObject] Unable to unarchive _TXMetadata: no version")
            return nil
        }
        blockHeight = decoder.decode("bh")
        exchangeRate = decoder.decode("er")
        exchangeRateCurrency = decoder.decode("erc")
        feeRate = decoder.decode("fr")
        size = decoder.decode("s")
        deviceId = decoder.decode("dId")
        created = decoder.decode("c")
        comment = decoder.decode("comment")
        super.init(key: "", version: 0, lastModified: Date(), deleted: true, data: Data())
    }

    func encode(_ coder: BRCoder) {
        coder.encode(classVersion, key: "classVersion")
        coder.encode(blockHeight, key: "bh")
        coder.encode(exchangeRate, key: "er")
        coder.encode(exchangeRateCurrency, key: "erc")
        coder.encode(feeRate, key: "fr")
        coder.encode(size, key: "s")
        coder.encode(created, key: "c")
        coder.encode(deviceId, key: "dId")
        coder.encode(comment, key: "comment")
    }

    // Find metadata object based on the txHash
    public init?(txHash: UInt256, store: BRReplicatedKVStore) {
        var ver: UInt64
        var date: Date
        var del: Bool
        var bytes: [UInt8]

        print("[BRTxMetadataObject] find \(txHash.txKey)")
        do {
            (ver, date, del, bytes) = try store.get(txHash.txKey)
            let bytesDat = Data(bytes: &bytes, count: bytes.count)
            super.init(key: txHash.txKey, version: ver, lastModified: date, deleted: del, data: bytesDat)
            return
        } catch let e {
            print("[BRTxMetadataObject] Unable to initialize BRTxMetadataObject: \(String(describing: e))")
        }

        return nil
    }

    // Find metadata object based on the txKey
    public init?(txKey: String, store: BRReplicatedKVStore) {
        var ver: UInt64
        var date: Date
        var del: Bool
        var bytes: [UInt8]

        print("[BRTxMetadataObject] find \(txKey)")
        do {
            (ver, date, del, bytes) = try store.get(txKey)
            let bytesDat = Data(bytes: &bytes, count: bytes.count)
            super.init(key: txKey, version: ver, lastModified: date, deleted: del, data: bytesDat)
            return
        } catch let e {
            print("[BRTxMetadataObject] Unable to initialize BRTxMetadataObject: \(String(describing: e))")
        }

        return nil
    }

    /// Create new transaction metadata
    public init(transaction: BRTransaction, exchangeRate: Double, exchangeRateCurrency: String, feeRate: Double,
                deviceId: String, comment: String? = nil) {
        print("[BRTxMetadataObject] new \(transaction.txHash.txKey)")
        super.init(key: transaction.txHash.txKey, version: 0, lastModified: Date(), deleted: false, data: Data())
        blockHeight = Int(transaction.blockHeight)
        created = Date()
        var txn = transaction
        size = BRTransactionSize(&txn)
        self.exchangeRate = exchangeRate
        self.exchangeRateCurrency = exchangeRateCurrency
        self.feeRate = feeRate
        self.deviceId = deviceId
        self.comment = comment ?? ""
    }

    override func getData() -> Data? {
        return BRKeyedArchiver.archivedDataWithRootObject(self)
    }

    override func dataWasSet(_ value: Data) {
        guard let s: TxMetaData = BRKeyedUnarchiver.unarchiveObjectWithData(value) else {
            print("[BRTxMetadataObject] unable to deserialise tx metadata")
            return
        }
        blockHeight = s.blockHeight
        exchangeRate = s.exchangeRate
        exchangeRateCurrency = s.exchangeRateCurrency
        feeRate = s.feeRate
        size = s.size
        created = s.created
        deviceId = s.deviceId
        comment = s.comment
    }
}

extension UInt256 {
    var txKey: String {
        var u = self
        return withUnsafePointer(to: &u) { p in
            let bd = Data(bytes: p, count: MemoryLayout<UInt256>.stride).sha256
            return "txn2-\(bd.hexString)"
        }
    }
}
