//
//  font.swift
//  PocketMonarch
//
//  Created by 장유진 on 8/19/25.
//

import Foundation
import SwiftUI

extension Font {
    static func spoqa(_ weight: String = "Regular", size: CGFloat, relativeTo style: TextStyle? = nil) -> Font {
        let name = "Pretendard-\(weight)" // PostScript 이름 규칙에 맞게 수정
        if let style {
            return .custom(name, size: size, relativeTo: style)
        } else {
            return .custom(name, size: size)
        }
    }
}
