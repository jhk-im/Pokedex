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
            return Color("PastelRed")
        case "attack":
            return Color("PastelBlue")
        case "defense":
            return Color("PastelYellow")
        case "special-attack":
            return Color("PastelGreen")
        case "special-defense":
            return Color("PastelPurple")
        default:
            return Color("PastelPink")
        }
    }
    
    func setProgressCaption(name: String) -> String {
        switch name {
        case "hp":
            return "HP"
        case "attack":
            return "ATK"
        case "defense":
            return "DEF"
        case "special-attack":
            return "S-ATK"
        case "special-defense":
            return "S-DEF"
        default:
            return "SPD"
        }
    }
    
    func setTypesColor(name: String) -> Color {
        switch name {
        case "normal":
            return Color("TypeNormal")
        case "ground":
            return Color("TypeGround")
        case "water":
            return Color("TypeWater")
        case "grass":
            return Color("TypeGrass")
        case "electric":
            return Color("TypeElectric")
        case "rock":
            return Color("TypeRock")
        case "ice":
            return Color("TypeIce")
        case "flying":
            return Color("TypeFlying")
        case "poison":
            return Color("TypePoison")
        case "bug":
            return Color("TypeBug")
        case "steel":
            return Color("TypeSteel")
        case "fire":
            return Color("TypeFire")
        default:
            return Color("TypeDragon")
        }
    }
    
    // normal ,ground, water, grass, electric, rock, ice, flying, posion, bug, steel, fire, dragon
    
    var body: some View {
        ZStack {
            VStack {
                HStack{
                    Spacer()
                }
                .frame(height: 380)
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
                        selectedResult = nil
                        isShowingImage = false
                        isShowingDetail = false
                    }
                    .frame(width: imageSize, height: imageSize)
                    .padding(EdgeInsets(top: 80, leading: 0, bottom: 0, trailing: 0))
                    .onAppear {
                        viewModel.getPokemonDetail(id: Int(item.getIndexString()) ?? 1)
                        isShowingImage = true
                    }
                    .show(isVisible: isShowingImage)
                    
                    Text(item.name ?? "")
                        .foregroundColor(Color("PastelGray"))
                        .font(.system(size: 24, weight: .heavy))
                        .frame(maxHeight: 24)
                        .show(isVisible: isShowingProgress)
                    
                    LazyHStack(alignment: .center, spacing: 12, content: {
                        ForEach(viewModel.result?.types ?? [], id: \.type?.name) { types in
                            ZStack(alignment: .center) {
                                Text(types.type?.name ?? "")
                                    .foregroundColor(Color("PastelWhite"))
                                    .font(.caption)
                                    .padding(EdgeInsets(top: 4, leading: 16, bottom: 6, trailing: 16))
                                    .background(setTypesColor(name: types.type?.name ?? ""))
                                    .cornerRadius(15)
                            }
                        }
                    })
                    .frame(maxHeight: 32)
                    .show(isVisible: isShowingProgress)
                }
                
                LazyVStack(spacing: 12, content: {
                    ForEach(viewModel.result?.stats ?? [], id: \.stat?.name) { stats in
                        ProgressView(value: Float(stats.base_stat ?? 0) + 50, total: 250)
                            .progressViewStyle(PokemonProgressViewStyle(
                                stroke: setProgressColor(name: stats.stat?.name ?? ""),
                                fill: setProgressColor(name: stats.stat?.name ?? ""),
                                caption: setProgressCaption(name: stats.stat?.name ?? ""),
                                value: stats.base_stat ?? 0
                            ))
                    }
                })
                .padding(EdgeInsets(top: 60, leading: 20, bottom: 0, trailing: 20))
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        isShowingProgress = true
                    }
                }
                .show(isVisible: isShowingProgress)
                
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
