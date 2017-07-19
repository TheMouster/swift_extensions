//
//  CharacterExtensions.swift
//

import Foundation

extension CharacterSet {
    
    /// Produces a string array from the characters in the CharacterSet.
    var characters:[String] {
        var result: [String] = []
        for plane: UInt8 in 0...16 where self.hasMember(inPlane: plane) {
            for unicode in UInt32(plane) << 16 ..< UInt32(plane + 1) << 16 {
                if let uniChar = UnicodeScalar(unicode), self.contains(uniChar) {
                    result.append(String(Character(uniChar)))
                }
            }
        }
        return result
    }
}
