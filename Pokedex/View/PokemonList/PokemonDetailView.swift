//
//  PokemonDetailView.swift
//  Pokedex
//
//  Created by HUN on 2023/02/16.
//

import SwiftUI

struct PokemonDetailView: View {
    @Binding var isShowingDetail: Bool
    @Binding var selectedResult: Results?
    @State var backgroundColor: Color = .clear
    @State var imageSize:CGFloat = 200
    @State var isShowingImage = false
    let animation: Namespace.ID
    
    @ObservedObject var viewModel = PokemonDetailViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                HStack{
                    Spacer()
                }
                .frame(height: 360)
                .background(backgroundColor)
                .cornerRadius(24, corners: [.bottomLeft, .bottomRight])
                
                Spacer()
            }
            
            
            VStack(alignment: .center) {
                if let item = selectedResult {
                    PokemonListItem(name: item.name ?? "", imageUrl: item.getImageUrl(), isDetail: true, width: imageSize, height: imageSize) { color in
                        backgroundColor = color
                    }
                    .matchedGeometryEffect(id: item.name, in: animation, isSource: true)
                    .onTapGesture {
                        isShowingImage = false
                        isShowingDetail = false
                        selectedResult = nil
                    }
                    .frame(width: imageSize, height: imageSize)
                    .padding(EdgeInsets(top: 100, leading: 0, bottom: 0, trailing: 0))
                    .onAppear {
                        isShowingImage = true
                        viewModel.getPokemonDetail(id: Int(item.getIndexString()) ?? 1)
                    }
                    .show(isVisible: isShowingImage)
                    
                }
                
//                Text(viewModel.result?.name ?? "")
//                    .font(.system(size: 24, weight: .bold))
//
//                Text(String(viewModel.result?.height ?? 0))
//                    .font(.system(size: 24, weight: .bold))
//
//                Text(String(viewModel.result?.weight ?? 0))
//                    .font(.system(size: 24, weight: .bold))
//
//                Text(String(viewModel.result?.base_experience ?? 0))
//                    .font(.system(size: 24, weight: .bold))
                
                Spacer()
            }
            
        }
        .background(.white)
        .ignoresSafeArea()
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

//struct PokemonDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        PokemonDetailView(
//            PokemonDetailView(isShowingDetail: .constant(true),
//            selectedResult: .constant(nil),
//            animation: animation
//        )
//    }
//}
