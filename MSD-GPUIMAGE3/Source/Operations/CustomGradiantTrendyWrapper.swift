//
//  CustomGradiantTrendyWrapper.swift
//  Zesty
//
//  Created by ispha on 4/1/20.
//  Copyright © 2020 ispha. All rights reserved.
//

public class CustomGradiantTrendyWrapper: BasicOperation {
    public var intensity:Float = 1.0 { didSet {uniformSettings["Intensity"] = intensity} }
     public var variation:Float = 1.0 { didSet {uniformSettings["variation"] = variation} }
    public init() {
        super.init(fragmentFunctionName:"GradientTrendyFragment", numberOfInputs:2)
    }
}
