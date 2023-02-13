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
    @State private var selectedResult: Results?
    
    @Namespace var animation
    
    var body: some View {
        NavigationView {
            ZStack {
                
                if let selectedResult = selectedResult, isShowingDetail {
                    DetailView(
                        isShowingDetail: $isShowingDetail,
                        item: selectedResult,
                        animation: animation
                    )
                } else {
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
                }
            }
        }
        .navigationViewStyle(.stack)
        .animation(.easeIn, value: isShowingDetail)
    }
}

struct DetailView: View {
  @Binding var isShowingDetail: Bool
  let item: Results
  let animation: Namespace.ID
  var body: some View {
      VStack {
          AsyncImage(url: URL(string: item.getImageUrl()), scale: 50) { phase in
              if let image = phase.image {
                  image
                      .resizable()
                      .scaledToFit()
              } else if phase.error != nil {
                  Color.gray // Indicates an error.
              } else {
                  // Acts as a placeholder.
              }
          }
          .frame(width: 100, height: 100)
          .matchedGeometryEffect(id: item.name, in: animation)
          .onTapGesture {
                isShowingDetail = false
          }
      }
      .padding(.horizontal)
      .navigationBarTitleDisplayMode(.inline)
      .navigationViewStyle(.stack)
  }
}

struct PokemonListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = PokemonListViewModel()
        PokemonListView(viewModel: viewModel)
    }
}
