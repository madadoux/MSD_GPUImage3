//
//  CustomRainBowShaderWrapper.swift
//  Zesty
//
//  Created by ispha on 3/20/20.
//  Copyright © 2020 ispha. All rights reserved.
//

import Foundation
public class CustomRainBowShaderWrapper: BasicOperation {
    public var intensity:Float = 1.0 { didSet {uniformSettings["intensity"] = 0.7*intensity} }
    public init() {
        super.init(fragmentFunctionName:"CustomRainBowShader", numberOfInputs:2)
    }
}
