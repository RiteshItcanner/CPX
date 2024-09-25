//
//  String+Extension.swift
//  Moon
//
//  Created by PYTHON on 19/09/23.
//

import Foundation
import UIKit

extension String {
    var isEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,20}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    var double: Double {
        return Double(self) ?? 0.0
    }
    
    var int: Int {
        return Int(self) ?? 0
    }
    
}

extension String {
    static func format(strings: [String],
                       boldFont: UIFont = UIFont.boldSystemFont(ofSize: 14),
                       boldColor: UIColor = UIColor.blue,
                       inString string: String,
                       font: UIFont = UIFont.systemFont(ofSize: 14),
                       color: UIColor = UIColor.black) -> NSAttributedString {
        let attributedString =
        NSMutableAttributedString(string: string,
                                  attributes: [
                                    NSAttributedString.Key.font: font,
                                    NSAttributedString.Key.foregroundColor: color])
        let boldFontAttribute = [NSAttributedString.Key.font: boldFont, NSAttributedString.Key.foregroundColor: boldColor]
        for bold in strings {
            attributedString.addAttributes(boldFontAttribute, range: (string as NSString).range(of: bold))
        }
        return attributedString
    }
    
    static func formatSignUp(strings: [String],
                             boldFont: UIFont = UIFont.boldSystemFont(ofSize: 14),
                             boldColor: UIColor = UIColor.blue,
                             inString string: String,
                             font: UIFont = UIFont.systemFont(ofSize: 14),
                             color: UIColor = UIColor.black) -> NSAttributedString {
        let attributedString =
        NSMutableAttributedString(string: string,
                                  attributes: [
                                    NSAttributedString.Key.font: font,
                                    NSAttributedString.Key.foregroundColor: color])
        let boldFontAttribute = [NSAttributedString.Key.font: boldFont, NSAttributedString.Key.foregroundColor: boldColor]
        for bold in strings {
            attributedString.addAttributes(boldFontAttribute, range: (string as NSString).range(of: bold))
        }
        return attributedString
    }
}

extension String {
    func applyPatternOnNumbers(pattern: String, replacmentCharacter: Character) -> String {
        var pureNumber = replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)

        if pureNumber.count > 10 {
            pureNumber = String(pureNumber.suffix(10))
        }
        
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return pureNumber }
            let stringIndex = String.Index(utf16Offset: index, in: self)//String.Index(encodedOffset: index)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacmentCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }

        return pureNumber
    }
    
    func convertToDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }

}
