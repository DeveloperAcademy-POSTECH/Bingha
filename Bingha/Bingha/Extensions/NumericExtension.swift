//
//  NumericExtension.swift
//  Bingha
//
//  Created by Terry Koo on 2022/07/18.
//

import Foundation

extension Numeric {
    var formatterWithSeparator: String {
        Formatter.withSeparator.string(for: self) ?? ""
    }
}
