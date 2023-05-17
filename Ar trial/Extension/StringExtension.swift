//
//  StringExtension.swift
//  Ar trial
//
//  Created by niudan on 2023/5/4.
//

import Foundation
import SwiftUI

extension String{
    mutating func Removelastblankspaces(){
        while self.last == " " {
            self.removeLast()
        }
    }
    var Droplastblankspaces:String{
        var Dropstring:String=self
        while Dropstring.last == " " {
            Dropstring.removeLast()
        }
        return Dropstring
    }
}
