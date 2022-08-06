//
//  BinghaLevelCalculator.swift
//  Bingha
//
//  Created by Terry Koo on 2022/07/20.
//

import Foundation

internal class IcebergLevelCalculator {
    public static let shared: IcebergLevelCalculator = Bingha.IcebergLevelCalculator()
    
    private init(){}
    
    func requestIcebergLevel(distance: Double) -> String {
        switch distance {
        case 0..<2:
            return "1"
        case 2..<8:
            return "2"
        case 8..<32:
            return "3"
        case 32..<64:
            return "4"
        default:
            return "5"
        }
    }
}
