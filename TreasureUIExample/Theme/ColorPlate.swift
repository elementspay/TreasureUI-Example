//
//  ColorPlate.swift
//  TreasureExample
//
//  Created by Tengqi Zhan on 2021-09-27.
//

import Treasure
import UIKit

enum ColorPlate: String, CaseIterable {
  case primary
  case secondary

  var toDarkThemeColor: UIColor {
    switch self {
    case .primary:
      return .white
    case .secondary:
      return .white
    }
  }

  var toLightThemeColor: UIColor {
    switch self {
    case .primary:
      return .darkGray
    case .secondary:
      return .red
    }
  }

  static var toColors: ThemeComponent<UIColor> {
    var result: [String: [SystemThemeType: UIColor]] = [:]
    for type in ColorPlate.allCases {
      result[type.rawValue] = [
        .dark: type.toDarkThemeColor,
        .light: type.toLightThemeColor
      ]
    }
    return .init(values: result)
  }
}
