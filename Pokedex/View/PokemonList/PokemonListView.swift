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
    
    @State private var isNavigationBarVisible = false
    @State private var isShowingDetail = false
    @State private var selectedResult: Results? = nil
    
    @State private var scrollViewHeight:CGFloat = 0.0
    @State private var gridViewHeight:CGFloat = 0.0
    
    @Namespace private var animation
    
    var columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 16), count: 2)
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack{
                        Spacer()
                        Text("Pokedex")
                            .font(.system(size: 24, weight: .bold))
                        Spacer()
                    }
                    .frame(height: 60)
                    
                    
                    ScrollView {
                        GeometryReader { proxy -> Text in
                            //print("scrollViewHeight1 -> \(proxy.frame(in: .global).minY)")
//                            print("scrollViewHeight2 -> \(scrollViewHeight)")
                            
                            isNavigationBarVisible = proxy.frame(in: .global).minY < 125.0
                            
                            if !viewModel.isLoading &&  proxy.frame(in: .global).minY < scrollViewHeight {
                                scrollViewHeight += gridViewHeight
    //                            print("scrollViewHeight3 -> \(proxy.frame(in: .global).minY)")
    //                            print("scrollViewHeight4 -> \(scrollViewHeight)")
                                DispatchQueue.main.async {
                                    viewModel.getPokemonList(isFirst: false)
                                    
                                }
                            }
                            return Text("")
                        }
                        LazyVGrid(columns: columns, spacing: 16, content: {
                            ForEach(viewModel.results, id: \.name) { result in
                                PokemonListItem(name: result.name ?? "", imageUrl: result.getImageUrl()) { color in
                                    
                                }
                                    .matchedGeometryEffect(id: result.name, in: animation, isSource: true)
                                    .onTapGesture {
                                        isShowingDetail = true
                                        selectedResult = result
                                    }
                                    .background(
                                        GeometryReader { proxy in
                                            Color.clear.onAppear {
                                                if gridViewHeight == 0 {
                                                    gridViewHeight = -proxy.frame(in: .global).height * 10
                                                    //print(" scrollViewHeight!!!-> \(gridViewHeight)")
                                                }
                                            }
                                        }
                                    )
                            }
                        })
                        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                    }
                    .background(
                        GeometryReader { proxy in
                            Color.clear.onAppear {
                                self.scrollViewHeight = -proxy.frame(in: .global).size.height
                                //print("scrollViewHeight6 -> \(scrollViewHeight)")
                            }
                        }
                    )
                }
                
                ActivityIndicatorView(isVisible: $viewModel.isLoading, type: .default())
                    .frame(width: 50.0, height: 50.0)
                    .foregroundColor(.red)
                
                if selectedResult != nil {
                    PokemonDetailView(
                        isShowingDetail: $isShowingDetail,
                        selectedResult: $selectedResult,
                        animation: animation
                    )
                }
            }
            .animation(.easeIn(duration: 0.3), value: isShowingDetail)
        }
    }
}

struct PokemonListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = PokemonListViewModel()
        PokemonListView(viewModel: viewModel)
    }
}
