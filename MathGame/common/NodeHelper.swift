//
//  NodeHelper.swift
//  MathGame
//
//  Created by Do Xuan Thanh on 1/7/19.
//  Copyright © 2019 monstar-lab. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class NodeHelper {
    static func scaledToWidth(node: SKSpriteNode, width: CGFloat){
        let scale = width / node.size.width
        node.size = CGSize(width: width, height: node.size.height * scale)
    }
}
