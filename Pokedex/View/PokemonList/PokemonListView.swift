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
    @State private var scrollViewHeight:CGFloat = 0.0
    
    @Namespace private var animation
    
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    GeometryReader { proxy -> Text in
                        if !viewModel.isLoading &&  proxy.frame(in: .global).minY < scrollViewHeight {
                            scrollViewHeight += scrollViewHeight
//                            print("scrollViewHeight2 -> \(proxy.frame(in: .global).minY)")
//                            print("scrollViewHeight3 -> \(scrollViewHeight)")
                            DispatchQueue.main.async {
                                viewModel.getPokemonList(isFirst: false)
                                
                            }
                        }
                        return Text("")
                    }
                    LazyVGrid(columns: columns, content: {
                        ForEach(viewModel.results, id: \.name) { result in
                            PokemonListItem(name: result.name ?? "", imageUrl: result.getImageUrl())
                                .matchedGeometryEffect(id: result.name, in: animation, isSource: true)
                                .onTapGesture {
                                    isShowingDetail = true
                                    selectedResult = result
                                }
                        }
                    })
                }
                .background(
                    GeometryReader { proxy in
                        Color.clear.onAppear {
                            self.scrollViewHeight = -proxy.frame(in: .global).size.height
//                            print("scrollViewHeight1 -> \(scrollViewHeight)")
                        }
                    }
                )
                
                ActivityIndicatorView(isVisible: $viewModel.isLoading, type: .default())
                    .frame(width: 50.0, height: 50.0)
                    .foregroundColor(.red)
                
                if selectedResult != nil {
                    DetailView(
                        isShowingDetail: $isShowingDetail,
                        selectedResult: $selectedResult,
                        animation: animation
                    )
                    
                }
            }
            //.navigationTitle("Pokedex")
            .animation(.easeIn(duration: 0.2), value: isShowingDetail)
        }
    }
}

struct DetailView: View {
    @Binding var isShowingDetail: Bool
    @Binding var selectedResult: Results?
    let animation: Namespace.ID
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            if let item = selectedResult {
                HStack {
                    Spacer()
                    PokemonListItem(name: item.name ?? "", imageUrl: item.getImageUrl(), isList: false)
                        .matchedGeometryEffect(id: item.name, in: animation, isSource: true)
                        .onTapGesture {
                            isShowingDetail = false
                            selectedResult = nil
                        }
                    Spacer()
                }
            }
            Spacer()
        }
        .background(Color.white)
    }
}

struct PokemonListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = PokemonListViewModel()
        PokemonListView(viewModel: viewModel)
    }
}
