//
//  CustomInverseRadialBlurWrapper.swift
//  Zesty
//
//  Created by ispha on 4/30/20.
//  Copyright © 2020 ispha. All rights reserved.
//

import Foundation
public class CustomInverseRadialBlurWrapper:  BasicOperation {
    public var centerY_norm:Float = 0.0 { didSet {uniformSettings["centerY"] = centerY_norm} }
    public var centerX_norm:Float = 0.0 { didSet {uniformSettings["centerX"] = centerX_norm} }
    public var trans:Float = 0.0 { didSet {uniformSettings["trans"] = trans} }
    public var b:Float = 0.0 { didSet {uniformSettings["b"] = b} }
    public var a:Float = 0.0 { didSet {uniformSettings["a"] = a} }
    public var angle:Float = 0.0 { didSet {uniformSettings["angle"] = angle} }
    public var blurWinSize:Float = 0.0 { didSet {uniformSettings["blurWinSize"] = 0.7*blurWinSize} }
    
   
    public init() {
        super.init(fragmentFunctionName:"CustomInverseRadialBlurFragment", numberOfInputs:2)
    }
}
