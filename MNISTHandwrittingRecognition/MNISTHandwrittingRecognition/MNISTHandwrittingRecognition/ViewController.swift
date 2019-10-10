//
//  ViewController.swift
//  MNISTHandwrittingRecognition
//
//  Created by Donghao Qiao on 2019-08-28.
//  Copyright © 2019 Jeremy Qiao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var drawView: DrawView!
    @IBOutlet weak var predictLabel: UILabel!
    @IBOutlet weak var calculateLabel: UILabel!
    
    let model = mnistCNN()
    let context = CIContext()
    var pixelBuffer: CVPixelBuffer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        predictLabel.isHidden = true
        
        // Set the pixel buffer dimensions - Remember it's grayscale
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
                     kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        CVPixelBufferCreate(kCFAllocatorDefault,
                            28,
                            28,
                            kCVPixelFormatType_OneComponent8,
                            attrs,
                            &pixelBuffer)
    }

//    @IBAction func tappedClear(_ sender: Any) {
//        drawView.lines = []
//        drawView.setNeedsDisplay()
//        predictLabel.isHidden = true
//    }
    
    func clear() {
        drawView.lines = []
        drawView.setNeedsDisplay()
        predictLabel.isHidden = true
    }
    
    @IBAction func tappedRecognize(_ sender: Any) {
        // Fancy Image conversions
        let viewContext = drawView.getViewContext()
        let cgImage = viewContext?.makeImage()
        let ciImage = CIImage(cgImage: cgImage!)
        context.render(ciImage, to: pixelBuffer!)
        // Predict
        let output = try? model.prediction(image: pixelBuffer!)
        // Output
        predictLabel.text = output?.classLabel
        predictLabel.isHidden = false
        
        calculateLabel.text?.append(contentsOf: output!.classLabel)
        
        clear()
    }
    
    @IBAction func deleteDigit(_ sender: Any) {
        calculateLabel.text = String(calculateLabel.text!.dropLast())
    }
    
    
    
}

