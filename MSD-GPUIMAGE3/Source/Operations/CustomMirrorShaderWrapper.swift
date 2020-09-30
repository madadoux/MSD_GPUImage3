//
//  CustomMirrorShaderWrapper.swift
//  Zesty
//
//  Created by ispha on 5/11/20.
//  Copyright © 2020 ispha. All rights reserved.
//

import Foundation
public class CustomMirrorShaderWrapper: BasicOperation {
    public var intensity:Float = 1.0 { didSet {uniformSettings["intensity"] = intensity} }
     public var reverse:Float = 0.0 { didSet {uniformSettings["reverse"] = reverse} }
    public init() {
        super.init(fragmentFunctionName:"CustomMirrorShader", numberOfInputs:2)
    }
}
