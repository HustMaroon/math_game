//
//  operationScope.swift
//  
//
//  Created by Do Xuan Thanh on 1/4/19.
//

import Foundation
class OperationScope {
    static let shared = OperationScope()
    var grade : Int = 0
    var level : Int = 0
    private init(){
        if(grade != 0){
            return
        } else {
            grade = 1
        }
    }
    
    func setGrade(newGrade : Int){
        grade = newGrade
    }
    
    func operatorsSet() -> [String]{
        switch grade {
        case Constants.grade1:
            return [Constants.plus, Constants.sub]
        case Constants.grade2:
            return [Constants.plus, Constants.sub, Constants.multi]
        case Constants.grade3:
            return [Constants.plus, Constants.sub, Constants.multi, Constants.div]
        default:
            return [Constants.plus, Constants.sub, Constants.multi, Constants.div]
        }
    }
    
    func numberScope() -> Int {
        switch grade {
        case Constants.grade1:
            return 10
        case Constants.grade2:
            return 100
        case Constants.grade3:
            return 1000
        default:
            return 1000
        }
    }
    
    func setGrade(grade: Int){
        self.grade = grade
    }
}
