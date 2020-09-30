//
//  CustomCurvesShaderWrapper.swift
//  MyZesty
//
//  Created by ispha on 3/30/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation
public class CustomCurvesShaderWrapper: BasicOperation {
    public var intensity:Float = 1.0 { didSet {uniformSettings["intensity"] = intensity} }
    public init() {
        super.init(fragmentFunctionName:"CustomCurvesShader", numberOfInputs:2)
    }
}
