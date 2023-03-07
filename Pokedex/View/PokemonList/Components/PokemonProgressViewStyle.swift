//
//  PokemonProgressViewStyle.swift
//  Pokedex
//
//  Created by HUN on 2023/03/06.
//


import SwiftUI

struct PokemonProgressViewStyle<Stroke: ShapeStyle, Background: ShapeStyle>: ProgressViewStyle {
    var stroke: Stroke
    var fill: Background
    var caption: String = ""
    var value: Int = 0
    var cornerRadius: CGFloat = 10
    var height: CGFloat = 20
    var animation: Animation = .easeInOut
    
    func makeBody(configuration: Configuration) -> some View {
        let fractionCompleted = configuration.fractionCompleted ?? 0
        
        return HStack {
            ZStack(alignment: .topLeading) {
                GeometryReader { geo in
                    Rectangle()
                        .fill(fill)
                        .frame(maxWidth: geo.size.width * CGFloat(fractionCompleted))
                    
                    if !caption.isEmpty {
                        Text(caption)
                            .font(.caption)
                            .foregroundColor(Color("PastelWhite"))
                            .padding(EdgeInsets(top: 3, leading: 10, bottom: 0, trailing: 0))
                    }
                    
                    Text("\(value)")
                        .font(.caption)
                        .foregroundColor(Color("PastelWhite"))
                        .padding(EdgeInsets(top: 3, leading: 0, bottom: 0, trailing: 10))
                        .frame(maxWidth: geo.size.width * CGFloat(fractionCompleted), alignment: .trailing)
                }
            }
            .frame(height: height)
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(stroke, lineWidth: 2)
            )
        }
    }
}
