//
//  DefaultContextViewController.swift
//  YUCIHighPassSkinSmoothingDemo
//
//  Created by YuAo on 1/20/16.
//  Copyright © 2016 YuAo. All rights reserved.
//

import UIKit
import YUCIHighPassSkinSmoothing

class DefaultRenderContextViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var amountSlider: UISlider!
    
    let filter = YUCIHighPassSkinSmoothingFilter()

    var sourceImage: UIImage! {
        didSet {
            self.inputCIImage = CIImage(CGImage: self.sourceImage.CGImage!)
        }
    }
    var processedImage: UIImage?
    
    var inputCIImage: CIImage!
    
    @IBAction func chooseImageBarButtonItemTapped(sender: AnyObject) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.view.backgroundColor = UIColor.whiteColor()
        imagePickerController.delegate = self
        self.presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.sourceImage = image
        self.processImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sourceImage = UIImage(named: "SampleImage")!
        self.processImage()
    }
    
    @IBAction func amountSliderTouchUp(sender: AnyObject) {
        self.processImage()
    }
    
    func processImage() {
        self.filter.inputImage = self.inputCIImage
        self.filter.inputAmount = self.amountSlider.value
        let outputCIImage = filter.outputImage!
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()!
        let context = CIContext(options: [kCIContextWorkingColorSpace: colorSpace])
        let outputCGImage = context.createCGImage(outputCIImage, fromRect: outputCIImage.extent)
        let outputUIImage = UIImage(CGImage: outputCGImage, scale: self.sourceImage.scale, orientation: self.sourceImage.imageOrientation)
        
        self.processedImage = outputUIImage
        self.imageView.image = self.processedImage
    }
}
