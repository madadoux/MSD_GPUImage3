//
//  ViewController.swift
//  GPUImageExample
//
//  Created by Mohamed saeed on 9/28/20.
//  Copyright © 2020 Mohamed saeed. All rights reserved.
//

import UIKit
import MSD_GPUIMAGE3
//
//  PresetFilters.swift
//  MyZesty
//
//  Created by Mohamed saeed on 9/22/20.
//  Copyright © 2020 MyZesty, inc. All rights reserved.
//

protocol PresetFilter {
  func processImage(image:UIImage,intensity:CGFloat , extraParamters : [String:Any], result: @escaping  (UIImage)->Void)
}

// Unique






class SunsetPresetFilter : PresetFilter {
  var customSunsetShaderWrapper : CustomSunsetShaderWrapper!
  let pictureOutput = PictureOutput()
  
  func processImage(image: UIImage, intensity: CGFloat, extraParamters: [String : Any], result: @escaping (UIImage) -> Void) {
    pictureOutput.removeSourceAtIndex(0)
    let picture = PictureInput(image: image)
    customSunsetShaderWrapper = CustomSunsetShaderWrapper()
    
    customSunsetShaderWrapper.intensity =  Float(intensity)
    
    pictureOutput.encodedImageFormat = .png
    pictureOutput.imageAvailableCallback = result
    
    picture --> customSunsetShaderWrapper --> pictureOutput
    
    _ =  picture.processImage(synchronously: false)
    
  }
}


class ViewController : UIViewController {
    let sunsetFilter =  SunsetPresetFilter.init()

    override func viewDidLoad() {
        let sourceImage = UIImage(named: "watch")
        super.viewDidLoad()
        let imgView = UIImageView(frame: self.view.frame.divided(atDistance: 400, from: .minYEdge).slice)
        self.view.addSubview(imgView)
        imgView.image = sourceImage
        let imgView2 = UIImageView(frame: self.view.frame.divided(atDistance: 400, from: .minYEdge).remainder)
        self.view.addSubview(imgView2)
        imgView2.image = sourceImage
        imgView2.image = sourceImage

        sunsetFilter.processImage(image: UIImage(named: "watch")!, intensity: 0.9, extraParamters: [:], result: { (img) in
            DispatchQueue.main.async {
                
            
            imgView2.image = img
            }
        })
    }
}
