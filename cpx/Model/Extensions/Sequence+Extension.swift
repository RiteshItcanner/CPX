//
//  Sequence+Extension.swift
//  Moon
//
//  Created by PYTHON on 07/11/23.
//

import Foundation

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var uniqueValues = Set<Element>()
        return filter { uniqueValues.insert($0).inserted }
    }
}

extension Collection {
    var jsonString: String {
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
        } catch {
            return invalidJson
        }
    }

    func toData() -> Data? {
        let string = jsonString
        return string.data(using: .utf8)
    }
}
