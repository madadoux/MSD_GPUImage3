//
//  CustomColorShaderWrapper.swift
//  Zesty
//
//  Created by ispha on 3/26/20.
//  Copyright © 2020 ispha. All rights reserved.
//

import Foundation
public class CustomColorShaderWrapper: BasicOperation {
    public var satValue0:Float = 0.0 { didSet {uniformSettings["satValue0"] = satValue0} }
    public var satValue1:Float = 0.0 { didSet {uniformSettings["satValue1"] = satValue1} }
    public var satValue2:Float = 0.0 { didSet {uniformSettings["satValue2"] = satValue2} }
    public var satValue3:Float = 0.0 { didSet {uniformSettings["satValue3"] = satValue3} }
    public var satValue4:Float = 0.0 { didSet {uniformSettings["satValue4"] = satValue4} }
    public var satValue5:Float = 0.0 { didSet {uniformSettings["satValue5"] = satValue5} }
    public var satValue6:Float = 0.0 { didSet {uniformSettings["satValue6"] = satValue6} }
    public var satValue7:Float = 0.0 { didSet {uniformSettings["satValue7"] = satValue7} }
    
    
    
    
    public var brightValue0:Float = 0.0 { didSet {uniformSettings["brightValue0"] = brightValue0} }
    public var brightValue1:Float = 0.0 { didSet {uniformSettings["brightValue1"] = brightValue1} }
    public var brightValue2:Float = 0.0 { didSet {uniformSettings["brightValue2"] = brightValue2} }
    public var brightValue3:Float = 0.0 { didSet {uniformSettings["brightValue3"] = brightValue3} }
    public var brightValue4:Float = 0.0 { didSet {uniformSettings["brightValue4"] = brightValue4} }
    public var brightValue5:Float = 0.0 { didSet {uniformSettings["brightValue5"] = brightValue5} }
    public var brightValue6:Float = 0.0 { didSet {uniformSettings["brightValue6"] = brightValue6} }
    public var brightValue7:Float = 0.0 { didSet {uniformSettings["brightValue7"] = brightValue7} }
    
    
    
    
    public var fade:Float = 0.0 { didSet {uniformSettings["fade"] = fade} }
    
    
    
    public var hueCenter0:Float = 0.0 { didSet {uniformSettings["hueCenter0"] = hueCenter0} }
    public var hueCenter1:Float = 30.0 { didSet {uniformSettings["hueCenter1"] = hueCenter1} }
    public var hueCenter2:Float = 48.0 { didSet {uniformSettings["hueCenter2"] = hueCenter2} }
    public var hueCenter3:Float = 95.0 { didSet {uniformSettings["hueCenter3"] = hueCenter3} }
    public var hueCenter4:Float = 180.0 { didSet {uniformSettings["hueCenter4"] = hueCenter4} }
    public var hueCenter5:Float = 208.0 { didSet {uniformSettings["hueCenter5"] = hueCenter5} }
    public var hueCenter6:Float = 290.0 { didSet {uniformSettings["hueCenter6"] = hueCenter6} }
    public var hueCenter7:Float = 315.0 { didSet {uniformSettings["hueCenter7"] = hueCenter7} }
    
    
    
    
    public var hueShiftAll:Float = 0.0 { didSet {uniformSettings["hueShiftAll"] = hueShiftAll/360.0} }
    
    
    
    public var hueShift0:Float = 0.0 { didSet {uniformSettings["hueShift0"] = hueShift0} }
    public var hueShift1:Float = 0.0 { didSet {uniformSettings["hueShift1"] = hueShift1} }
    public var hueShift2:Float = 0.0 { didSet {uniformSettings["hueShift2"] = hueShift2} }
    public var hueShift3:Float = 0.0 { didSet {uniformSettings["hueShift3"] = hueShift3} }
    public var hueShift4:Float = 0.0 { didSet {uniformSettings["hueShift4"] = hueShift4} }
    public var hueShift5:Float = 0.0 { didSet {uniformSettings["hueShift5"] = hueShift5} }
    public var hueShift6:Float = 0.0 { didSet {uniformSettings["hueShift6"] = hueShift6} }
    public var hueShift7:Float = 0.0 { didSet {uniformSettings["hueShift7"] = hueShift7} }
    
    
    public init() {
        super.init(fragmentFunctionName:"CustomColorShader", numberOfInputs:2)
    }
}
