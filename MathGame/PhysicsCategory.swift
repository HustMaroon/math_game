//
//  PhysicsCategory.swift
//  MathGame
//
//  Created by Do Xuan Thanh on 1/3/19.
//  Copyright © 2019 monstar-lab. All rights reserved.
//

import Foundation
struct PhysicsCategory {
    static let none      : UInt32 = 0
    static let all       : UInt32 = UInt32.max
    static let balloon   : UInt32 = 0b1       // 1
    static let projectile: UInt32 = 0b10      // 2
}
