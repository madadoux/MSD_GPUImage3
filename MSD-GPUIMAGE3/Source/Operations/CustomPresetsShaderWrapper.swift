//
//  CustomPresetsShaderWrapper.swift
//  Zesty
//
//  Created by ispha on 3/23/20.
//  Copyright © 2020 ispha. All rights reserved.
//


public class CustomPresetsShaderWrapper: BasicOperation {
    public var intensity:Float = 1.0 { didSet {uniformSettings["intensity"] = intensity} }
     public var variation:Float = 1.0 { didSet {uniformSettings["variation"] = variation} }
    public init() {
        super.init(fragmentFunctionName:"CustomPresetsShader", numberOfInputs:2)
    }
}
