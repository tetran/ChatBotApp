//
//  APILogger.swift
//  Advisers
//
//  Created by kkoichi on 2023/05/27.
//

import Foundation

class APILogger {
    
    static let shared = APILogger()
    
    private init() {}
    
    func putLog(_ text: String, prefix: String? = nil) {
        guard let logFilUrl = getOrCreateLogFile(prefix: prefix), let data = createLogMessage(text) else {
            return
        }
        
        do {
            let logHandle = try FileHandle(forWritingTo: logFilUrl)
            logHandle.seekToEndOfFile()
            logHandle.write(data)
        } catch {
            print(error)
        }
    }
    
    private func createLogMessage(_ text: String) -> Data? {
        "[\(Date().hourToSecondFormat())] \(text)\n".data(using: .utf8)
    }
    
    private func getOrCreateLogFile(prefix: String? = nil) -> URL? {
        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        let logFileName = "\(prefix ?? "api").\(Date().logFileFormat()).log"
        let logFileURL = documentsDirectory.appendingPathComponent(logFileName)
        if !fileManager.fileExists(atPath: logFileURL.path) {
            fileManager.createFile(atPath: logFileURL.path, contents: nil, attributes: nil)
        }
        
        return logFileURL
    }
}
