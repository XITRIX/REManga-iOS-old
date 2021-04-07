//
//  ArrayExtensions.swift
//  REManga
//
//  Created by Даниил Виноградов on 10.03.2021.
//

import Foundation

extension Array {
    func crop(to size: Int) -> Self {
        if count <= size {
            return self
        }
        return Array(self[0..<size])
    }
}
