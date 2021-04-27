//
//  Shell.swift
//  RealDeviceMap
//
//  Created by Florian Kostenzer on 29.10.18.
//

import Foundation

class Shell {

    private var args: [String]

    init(_ args: String...) {
        self.args = args
    }

    func run(errorPipe: Any? = nil, inputPipe: Any? = nil, environment: [String: String]? = nil) -> String? {
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        if environment != nil {
            task.environment = environment
        }
        task.arguments = args
        let pipe = Pipe()
        if errorPipe != nil {
            task.standardError = errorPipe
        }
        if inputPipe != nil {
            task.standardInput = inputPipe
        }
        task.standardOutput = pipe
        do {
            try task.run()
        } catch {
            return "env show command failed\n"
        }
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        task.waitUntilExit()
        return String(data: data, encoding: String.Encoding.utf8)
    }

    func runError(standardPipe: Any? = nil, inputPipe: Any? = nil, environment: [String: String]? = nil) -> String? {
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        if environment != nil {
            task.environment = environment
        }
        task.arguments = args
        let pipe = Pipe()
        if standardPipe != nil {
            task.standardOutput = standardPipe
        }
        if inputPipe != nil {
            task.standardInput = inputPipe
        }
        task.standardError = pipe
        do {
            try task.run()
        } catch {
            return "env show command failed\n"
        }
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        task.waitUntilExit()
        return String(data: data, encoding: String.Encoding.utf8)
    }

}
