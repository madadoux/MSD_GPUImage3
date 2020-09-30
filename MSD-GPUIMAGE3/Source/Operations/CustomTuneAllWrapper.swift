//
//  CustomTuneAllWrapper.swift
//  Zesty
//
//  Created by ispha on 3/19/20.
//  Copyright © 2020 ispha. All rights reserved.
//

import Foundation
public class CustomTuneAllWrapper: BasicOperation {
    public var brightness:Float = 0.0 { didSet {
        
        
        
        uniformSettings["brightness"] = brightness
        
        
        } }
    public var saturation:Float = 0.0 { didSet {
           
           
           
           uniformSettings["saturation"] = saturation
           
           
           } }
    public var shadow:Float = 0.0 { didSet {
           
           
           
           uniformSettings["shadow"] = shadow
           
           
           } }
    public var vibrance:Float = 0.0 { didSet {
           
           
           
           uniformSettings["vibrance"] = vibrance
           
           
           } }
    public var contrast:Float = 0.0 { didSet {
           
           
           
           uniformSettings["contrast"] = contrast
           
           
           } }
   
   
    public init() {
        super.init(fragmentFunctionName:"tuneAllFragment", numberOfInputs:2)
    }
}
