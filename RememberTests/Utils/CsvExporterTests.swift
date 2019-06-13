//
//  CsvExporterTests.swift
//  Remember
//
//  Created by Songbai Yan  on 2019/6/12.
//  Copyright © 2019 Songbai Yan. All rights reserved.
//

import XCTest

class CsvExporterTests: XCTestCase {
    func testCsvExport() {
        let exporter = CsvExporter()
        let csvString = "1,foo\n2,bar"
        exporter.export(csv: csvString)
        
        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("data.csv")
        let exists = FileManager.default.fileExists(atPath: fileURL.path)
        
        XCTAssert(exists)
        
        let text = try! String(contentsOf: fileURL, encoding: .utf8)
        XCTAssert(text == csvString)
    }
}
