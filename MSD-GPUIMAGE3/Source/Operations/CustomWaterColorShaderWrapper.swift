//
//  CustomSketchShaderWrapper.swift
//  Zesty
//
//  Created by ispha on 3/20/20.
//  Copyright © 2020 ispha. All rights reserved.
//

import Foundation
public class CustomWaterColorShaderWrapper: BasicOperation {
    public var intensity:Float = 1.0 { didSet {uniformSettings["intensity"] = intensity} }
    public init() {
        super.init(fragmentFunctionName:"CustomWaterColorShader", numberOfInputs:2)
    }
}
