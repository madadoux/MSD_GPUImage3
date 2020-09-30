//
//  CustomNewMirrorShaderWrapper.swift
//  MyZesty
//
//  Created by ispha on 6/4/20.
//  Copyright © 2020 Facebook. All rights reserved.
//


public class CustomNewMirrorShaderWrapper: BasicOperation {
    public var intensity:Float = 1.0 { didSet {uniformSettings["intensity"] = intensity} }
  public var reverse:Float = 1.0 { didSet {uniformSettings["reverse"] = reverse} }
   public var orientation:Float = 0.0 { didSet {uniformSettings["orientation"] = orientation} }
    public init() {
        super.init(fragmentFunctionName:"CustomNewMirrorShader", numberOfInputs:2)
    }
}
