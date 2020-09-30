//
//  CustomCircleBlurShaderWrapper.swift
//  Zesty
//
//  Created by ispha on 6/12/20.
//  Copyright © 2020 ispha. All rights reserved.
//

import Foundation
public class CustomCircleBlurShaderWrapper: BasicOperation {
    public var centerY:Float = 0.0 { didSet {uniformSettings["centerY"] = centerY} }
    public var centerX:Float = 0.0 { didSet {uniformSettings["centerX"] = centerX} }
    public var intensity:Float = 0.0 { didSet {uniformSettings["intensity"] = intensity} }
   
    public var radius:Float = 0.0 { didSet {uniformSettings["radius"] = radius} }
    
    public init() {
        super.init(fragmentFunctionName:"CustomCircleBlurShader", numberOfInputs:2)
    }
}
