//
//  NormalTrendyFragmentWrapper.swift
//  Zesty
//
//  Created by ispha on 4/3/20.
//  Copyright © 2020 ispha. All rights reserved.
//

public class CustomNormalTrendyWrapper: BasicOperation {
    private var parameters=[[Float]]()
    private var vignetteParam=[Float]()
  public var intensity:Float = 1.0 {
    didSet {
      uniformSettings["Intensity"] = intensity
      
    }
    
  }
    public var variation:Float = 1.0 {
      didSet{
        uniformSettings["brigtness"] = parameters[Int(variation)][5]
        uniformSettings["saturation"] = parameters[Int(variation)][0]
        uniformSettings["viberance"] = parameters[Int(variation)][2]
        uniformSettings["contrast"] = parameters[Int(variation)][3]
        uniformSettings["shadow"] = parameters[Int(variation)][4]
        uniformSettings["sepia"] = parameters[Int(variation)][1]
        uniformSettings["vignette"] = vignetteParam[Int(variation)]
        }
      
  }
    

    public init() {
        vignetteParam=[-1,-1,-1,0,-1,-1,-1,-1,0,0]
        parameters=[
        [0,0,0.18,1,0.57,0.13],
        [-1,0,0.69,0,-1,-0.11],
        [0,0,0.57,0,0.15,0.65],
        [0,0,0,1,1,0.5],
        [0,0,0.65,1,0.7,0.55],
        [-1,0,0.6,1,-1,0.7],
        [0,0,0.8,0,-1,0.8],
        [0,0,0.7,0.7,-1,0.7],
        [-1,0.3,0,0.1,0,0.1],
        [0,1,0,0,0,0]]
        super.init(fragmentFunctionName:"NormalTrendyFragment", numberOfInputs:2)
        
    }
}
