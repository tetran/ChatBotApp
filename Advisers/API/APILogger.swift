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
    
    func putLog(_ text: String, apiName: String) {
        guard let logFilUrl = getOrCreateLogFile(), let data = createLogMessage(text, apiName: apiName) else {
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
    
    private func createLogMessage(_ text: String, apiName: String) -> Data? {
        "[\(Date().logTextFormat())] [API: \(apiName)] \(text)\n".data(using: .utf8)
    }
    
    private func getOrCreateLogFile() -> URL? {
        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        let logFileName = "api.\(Date().logFileFormat()).log"
        let logFileURL = documentsDirectory.appendingPathComponent(logFileName)
        if !fileManager.fileExists(atPath: logFileURL.path) {
            fileManager.createFile(atPath: logFileURL.path, contents: nil, attributes: nil)
        }
        
        return logFileURL
    }
}
