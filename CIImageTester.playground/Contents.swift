import UIKit
import CoreImage
import PlaygroundSupport

func toVector(x: CGFloat, y: CGFloat) -> CIVector
{
    return CIVector(x: x/255, y: y/255)
}

func filtered(sourceImage: UIImage) -> UIImage
{
    let filter = CIFilter(name: "CIToneCurve")!
    filter.setDefaults()
    
    let ciImage = CIImage(cgImage: sourceImage.cgImage!)
    filter.setValue(ciImage, forKey: kCIInputImageKey)
    
    let vectors = [toVector(x: 0, y: 0),
                  toVector(x: 44, y: 65),
                  toVector(x: 95, y: 128),
                  toVector(x: 190, y: 214),
                  toVector(x: 255, y: 255)];
    var i = 0
    for vector in vectors {
        filter.setValue(vector, forKey: String(format: "inputPoint%d", i))
        i = i+1
    }

    let outputImage = filter.outputImage!
    
    let context = CIContext(options: nil)
    
    let cgImageRef = context.createCGImage(outputImage, from: outputImage.extent)!
    let result = UIImage(cgImage: cgImageRef)
    
    return result
}

// let sourceImage = #imageLiteral(resourceName: "IMG_0001.JPG") // 1024 sized
// let sourceImage = #imageLiteral(resourceName: "IMG_0002.JPG") // 2048 sized
 let sourceImage = #imageLiteral(resourceName: "IMG_0003.JPG") // 4288 sized
// let sourceImage = #imageLiteral(resourceName: "IMG_0004.JPG") // 4288 sized
// let sourceImage = #imageLiteral(resourceName: "IMG_0005.JPG") // 4288 sized
//let sourceImage = #imageLiteral(resourceName: "IMG_0002.JPG")

let rootDir = playgroundSharedDataDirectory
print("出力先ディレクトリはこちら")
print(rootDir)

for i in 1...100 {
    let destImage = filtered(sourceImage: sourceImage)

    let url = rootDir.appendingPathComponent("output\(i).jpg")
    let data = destImage.jpegData(compressionQuality: 1.0)!

    if(!FileManager.default.fileExists(atPath: rootDir.absoluteString)) {
        do {
            try FileManager.default.createDirectory(at: rootDir, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    try? data.write(to: url, options: .atomic)
}

let url2 = rootDir.appendingPathComponent("default.jpg")
let data2 = sourceImage.jpegData(compressionQuality: 1.0)!

try? data2.write(to: url2)
