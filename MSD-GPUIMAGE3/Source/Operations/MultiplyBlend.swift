public class MultiplyBlend: BasicOperation {
      public var intensity:Float = 0.0 { didSet { uniformSettings["intensity"] = intensity  } }
    public init() {
        super.init(fragmentFunctionName:"multiplyBlendFragment", numberOfInputs:2)
    }
}
