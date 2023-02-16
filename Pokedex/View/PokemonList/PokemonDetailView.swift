//
//  PokemonDetailView.swift
//  Pokedex
//
//  Created by HUN on 2023/02/16.
//

import SwiftUI

struct PokemonDetailView: View {
    @Binding var isNavigationBarHidden: Bool
    @Binding var isShowingDetail: Bool
    @Binding var selectedResult: Results?
    let animation: Namespace.ID
    var body: some View {
        VStack(alignment: .center) {
            
            HStack{
                Spacer()
            }
            .frame(height: 100)
            .background(.blue)
            
            if let item = selectedResult {
                HStack {
                    Spacer()
                    PokemonListItem(name: item.name ?? "", imageUrl: item.getImageUrl(), isList: false)
                        .matchedGeometryEffect(id: item.name, in: animation, isSource: true)
                        .onTapGesture {
                            isNavigationBarHidden = false
                            isShowingDetail = false
                            selectedResult = nil
                        }
                    Spacer()
                }
            }
            Spacer()
        }
        .background(Color.white)
        .ignoresSafeArea()
    }
}

//struct PokemonDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        PokemonDetailView(
//            isNavigationBarHidden: .constant(true),
//            isShowingDetail: .constant(true),
//            selectedResult: <#T##Binding<Results?>#>,
//            animation: <#T##Namespace.ID#>
//        )
//    }
//}
