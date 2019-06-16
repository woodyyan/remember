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
        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("data.csv")
        FileManager.default.createFile(atPath: fileURL.path, contents: nil, attributes: nil)
        
        do {
            let csvReader = try CSVReader(string: csv)
            let stream = OutputStream(toFileAtPath: fileURL.path, append: false)!
            let csvWriter = try CSVWriter(stream: stream)
            
            while let row = csvReader.next() {
                try csvWriter.write(row: row)
            }
            csvWriter.stream.close()
        } catch {
            
        }
        
        return fileURL
    }
}
