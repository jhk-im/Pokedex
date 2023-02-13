//
//  Show.swift
//  Pokedex
//
//  Created by HUN on 2023/02/13.
//

import SwiftUI

// ViewModifier = 뷰에 존재하는 여러가지 옵션들을 하나로 묶어 공통으로 사용할 수 있도록 함
// 특정 View를 Bool 값으로 Hidden 처리하기 위함
struct Show: ViewModifier {
    let isVisible: Bool
    
    @ViewBuilder
    func body(content: Content) -> some View {
        if isVisible {
            content
        } else {
            content.hidden()
        }
    }
}

extension View {
    func show(isVisible: Bool) -> some View {
        ModifiedContent(content: self, modifier: Show(isVisible: isVisible))
    }
}

