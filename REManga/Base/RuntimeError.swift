//
//  RuntimeError.swift
//  REManga
//
//  Created by Даниил Виноградов on 10.03.2021.
//

import Foundation

struct RuntimeError: Error {
    let message: String

    init(_ message: String) {
        self.message = message
    }

    public var localizedDescription: String {
        return message
    }
}
