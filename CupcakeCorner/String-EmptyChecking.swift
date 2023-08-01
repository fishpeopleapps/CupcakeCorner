//
//  String-EmptyChecking.swift
//  CupcakeCorner
//
//  Created by Kimberly Brewer on 8/1/23.
//

import Foundation
/// Ensures that users can't just submit an empty string of whitespaces
extension String {
    var isReallyEmpty: Bool {
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
