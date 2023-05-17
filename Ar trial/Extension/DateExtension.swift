//
//  DateExtension.swift
//  Ar trial
//
//  Created by niudan on 2023/5/12.
//

import Foundation
import SwiftUI

extension Date{
    func DatetoString(_ format: String)->String{
        let formatter=DateFormatter()
        formatter.dateFormat=format
        return formatter.string(from: self)
    }
}
