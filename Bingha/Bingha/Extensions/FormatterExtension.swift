//
//  FormatterExtension.swift
//  Bingha
//
//  Created by Terry Koo on 2022/07/18.
//

import Foundation

extension Formatter {
    // 세 자리마다 콤마 넣는 formatter 구현
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
}
