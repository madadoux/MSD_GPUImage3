//
//  CustomNormalBlurWrapper.swift
//  Zesty
//
//  Created by ispha on 3/17/20.
//  Copyright © 2020 ispha. All rights reserved.
//

import Foundation
public class CustomNormalBlurWrapper: BasicOperation {
    public var intensity:Float = 1.0 { didSet {uniformSettings["blurWinSize"] = 0.7*intensity} }
    public init() {
        super.init(fragmentFunctionName:"CustomNormalBlurFragment", numberOfInputs:2)
    }
}
