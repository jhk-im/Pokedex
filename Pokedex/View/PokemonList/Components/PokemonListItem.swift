//
//  PokemonListItem.swift
//  Pokedex
//
//  Created by HUN on 2023/02/07.
//

import SwiftUI
import Palette

struct PokemonListItem: View {
    var name: String
    var imageUrl: String
    var isDetail = false
    @State var backgroundColor: Color = .clear
    @State var width: CGFloat = 120
    @State var height: CGFloat = 120
    var handler: (Color) -> Void
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                AsyncImage(url: URL(string: imageUrl), scale: 50) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFit()
                            .onAppear {
                                setAverageColor(image: image)
                            }
                    } else if phase.error != nil {
                        Color.gray // Indicates an error.
                    } else {
                        // Acts as a placeholder.
                    }
                }
                .frame(width: width, height: height)
                Spacer()
            }
            Spacer()
        }
        .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
        .background(backgroundColor)
        .cornerRadius(12)
    }
    
    private func setAverageColor(image: Image) {
        let uiColor = image.asUIImage().averageColor ?? .clear
        backgroundColor = Color(uiColor)
        handler(backgroundColor)
    }
}

extension View {
    // This function changes our View to UIView, then calls another function
    // to convert the newly-made UIView to a UIImage.
    public func asUIImage() -> UIImage {
        let controller = UIHostingController(rootView: self)
        
        controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
        UIApplication.shared.windows.first!.rootViewController?.view.addSubview(controller.view)
        
        let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.sizeToFit()
        
        // here is the call to the function that converts UIView to UIImage: `.asUIImage()`
        let image = controller.view.asUIImage()
        controller.view.removeFromSuperview()
        return image
    }
}

extension UIView {
// This is the function to convert UIView to UIImage
    public func asUIImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

extension UIImage {
    var averageColor: UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)
        
        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        
        guard let outputImage = filter.outputImage else { return nil }
        
        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull!])
        
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0 , y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        
        print("bitmap -> \(bitmap)")
        
        let target: UInt8 = 10
        
        if bitmap[0] <= bitmap[1] && bitmap[0] <= bitmap[2] {
            red = CGFloat(bitmap[0] - target)
            green = bitmap[0] == bitmap[1] ? CGFloat(bitmap[1] - target) : CGFloat(bitmap[1])
            blue = bitmap[0] == bitmap[2] ? CGFloat(bitmap[2] - target) : CGFloat(bitmap[2])
        } else if bitmap[1] <= bitmap[0] && bitmap[1] <= bitmap[2] {
            red = bitmap[1] == bitmap[0] ? CGFloat(bitmap[0] - target) : CGFloat(bitmap[0])
            green = CGFloat(bitmap[1] - target)
            blue = bitmap[1] == bitmap[2] ? CGFloat(bitmap[2] - target) : CGFloat(bitmap[2])
        } else {
            red = bitmap[2] == bitmap[0] ? CGFloat(bitmap[0] - target) : CGFloat(bitmap[0])
            green = bitmap[2] == bitmap[1] ? CGFloat(bitmap[1] - target) : CGFloat(bitmap[1])
            blue = CGFloat(bitmap[2] - target)
        }
        
        return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }
}

struct PokemonListItem_Previews: PreviewProvider {
    static var previews: some View {
        PokemonListItem(name: "bulbasaur", imageUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png") { color in
            
        }
    }
}
