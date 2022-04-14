//
//  LocalImages.swift
//  TreasureExample
//
//  Created by Tengqi Zhan on 2021-09-27.
//

import Treasure
import UIKit

enum LocalImages: String, CaseIterable {
  case logo

  var toDarkThemeImage: UIImage {
    UIImage(named: rawValue) ?? .init()
  }

  var toLightThemeImage: UIImage {
    UIImage(named: rawValue) ?? .init()
  }

  static var toImages: ThemeComponent<UIImage> {
    var result: [String: [SystemThemeType: UIImage]] = [:]
    for type in LocalImages.allCases {
      result[type.rawValue] = [
        .dark: type.toDarkThemeImage,
        .light: type.toLightThemeImage
      ]
    }
    return .init(values: result)
  }
}
