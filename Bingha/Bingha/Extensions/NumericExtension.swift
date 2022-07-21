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

extension Double {
    func setThreeDemical() -> String {
        let str = String(format: "%.3f", self)
        
        return str
    }
}
