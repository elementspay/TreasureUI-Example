//
//  StylesPlate.swift
//  TreasureExample
//
//  Created by Tengqi Zhan on 2021-09-27.
//

import Foundation
import Treasure
import UIKit

enum StylesPlate: String, CaseIterable {
  case primaryLabel = "primary_label"
  case navBarImage = "image_nav_bar"
  case navBarStyle = "nav_bar_style"
  case horizontalDivider = "horizontal_divider"

  var toStyle: ElementStyle {
    switch self {
    case .primaryLabel:
      return LabelElementStyle(
        id: rawValue,
        basicProps: .init(layoutMargins: .init(values: [12, 24, 12, 12])),
        textColor: .designSystem(ColorPlate.primary.rawValue),
        textFont: .designSystem(FontPlate.primary.rawValue),
        alignment: .leading,
        numberOfLines: 1
      )
    case .navBarImage:
      return ImageElementStyle(
        id: rawValue,
        basicProps: .init(layoutMargins: .init(values: [0, 0, 0, 0])),
        imageHeight: 20,
        imageWidth: 20
      )
    case .navBarStyle:
      return NavBarElementStyle(
        id: rawValue,
        basicProps: .init(
          backgroundColor: "#F2F2F2",
          layoutMargins: .init(values: [12, 20, 12, 12])
        ),
        titleStyleId: StylesPlate.primaryLabel.rawValue,
        imageStyleId: StylesPlate.navBarImage.rawValue,
        bottomLineColor: "#CCCCCC",
        bottomLineHeight: 1,
        bottomLineVisibility: .visibleByContentOffset
      )
    case .horizontalDivider:
      return DividerElementStyle(
        id: rawValue,
        height: 1,
        color: "#ff5647"
      )
    }
  }

  static var toStyles: [String: ElementStyle] {
    var result: [String: ElementStyle] = [:]
    for type in StylesPlate.allCases {
      result[type.rawValue] = type.toStyle
    }
    return result
  }
}
