//
//  CustomBlackNWhiteShaderWrapper.swift
//  Zesty
//
//  Created by ispha on 3/23/20.
//  Copyright © 2020 ispha. All rights reserved.
//


public class CustomBlackNWhiteShaderWrapper: BasicOperation {
    public var intensity:Float = 1.0 { didSet {uniformSettings["intensity"] = intensity} }
    public init() {
        super.init(fragmentFunctionName:"CustomBlackNWhiteShader", numberOfInputs:2)
    }
}
