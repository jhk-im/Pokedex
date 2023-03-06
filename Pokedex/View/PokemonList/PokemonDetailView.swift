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
    @State var isShowingProgress = false
    let animation: Namespace.ID
    
    @ObservedObject var viewModel = PokemonDetailViewModel()
    
    @State private var gradient = LinearGradient(
        gradient: Gradient(colors: [.red, .green, .blue]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    func setProgressColor(name: String) -> Color {
        switch name {
        case "hp":
            return .red
        case "attack":
            return .orange
        case "defense":
            return .yellow
        case "special-attack":
            return .green
        case "special-defense":
            return .mint
        default:
            return .teal
        }
    }
    
    func setProgressCaption(name: String) -> String {
        switch name {
        case "hp":
            return "HP   "
        case "attack":
            return "ATK  "
        case "defense":
            return "DEF  "
        case "special-attack":
            return "S-ATK"
        case "special-defense":
            return "S-DEF"
        default:
            return "SPD  "
        }
    }
    
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
                        isShowingProgress = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            selectedResult = nil
                            isShowingImage = false
                            isShowingDetail = false
                        }
                    }
                    .frame(width: imageSize, height: imageSize)
                    .padding(EdgeInsets(top: 100, leading: 0, bottom: 0, trailing: 0))
                    .onAppear {
                        viewModel.getPokemonDetail(id: Int(item.getIndexString()) ?? 1)
                        isShowingImage = true
                    }
                    .show(isVisible: isShowingImage)
                    
                }
                
                LazyVStack(spacing: 12, content: {
                    ForEach(viewModel.result?.stats ?? [], id: \.stat?.name) { stats in
                        ProgressView(value: Float(stats.base_stat ?? 0), total: 300)
                            .progressViewStyle(PokemonProgressViewStyle(
                                stroke: setProgressColor(name: stats.stat?.name ?? ""),
                                fill: setProgressColor(name: stats.stat?.name ?? ""),
                                caption: setProgressCaption(name: stats.stat?.name ?? "")
                            ))
                    }
                })
                .padding(EdgeInsets(top: 80, leading: 20, bottom: 0, trailing: 20))
                .onAppear {
                    isShowingProgress = true
                }
                .show(isVisible: isShowingProgress)
                    
                
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
