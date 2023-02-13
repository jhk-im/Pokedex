//
//  PokemonList.swift
//  Pokedex
//
//  Created by HUN on 2023/02/07.
//

import SwiftUI
import ActivityIndicatorView

struct PokemonListView: View {
    
    @ObservedObject var viewModel = PokemonListViewModel()
    
    @State private var isShowingDetail = false
    @State private var selectedResult: Results? = nil
    
    @Namespace var animation
    @State private var isSetList = false
    
    var body: some View {
        NavigationView {
            ZStack {
                
                List(viewModel.results, id: \.name) { result in
                    PokemonListItem(name: result.name ?? "", imageUrl: result.getImageUrl())
                        .onAppear {
                            if viewModel.results.last?.name == result.name {
                                print("getPokemonList() -> last item")
                                viewModel.getPokemonList(isFirst: false)
                            }
                        }
                        .matchedGeometryEffect(id: result.name, in: animation)
                        .onTapGesture {
                            selectedResult = result
                            isShowingDetail = true
                        }
                }
                .listStyle(PlainListStyle())
                
                
                ActivityIndicatorView(isVisible: $viewModel.isLoading, type: .default())
                    .frame(width: 50.0, height: 50.0)
                    .foregroundColor(.red)
                
                if selectedResult != nil && isShowingDetail {
                    DetailView(
                        isShowingDetail: $isShowingDetail,
                        selectedResult: $selectedResult,
                        animation: animation
                    )
                }
            }
        }
        .navigationViewStyle(.stack)
        .animation(.easeIn, value: isShowingDetail)
    }
}

struct DetailView: View {
  @Binding var isShowingDetail: Bool
  @Binding var selectedResult: Results?
  let animation: Namespace.ID
  var body: some View {
      VStack {
          if let item = selectedResult, isShowingDetail {
              PokemonListItem(name: item.name ?? "", imageUrl: item.getImageUrl())
                  .matchedGeometryEffect(id: item.name, in: animation)
                  .onTapGesture {
                      selectedResult = nil
                      isShowingDetail = false
                  }
          }
          Spacer()
      }
      .background(Color.white)
      .navigationViewStyle(.stack)
  }
}

struct PokemonListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = PokemonListViewModel()
        PokemonListView(viewModel: viewModel)
    }
}
