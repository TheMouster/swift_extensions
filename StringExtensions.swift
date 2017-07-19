//
//  StringExtensions.swift
//

import Foundation

// MARK: String Extensions
extension String {
    
    /// Create `Data` from hexadecimal string representation
    ///
    /// This takes a hexadecimal representation and creates a `Data` object. Note, if the string has any spaces or non-hex characters (e.g. starts with '<' and with a '>'), those are ignored and only hex characters are processed.
    ///
    /// - returns: Data represented by this hexadecimal string.
    
    func hexadecimal() -> Data? {
        var data = Data(capacity: characters.count / 2)
        
        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: self, options: [], range: NSMakeRange(0, characters.count)) { match, flags, stop in
            let byteString = (self as NSString).substring(with: match!.range)
            var num = UInt8(byteString, radix: 16)!
            data.append(&num, count: 1)
        }
        
        guard data.count > 0 else {
            return nil
        }
        
        return data
    }
    
    /// Create `String` representation of `Data` created from hexadecimal string representation
    ///
    /// This takes a hexadecimal representation and creates a String object from that. Note, if the string has any spaces, those are removed. Also if the string started with a `<` or ended with a `>`, those are removed, too.
    ///
    /// For example,
    ///
    ///     String(hexadecimal: "<666f6f>")
    ///
    /// is
    ///
    ///     Optional("foo")
    ///
    /// - returns: `String` represented by this hexadecimal string.
    
    init?(hexadecimal string: String) {
        guard let data = string.hexadecimal() else {
            return nil
        }
        
        self.init(data: data, encoding: .utf8)
    }
    
    /// Create hexadecimal string representation of `String` object.
    ///
    /// For example,
    ///
    ///     "foo".hexadecimalString()
    ///
    /// is
    ///
    ///     Optional("666f6f")
    ///
    /// - parameter encoding: The `NSStringCoding` that indicates how the string should be converted to `NSData` before performing the hexadecimal conversion.
    ///
    /// - returns: `String` representation of this String object.
    
    func hexadecimalString() -> String? {
        return data(using: .utf8)?
            .hexadecimal()
    }
    
    /// Scrambles a string in a manner that is repeatable. i.e given the same seed, the same order will be produced.
    func repeatableScramble(seed:Int) -> String {
        var chars = Array(characters)
        var scrambled = ""
        
        srand48(seed)
        
        while chars.count > 0 {
            let index = Int(drand48() * Double(chars.count - 1))
            chars[index].write(to: &scrambled)
            chars.remove(at: index)
        }
        
        return scrambled
    }
    
    /// Enables subscripting of strings i.e. a character within a string can be accessed via [index] (Read Only).
    subscript(pos: Int) -> String {
        precondition(pos >= 0, "character position can't be negative")
        return self[pos...pos]
    }
    
    subscript(range: Range<Int>) -> String {
        precondition(range.lowerBound >= 0, "range lowerBound can't be negative")
        let lowerIndex = index(startIndex, offsetBy: range.lowerBound, limitedBy: endIndex) ?? endIndex
        return self[lowerIndex..<(index(lowerIndex, offsetBy: range.count, limitedBy: endIndex) ?? endIndex)]
    }
    
    subscript(range: ClosedRange<Int>) -> String {
        precondition(range.lowerBound >= 0, "range lowerBound can't be negative")
        let lowerIndex = index(startIndex, offsetBy: range.lowerBound, limitedBy: endIndex) ?? endIndex
        return self[lowerIndex..<(index(lowerIndex, offsetBy: range.count, limitedBy: endIndex) ?? endIndex)]
    }
    
    /// Finds the position of the first instance of a character in a string.
    public func index(of char: Character) -> Int? {
        if let idx = characters.index(of: char) {
            return characters.distance(from: startIndex, to: idx)
        }
        return nil
    }
    
    /// Replaces a character at a specified position within a string.
    func replace(_ index: Int, _ newChar: Character) -> String {
        var chars = Array(characters)
        chars[index] = newChar
        let modifiedString = String(chars)
        return modifiedString
    }
}

// MARK: Optional String Extensions
extension Optional where Wrapped == String {
    /// Indicator as to whether the string is nil or empty.
    var isNilOrEmpty : Bool {
        return (self ?? "").isEmpty
    }
    
    /// Indicator as to whether the string is nil or consists of whitespace characters.
    var isNilOrWhitespace : Bool {
        return self.isNilOrEmpty || self!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).characters.count == 0
    }
}

// MARK: Array String Extensions
extension Array where Iterator.Element == String {
    
    ///Case-insensitive array contains
    func containsCaseInsensitive(_ str: String) -> Bool {
        return (self.contains { $0.caseInsensitiveCompare(str) == .orderedSame })
    }
}


