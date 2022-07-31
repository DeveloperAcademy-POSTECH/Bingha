//
//  Storage.swift
//  Bingha
//
//  Created by Terry Koo on 2022/07/28.
//

import Foundation


public class Storage {
    static func isFirstTime() -> Bool {
        let defaults = UserDefaults.standard
        if defaults.object(forKey: "isFirstTime") == nil {
            defaults.set("No", forKey:"isFirstTime")
            return true
        } else {
            return false
        }
    }
}
