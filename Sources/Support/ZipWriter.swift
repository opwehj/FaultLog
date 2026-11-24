import Foundation

/// 极简 ZIP 打包（仅存储不压缩，够用来生成 xlsx）
enum ZipWriter {

    struct Entry {
        let name: String
        let data: Data
    }

    static func archive(_ entries: [Entry]) -> Data {
        var out = Data()
        var central = Data()

        for entry in entries {
            let nameData = Data(entry.name.utf8)
            let crc = crc32(entry.data)
            let size = UInt32(entry.data.count)
            let offset = UInt32(out.count)

            // 本地文件头
            out.appendUInt32(0x04034b50)
            out.appendUInt16(10)      // 所需版本
            out.appendUInt16(0)       // 标志
            out.appendUInt16(0)       // 存储方式：不压缩
            out.appendUInt16(0)       // 时间
            out.appendUInt16(0x21)    // 日期（1980-01-01）
            out.appendUInt32(crc)
            out.appendUInt32(size)
            out.appendUInt32(size)
            out.appendUInt16(UInt16(nameData.count))
            out.appendUInt16(0)
            out.append(nameData)
            out.append(entry.data)

            // 中央目录
            central.appendUInt32(0x02014b50)
            central.appendUInt16(20)
            central.appendUInt16(10)
            central.appendUInt16(0)
            central.appendUInt16(0)
            central.appendUInt16(0)
            central.appendUInt16(0x21)
            central.appendUInt32(crc)
            central.appendUInt32(size)
            central.appendUInt32(size)
            central.appendUInt16(UInt16(nameData.count))
            central.appendUInt16(0)   // extra
            central.appendUInt16(0)   // comment
            central.appendUInt16(0)   // disk
            central.appendUInt16(0)   // internal attrs
            central.appendUInt32(0)   // external attrs
            central.appendUInt32(offset)
            central.append(nameData)
        }

        let centralOffset = UInt32(out.count)
        out.append(central)

        // 中央目录结束记录
        out.appendUInt32(0x06054b50)
        out.appendUInt16(0)
        out.appendUInt16(0)
        out.appendUInt16(UInt16(entries.count))
        out.appendUInt16(UInt16(entries.count))
        out.appendUInt32(UInt32(central.count))
        out.appendUInt32(centralOffset)
        out.appendUInt16(0)

        return out
    }

    // MARK: - CRC32

    private static let crcTable: [UInt32] = {
        (0..<256).map { index -> UInt32 in
            var value = UInt32(index)
            for _ in 0..<8 {
                if value & 1 == 1 {
                    value = 0xEDB88320 ^ (value >> 1)
                } else {
                    value = value >> 1
                }
            }
            return value
        }
    }()

    static func crc32(_ data: Data) -> UInt32 {
        var crc: UInt32 = 0xFFFFFFFF
        for byte in data {
            let index = Int((crc ^ UInt32(byte)) & 0xFF)
            crc = crcTable[index] ^ (crc >> 8)
        }
        return crc ^ 0xFFFFFFFF
    }
}

private extension Data {
    mutating func appendUInt16(_ value: UInt16) {
        append(UInt8(value & 0xFF))
        append(UInt8((value >> 8) & 0xFF))
    }

    mutating func appendUInt32(_ value: UInt32) {
        append(UInt8(value & 0xFF))
        append(UInt8((value >> 8) & 0xFF))
        append(UInt8((value >> 16) & 0xFF))
        append(UInt8((value >> 24) & 0xFF))
    }
}
