//
//  AXHistory.swift
//  AXMalvon
//
//  Created by Ashwin Paudel on 2022-12-30.
//  Copyright © 2022-2023 Aayam(X). All rights reserved.
//

import AppKit

struct AXHistoryItem: Equatable {
    var title: String
    var url: String
    var date: String
    
    static func == (lhs: AXHistoryItem, rhs: AXHistoryItem) -> Bool {
        return lhs.url == rhs.url
    }
}

class AXHistory {
    static var filePath: URL = NSURL.appDataURL().appendingPathComponent("browser.history")
    
    static func checkIfFileExists() {
        let file = AXHistory.filePath
        if !FileManager.default.fileExists(atPath: file.path) {
            try! String("").write(to: file, atomically: true, encoding: .utf8)
        }
    }
    
    static func appendItem(title: String, url: String) {
        let today = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd/MM/yyyy"
        let dateString = dateFormat.string(from: today)
        
        let string = "\(title)\r\(url)\r\(dateString)\n"
        let data = string.data(using: .utf8)!
        let handle = FileHandle(forWritingAtPath: AXHistory.filePath.path)!
        handle.seekToEndOfFile()
        handle.write(data)
        handle.closeFile()
    }
    
    static func getAllItems() -> [AXHistoryItem] {
        var items: [AXHistoryItem] = []
        
        let contents = try! String(contentsOf: AXHistory.filePath)
        let lines = contents.split(separator: "\n")
        
        for line in lines {
            let item = parseLine(line)
            items.append(item)
        }
        
        return items
    }
    
    static func removeAll() {
        let file = AXHistory.filePath
        try! String("").write(to: file, atomically: true, encoding: .utf8)
    }
    
    static func updateHistoryFile(items: [AXHistoryItem]) {
        var result = ""
        
        for item in items {
            result += "\(item.title)\r\(item.url)\r\(item.date)\n"
        }
        
        try! result.write(to: AXHistory.filePath, atomically: true, encoding: .utf8)
    }
    
    static func removeDuplicates() {
        let items = getAllItems()
        
        let uniqueItems = items.filter { item in
            items.firstIndex(of: item) == items.lastIndex(of: item)
        }
        
        updateHistoryFile(items: uniqueItems)
    }
}

fileprivate func parseLine(_ line: String.SubSequence) -> AXHistoryItem {
    let values = line.components(separatedBy: "\r")
    
    let item = AXHistoryItem(title: values.first!, url: values[1], date: values.last!)
    return item
}
