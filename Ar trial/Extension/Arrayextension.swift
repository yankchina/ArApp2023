//
//  Arrayextension.swift
//  Ar trial
//
//  Created by niudan on 2023/3/16.
//

import Foundation
import Metal

extension Array where Element:Comparable,Element:AdditiveArithmetic{
    var maxminusmin:Element?{
        if self.max() != nil,self.min() != nil {
            return (self.max()!)-self.min()!
        }else{
            return nil
        }
    }
    
    
}
extension Array where Element:Identifiable{
    //return index of certain item
    func findfirstindex(item:Element)->Int?{
        for index in 0..<self.count{
            if item.id==self[index].id {
                return index
            }
        }
        return nil
    }
}

extension Array {
    //if array.count==1,return the first item;else,return nil
    var firstelement:Element?{
        if self.count==1 {
            return self.first
        }
        return nil
    }
    
}
extension Array where Element == Bool{
    //if array.count==1,return the first item;else,return nil
    var binaryinteger:Int?{
        var returninteger:Int=0
        if self.isEmpty{
            return nil
        }
        for index in self.indices {
            returninteger += Int(pow(2, Double(index) )) * self[index].relatedinteger
        }
        return returninteger
    }
    func boolarrayplus()->[Bool]{
        var returnarray:[Bool]=Array(repeating: false, count: self.count)
        guard !self.isEmpty else {return  []}
        if self.firstIndex(of: false) == nil{
            return returnarray
        }
        returnarray=self
        for index in self.indices {
            returnarray[index].toggle()
            if returnarray.binaryinteger == self.binaryinteger!+1 {
                return returnarray
            }
        }
        
        
        
        return returnarray
    }
    
}
