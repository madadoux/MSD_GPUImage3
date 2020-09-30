//
//  CustomSunsetShaderWrapper.swift
//  Zesty
//
//  Created by ispha on 3/23/20.
//  Copyright © 2020 ispha. All rights reserved.
//


public class CustomSunsetShaderWrapper: BasicOperation {
    public var intensity:Float = 1.0 { didSet {uniformSettings["intensity"] = intensity} }
    
    public init() {
        super.init(fragmentFunctionName:"CustomSunsetShader", numberOfInputs:2)
    }
}
