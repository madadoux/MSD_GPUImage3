#if canImport(UIKit)
import UIKit
#else
import Cocoa
#endif
import MetalKit
  func pixelData(cgImage:CGImage) -> [UInt8]? {
    let size = CGSize(width: cgImage.width, height: cgImage.height)
       let dataSize = size.width * size.height * 4
       var pixelData = [UInt8](repeating: 0, count: Int(dataSize))
       let colorSpace = CGColorSpaceCreateDeviceRGB()
       let context = CGContext(data: &pixelData,
                               width: Int(size.width),
                               height: Int(size.height),
                               bitsPerComponent: 8,
                               bytesPerRow: 4 * Int(size.width),
                               space: colorSpace,
                               bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)
       context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))

       return pixelData
   }
 /*
 guard let device =   MTLCreateSystemDefaultDevice() else {
   return "mtl device not enabled on this"
 }
 let textureDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: MTLPixelFormat.rgba16Uint, width: internalImage!.width, height: internalImage!.height, mipmapped: false)
 guard let texture: MTLTexture = device.makeTexture(descriptor: textureDescriptor) else { return nil }
 let region = MTLRegionMake2D(0, 0, Int(internalImage!.width), Int(internalImage!.height))
 
 var textureData = pixelData(cgImage: internalImage!)
 texture.replace(region: region, mipmapLevel: 0, withBytes: &textureData, bytesPerRow:  internalImage!.width)
 
 */
public class PictureInput: ImageSource {
    public let targets = TargetContainer()
    var internalTexture:Texture?
    var hasProcessedImage:Bool = false
    var internalImage:CGImage?

    public init(image:CGImage, smoothlyScaleOutput:Bool = false, orientation:ImageOrientation = .portrait) {
        internalImage = image
    }
    
    #if canImport(UIKit)
  
 
  
  
    public convenience init(image:UIImage, smoothlyScaleOutput:Bool = false, orientation:ImageOrientation = .portrait) {
      
      func normalizeCGImage (cgImage: CGImage?)->CGImage? {
         guard let cgImage = cgImage , cgImage.bitsPerComponent != 8 else{
               return nil
           }

           let colorSpace = CGColorSpaceCreateDeviceRGB()

           var bitmapInfo: UInt32 =
               CGImageAlphaInfo.noneSkipFirst.rawValue |
               CGImageByteOrderInfo.order32Little.rawValue

           if #available(iOS 12.0, *) {
               bitmapInfo |= CGImagePixelFormatInfo.packed.rawValue
           }

           guard let context = CGContext(
               data: nil,
               width: cgImage.width,
               height: cgImage.height,
               bitsPerComponent: 8,
               bytesPerRow:  4 * cgImage.width,
               space: colorSpace,
               bitmapInfo: bitmapInfo
           ) else { return nil }

           context.interpolationQuality = .default

         let destinationRect = CGRect(x: 0, y: 0, width: cgImage.width, height: cgImage.height)

           context.clear(destinationRect)
           context.draw(cgImage, in: destinationRect)

           return context.makeImage()
       }
      
      self.init(image: normalizeCGImage(cgImage: image.cgImage) ?? image.cgImage!, smoothlyScaleOutput: smoothlyScaleOutput, orientation: orientation)
    }
    
    public convenience init(imageName:String, smoothlyScaleOutput:Bool = false, orientation:ImageOrientation = .portrait) {
        guard let image = UIImage(named:imageName) else { fatalError("No such image named: \(imageName) in your application bundle") }
        self.init(image:image, smoothlyScaleOutput:smoothlyScaleOutput, orientation:orientation)
    }
    #else
    public convenience init(image:NSImage, smoothlyScaleOutput:Bool = false, orientation:ImageOrientation = .portrait) {
        self.init(image:image.cgImage(forProposedRect:nil, context:nil, hints:nil)!, smoothlyScaleOutput:smoothlyScaleOutput, orientation:orientation)
    }
    
    public convenience init(imageName:String, smoothlyScaleOutput:Bool = false, orientation:ImageOrientation = .portrait) {
        let imageName = NSImage.Name(imageName)
        guard let image = NSImage(named:imageName) else { fatalError("No such image named: \(imageName) in your application bundle") }
        self.init(image:image.cgImage(forProposedRect:nil, context:nil, hints:nil)!, smoothlyScaleOutput:smoothlyScaleOutput, orientation:orientation)
    }
    #endif
    
    public func processImage(synchronously:Bool = false) -> String?{
        if let texture = internalTexture {
            if synchronously {
                self.updateTargetsWithTexture(texture)
                self.hasProcessedImage = true
            } else {
                DispatchQueue.global().async{
                    self.updateTargetsWithTexture(texture)
                    self.hasProcessedImage = true
                }
            }
        } else {
            let textureLoader = MTKTextureLoader(device: sharedMetalRenderingDevice.device)
            if synchronously {
                do {
                    let imageTexture = try textureLoader.newTexture(cgImage:internalImage!, options: [MTKTextureLoader.Option.SRGB : false])// modified image
                    internalImage = nil
                    self.internalTexture = Texture(orientation: .portrait, texture: imageTexture)
                    self.updateTargetsWithTexture(self.internalTexture!)//normal photo
                    self.hasProcessedImage = true
                } catch {
                  return "Failed loading image texture \(error)"//error genereteg hena
                }
            } else {
                textureLoader.newTexture(cgImage: internalImage!, options: [MTKTextureLoader.Option.SRGB : false], completionHandler: { (possibleTexture, error) in
                    guard (error == nil) else { print("Error in loading texture: \(error!)")
                      return
                  }
                    guard let texture = possibleTexture else { fatalError("Nil texture received") }
                    self.internalImage = nil
                    self.internalTexture = Texture(orientation: .portrait, texture: texture)
                    DispatchQueue.global().async{
                        self.updateTargetsWithTexture(self.internalTexture!)
                        self.hasProcessedImage = true
                    }
                })
            }
        }
      return nil
    }
    
    public func transmitPreviousImage(to target:ImageConsumer, atIndex:UInt) {
        if hasProcessedImage {
            target.newTextureAvailable(self.internalTexture!, fromSourceIndex:atIndex)
        }
    }
}
