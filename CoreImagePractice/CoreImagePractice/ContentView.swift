//
//  ContentView.swift
//  CoreImagePractice
//
//  Created by Manish on 05/07/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct ContentView: View {
    // MARK :-
    let ciContext = CIContext()
    var originalImage = UIImage(named: "Lake")!
    
    @State private var image: Image?
    
    var body: some View {
        VStack {
            image?
            .resizable()
            .scaledToFit()
                .background(Color.gray)
            
            Button(action: {
                self.applyFilter()
            }, label: {
                Text("Apply Filter")
            })
        }
        .onAppear {
            self.resetToOriginalImage()
        }
    }
    
    func resetToOriginalImage() {
        image = Image(uiImage: originalImage)
    }
    
}

// MARK :- Effects
extension ContentView {
    func applyFilter () {
        // effect
        //let outputImage = sepiaFilter(CIImage(image: originalImage)!, intensity: 0.9)!
        
        // scale
        let aspectRatio = Double(originalImage.size.width) / Double(originalImage.size.height)
        let outputImage = scaleFilter(CIImage(image: originalImage)!, aspectRatio: aspectRatio, scale: -1.5)
        
        if let cgimg = ciContext.createCGImage(outputImage, from: outputImage.extent) {
            // convert that to a UIImage
            let uiImage = UIImage(cgImage: cgimg)

            // and convert that to a SwiftUI image
            image = Image(uiImage: uiImage)
        }
    }
    
    
    
    func sepiaFilter(_ input: CIImage, intensity: Double) -> CIImage? {
        let sepiaFilter = CIFilter.sepiaTone()
        sepiaFilter.setValue(input, forKey: kCIInputImageKey)
        sepiaFilter.setValue(intensity, forKey: kCIInputIntensityKey)
        return sepiaFilter.outputImage
    }
    
    func scaleFilter(_ input:CIImage, aspectRatio : Double, scale : Double) -> CIImage {
        let scaleFilter = CIFilter.lanczosScaleTransform()
        scaleFilter.setValue(input, forKey: kCIInputImageKey)
        scaleFilter.setValue(scale, forKey: kCIInputScaleKey)
        scaleFilter.setValue(aspectRatio, forKey: kCIInputAspectRatioKey)
        return scaleFilter.outputImage!
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
