//
//  NSObject+Extension.swift
//  Moon
//
//  Created by PYTHON on 17/09/23.
//

import Foundation

extension NSObject {
    class var nameOfClass: String {
        return NSStringFromClass(self).components(separatedBy: ".").last! as String
    }
    
    class var classIdentifier: String {
        return String(format: "%@", nameOfClass)
    }
}

extension Dictionary {
    mutating func merge(dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}
