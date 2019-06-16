//
//  CsvGenerator.swift
//  Remember
//
//  Created by Songbai Yan  on 2019/6/11.
//  Copyright © 2019 Songbai Yan. All rights reserved.
//

import Foundation
import CSV

class CsvExporter {
    
    func generateCsv(csv: String) -> URL {
        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("remember.csv")
        FileManager.default.createFile(atPath: fileURL.path, contents: nil, attributes: nil)
        
        do {
            let csvReader = try CSVReader(string: csv)
            let stream = OutputStream(toFileAtPath: fileURL.path, append: false)!
            let csvWriter = try CSVWriter(stream: stream)
            
            while let row = csvReader.next() {
                csvWriter.beginNewRow()
                for field in row {
                    try csvWriter.write(field: field, quoted: true)
                }
            }
            csvWriter.stream.close()
        } catch {
        }
        
        return fileURL
    }
}
