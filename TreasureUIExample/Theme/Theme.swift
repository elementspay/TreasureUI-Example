//
//  Theme.swift
//  TreasureExample
//
//  Created by Tengqi Zhan on 2021-09-27.
//

import Treasure
import UIKit

public struct Theme: ThemeRegistrable {
  public var styles: [String: ElementStyle]?
  public var fonts: ThemeComponent<UIFont>?
  public var colors: ThemeComponent<UIColor>?
  public var images: ThemeComponent<UIImage>?
}
