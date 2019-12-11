import UIKit
import CoreImage
import PlaygroundSupport

func toVector(x: CGFloat, y: CGFloat) -> CIVector
{
    return CIVector(x: x/255, y: y/255)
}

// CIToneCurveフィルタをかける
func filtered(sourceImage: UIImage) -> UIImage
{
    let filter = CIFilter(name: "CIToneCurve")!
    let ciImage = CIImage(cgImage: sourceImage.cgImage!)
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
    
    filter.setDefaults()
    filter.setValue(ciImage, forKey: kCIInputImageKey)
    
    // フィルタをかけた画像を取得 (この段階で画像がおかしくなってる)
    let outputImage = filter.outputImage!
    
    // UIImageに変換して返す。
    let context = CIContext(options: nil)
    let cgImageRef = context.createCGImage(outputImage, from: outputImage.extent)!
    let result = UIImage(cgImage: cgImageRef)
    
    return result
}

// フィルタをかけたい画像
let inputImage = #imageLiteral(resourceName: "IMG_0003.JPG")

let rootDir = playgroundSharedDataDirectory
print("出力先ディレクトリはこちら")
print(rootDir)

try! FileManager.default.createDirectory(at: rootDir, withIntermediateDirectories: true, attributes: nil)

for i in 1...100 {
    autoreleasepool {
        let outputImage = filtered(sourceImage: inputImage)

        let url = rootDir.appendingPathComponent("output\(i).jpg")
        let data = outputImage.jpegData(compressionQuality: 1.0)!

        try? data.write(to: url)
    }
}
