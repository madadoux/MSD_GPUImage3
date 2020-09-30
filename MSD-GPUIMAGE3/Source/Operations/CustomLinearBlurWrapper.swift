//
//  CustomLinearBlurWrapper.swift
//  Zesty
//
//  Created by ispha on 3/18/20.
//  Copyright © 2020 ispha. All rights reserved.
//

import Foundation
public class CustomLinearBlurWrapper: BasicOperation {
    public var u_blurWinSize_abs:Float = 0.0 { didSet {uniformSettings["blurWinSize"] = 0.7*u_blurWinSize_abs} }
  public var angle_rad:Float = 0.0 { didSet {uniformSettings["angle"] = angle_rad*Float.pi/180} }
    public var centerY_norm:Float = 0.0 { didSet {uniformSettings["centerY"] = centerY_norm} }
    public var centerX_norm:Float = 0.0 { didSet {uniformSettings["centerX"] = centerX_norm} }
    public var trans_inY_norm:Float = 0.0 { didSet {uniformSettings["trans"] = trans_inY_norm } }
    public var clearDist_inY_norm:Float = 0.0 { didSet {uniformSettings["clearDist"] = clearDist_inY_norm} }
    
   
    public init() {
        super.init(fragmentFunctionName:"CustomLinearBlurFragment", numberOfInputs:2)
    }
}
