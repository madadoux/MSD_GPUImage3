//
//  CustomBlendWrapper.swift
//  Zesty
//
//  Created by ispha on 1/15/20.
//  Copyright © 2020 ispha. All rights reserved.
//

import Foundation
public class CustomBlendWrapper: BasicOperation {
    public var intensity:Float = 0.0 { didSet {
        
        
        
        uniformSettings["intensity"] = intensity
        
        
        } }
    public init() {
        super.init(fragmentFunctionName:"customBlendFragment", numberOfInputs:2)
    }
}
