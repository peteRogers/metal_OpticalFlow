//
//  CIKL_Sky.swift
//  Filterpedia
//
//  Created by Simon Gladman on 28/04/2016.
//  Copyright © 2016 Simon Gladman. All rights reserved.
//

import CoreImage

class SimpleSky: CIFilter
{
    var inputSunDiameter: CGFloat = 1
    var inputAlbedo: CGFloat = 0
    var inputSunAzimuth: CGFloat = 100
    var inputSunAlitude: CGFloat = 100
    var inputSkyDarkness: CGFloat = 50
    var inputScattering: CGFloat = 10.0
    var inputWidth: CGFloat = 3000
    var inputHeight: CGFloat = 2000
    
    override var attributes: [String : Any]
    {
        return [
            kCIAttributeFilterDisplayName: "Simple Sky",
            
            "inputSunDiameter": [kCIAttributeIdentity: 0,
                kCIAttributeClass: "NSNumber",
                kCIAttributeDefault: 100,
                kCIAttributeDisplayName: "Sun Diameter",
                kCIAttributeMin: 0,
                kCIAttributeSliderMin: 0,
                kCIAttributeSliderMax: 1,
                kCIAttributeType: kCIAttributeTypeScalar],
            
            "inputAlbedo": [kCIAttributeIdentity: 0,
                kCIAttributeClass: "NSNumber",
                kCIAttributeDefault: 0.2,
                kCIAttributeDisplayName: "Albedo",
                kCIAttributeMin: 0,
                kCIAttributeSliderMin: 0,
                kCIAttributeSliderMax: 1,
                kCIAttributeType: kCIAttributeTypeScalar],
            
            "inputSunAzimuth": [kCIAttributeIdentity: 0,
                kCIAttributeClass: "NSNumber",
                kCIAttributeDefault: 0,
                kCIAttributeDisplayName: "Sun Azimuth",
                kCIAttributeMin: -1,
                kCIAttributeSliderMin: -1,
                kCIAttributeSliderMax: 1,
                kCIAttributeType: kCIAttributeTypeScalar],
            
            "inputSunAlitude": [kCIAttributeIdentity: 0,
                kCIAttributeClass: "NSNumber",
                kCIAttributeDefault: 1,
                kCIAttributeDisplayName: "Sun Alitude",
                kCIAttributeMin: 0,
                kCIAttributeSliderMin: 0,
                kCIAttributeSliderMax: 10,
                kCIAttributeType: kCIAttributeTypeScalar],
            
            "inputSkyDarkness": [kCIAttributeIdentity: 0,
                kCIAttributeClass: "NSNumber",
                kCIAttributeDefault: 1.25,
                kCIAttributeDisplayName: "Sky Darkness",
                kCIAttributeMin: 0.1,
                kCIAttributeSliderMin: 0.1,
                kCIAttributeSliderMax: 2,
                kCIAttributeType: kCIAttributeTypeScalar],
            
            "inputScattering": [kCIAttributeIdentity: 0,
                kCIAttributeClass: "NSNumber",
                kCIAttributeDefault: 10,
                kCIAttributeDisplayName: "Scattering",
                kCIAttributeMin: 1,
                kCIAttributeSliderMin: 1,
                kCIAttributeSliderMax: 20,
                kCIAttributeType: kCIAttributeTypeScalar],
            
            "inputWidth": [kCIAttributeIdentity: 0,
                kCIAttributeClass: "NSNumber",
                kCIAttributeDefault: 640,
                kCIAttributeDisplayName: "Width",
                kCIAttributeMin: 1,
                kCIAttributeSliderMin: 1,
                kCIAttributeSliderMax: 1280,
                kCIAttributeType: kCIAttributeTypeScalar],
            
            "inputHeight": [kCIAttributeIdentity: 0,
                kCIAttributeClass: "NSNumber",
                kCIAttributeDefault: 640,
                kCIAttributeDisplayName: "Height",
                kCIAttributeMin: 1,
                kCIAttributeSliderMin: 1,
                kCIAttributeSliderMax: 1280,
                kCIAttributeType: kCIAttributeTypeScalar]
        ]
    }
    
    let skyKernel: CIColorKernel =
    {
        let shaderPath = Bundle.main.path(forResource: "cikl_sky", ofType: "cikernel")
        
        guard let path = shaderPath,
              let code = try? String(contentsOfFile: path),
              let kernel = CIColorKernel(source: code) else
        {
            fatalError("Unable to build Sky shader")
        }
        
        return kernel
    }()
    
    override var outputImage: CIImage?
    {
        let extent = CGRect(x: 0, y: 0, width: inputWidth, height: inputHeight)
        
        let arguments = [3000, 3000, 0.5, inputAlbedo, inputSunAzimuth, inputSunAlitude, inputSkyDarkness, inputScattering]
        
        let final = skyKernel.apply(extent: extent, arguments: arguments)?.cropped(to: extent)
        
        return final
    }
    
}
