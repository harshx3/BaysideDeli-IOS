//
//  Extension.swift
//  BaysideDeli
//
//  Created by Harsh Makwana on 11/21/25.
//

import Foundation

extension String {
    /// Percent-encodes the string for use in URL fragments by default.
    /// Falls back to the original string if encoding fails.
    var urlEncoded: String {
        addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? self
    }

    /// Percent-encodes the string using a provided allowed character set.
    /// - Parameter allowed: The allowed character set to use for encoding.
    /// - Returns: An encoded string, or the original if encoding fails.
    func urlEncoded(allowed: CharacterSet) -> String {
        addingPercentEncoding(withAllowedCharacters: allowed) ?? self
    }
}
