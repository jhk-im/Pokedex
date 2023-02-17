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
    let animation: Namespace.ID
    
    @ObservedObject var viewModel = PokemonDetailViewModel()
    
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
                    PokemonListItem(name: item.name ?? "", imageUrl: item.getImageUrl(), backgroundColor: .blue)
                        .matchedGeometryEffect(id: item.name, in: animation, isSource: true)
                        .onTapGesture {
                            isShowingDetail = false
                            selectedResult = nil
                        }
                    Spacer()
                }
                .onAppear {
                    viewModel.getPokemonDetail(id: Int(item.getIndexString()) ?? 1)
                }
            }
            
            Text(viewModel.result?.name ?? "")
                .font(.system(size: 24, weight: .bold))
            
            Text(String(viewModel.result?.height ?? 0))
                .font(.system(size: 24, weight: .bold))
            
            Text(String(viewModel.result?.weight ?? 0))
                .font(.system(size: 24, weight: .bold))
            
            Text(String(viewModel.result?.base_experience ?? 0))
                .font(.system(size: 24, weight: .bold))
            
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
