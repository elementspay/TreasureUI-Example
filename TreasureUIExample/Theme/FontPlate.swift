//
//  FontPlate.swift
//  TreasureExample
//
//  Created by Tengqi Zhan on 2021-09-27.
//

import Treasure
import UIKit

enum FontPlate: String, CaseIterable {
  case primary
  case secondary

  var toDarkThemeFont: UIFont {
    switch self {
    case .primary:
      return UIFont.systemFont(ofSize: 30)
    case .secondary:
      return UIFont.systemFont(ofSize: 20)
    }
  }

  var toLightThemeFont: UIFont {
    switch self {
    case .primary:
      return UIFont.systemFont(ofSize: 30)
    case .secondary:
      return UIFont.systemFont(ofSize: 20)
    }
  }

  static var toFonts: ThemeComponent<UIFont> {
    var result: [String: [SystemThemeType: UIFont]] = [:]
    for type in FontPlate.allCases {
      result[type.rawValue] = [
        .dark: type.toDarkThemeFont,
        .light: type.toLightThemeFont
      ]
    }
    return .init(values: result)
  }
}
