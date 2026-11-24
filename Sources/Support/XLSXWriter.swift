import Foundation

/// 生成真正的 .xlsx（单表、表头加粗、冻结首行、自动换行、列宽）
enum XLSXWriter {

    struct Sheet {
        var name: String = "设备故障台账"
        var header: [String]
        var rows: [[String]]
    }

    static func build(sheet: Sheet, to url: URL) throws {
        let files: [String] = [
            "[Content_Types].xml",
            "_rels/.rels",
            "xl/workbook.xml",
            "xl/_rels/workbook.xml.rels",
            "xl/styles.xml",
            "xl/worksheets/sheet1.xml"
        ]

        var entries: [ZipWriter.Entry] = []
        for name in files {
            let xml: String
            switch name {
            case "[Content_Types].xml": xml = contentTypes
            case "_rels/.rels": xml = rootRels
            case "xl/workbook.xml": xml = workbookXml(sheetName: sheet.name)
            case "xl/_rels/workbook.xml.rels": xml = workbookRels
            case "xl/styles.xml": xml = stylesXml
            default: xml = sheetXml(sheet: sheet)
            }
            entries.append(ZipWriter.Entry(name: name, data: Data(xml.utf8)))
        }

        let data = ZipWriter.archive(entries)
        try data.write(to: url, options: .atomic)
    }

    // MARK: - 工作表

    private static func columnName(_ index: Int) -> String {
        var value = index
        var name = ""
        repeat {
            let remainder = value % 26
            name = String(UnicodeScalar(65 + remainder)!) + name
            value = value / 26 - 1
        } while value >= 0
        return name
    }

    private static func sheetXml(sheet: Sheet) -> String {
        var xml = """
        <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
        <worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">
        <sheetViews><sheetView tabSelected="1" workbookViewId="0"><pane ySplit="1" topLeftCell="A2" activePane="bottomLeft" state="frozen"/></sheetView></sheetViews>
        <cols>
        """
        for (index, _) in sheet.header.enumerated() {
            let width = index == sheet.header.count - 1 ? 60.0 : 20.0
            xml += "<col min=\"\(index + 1)\" max=\"\(index + 1)\" width=\"\(width)\" customWidth=\"1\"/>"
        }
        xml += "</cols><sheetData>"

        // 表头
        xml += "<row r=\"1\" ht=\"26\" customHeight=\"1\">"
        for (index, title) in sheet.header.enumerated() {
            let ref = columnName(index) + "1"
            xml += "<c r=\"\(ref)\" s=\"1\" t=\"inlineStr\"><is><t>\(escape(title))</t></is></c>"
        }
        xml += "</row>"

        // 数据行
        for (rowIndex, row) in sheet.rows.enumerated() {
            let excelRow = rowIndex + 2
            xml += "<row r=\"\(excelRow)\">"
            for (colIndex, value) in row.enumerated() {
                let ref = columnName(colIndex) + "\(excelRow)"
                if value.isEmpty { continue }
                xml += "<c r=\"\(ref)\" s=\"2\" t=\"inlineStr\"><is><t xml:space=\"preserve\">\(escape(value))</t></is></c>"
            }
            xml += "</row>"
        }

        xml += "</sheetData><pageMargins left=\"0.5\" right=\"0.5\" top=\"0.5\" bottom=\"0.5\"/></worksheet>"
        return xml
    }

    private static func escape(_ text: String) -> String {
        var out = text
            .replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
        out = out.replacingOccurrences(of: "\"", with: "&quot;")
        // 去掉非法控制字符
        out = out.unicodeScalars.filter { scalar in
            !(scalar.value < 0x20 && scalar.value != 0x09 && scalar.value != 0x0A)
        }.map { String($0) }.joined()
        return out
    }

    // MARK: - 固定部件

    private static let contentTypes = """
    <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
    <Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
    <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
    <Default Extension="xml" ContentType="application/xml"/>
    <Override PartName="/xl/workbook.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/>
    <Override PartName="/xl/worksheets/sheet1.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>
    <Override PartName="/xl/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.styles+xml"/>
    </Types>
    """

    private static let rootRels = """
    <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
    <Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
    <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="xl/workbook.xml"/>
    </Relationships>
    """

    private static func workbookXml(sheetName: String) -> String {
        """
        <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
        <workbook xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">
        <sheets><sheet name="\(escape(sheetName))" sheetId="1" r:id="rId1"/></sheets>
        </workbook>
        """
    }

    private static let workbookRels = """
    <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
    <Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
    <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet1.xml"/>
    <Relationship Id="rId2" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles" Target="styles.xml"/>
    </Relationships>
    """

    private static let stylesXml = """
    <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
    <styleSheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">
    <fonts count="2">
    <font><sz val="11"/><name val="PingFang SC"/></font>
    <font><b/><sz val="11"/><color rgb="FFFFFFFF"/><name val="PingFang SC"/></font>
    </fonts>
    <fills count="3">
    <fill><patternFill patternType="none"/></fill>
    <fill><patternFill patternType="gray125"/></fill>
    <fill><patternFill patternType="solid"><fgColor rgb="FF1B2A41"/><bgColor indexed="64"/></patternFill></fill>
    </fills>
    <borders count="1"><border><left/><right/><top/><bottom/><diagonal/></border></borders>
    <cellStyleXfs count="1"><xf numFmtId="0" fontId="0" fillId="0" borderId="0"/></cellStyleXfs>
    <cellXfs count="3">
    <xf numFmtId="0" fontId="0" fillId="0" borderId="0" xfId="0"/>
    <xf numFmtId="0" fontId="1" fillId="2" borderId="0" xfId="0" applyFont="1" applyFill="1" applyAlignment="1"><alignment vertical="center"/></xf>
    <xf numFmtId="0" fontId="0" fillId="0" borderId="0" xfId="0" applyAlignment="1"><alignment vertical="top" wrapText="1"/></xf>
    </cellXfs>
    <cellStyles count="1"><cellStyle name="Normal" xfId="0" builtinId="0"/></cellStyles>
    </styleSheet>
    """
}
