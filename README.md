# TreasureUI-Example
Elements' flexible UI SDK.

## Requirements

The Elements iOS Flexible UI SDK a.k.a Treasure SDK requires Xcode 11 or later and is compatible with apps targeting **iOS 13** or above.

## Installation

Flexible UI SDK for iOS are available through CocoaPods.

### CocoaPods

Add `pod 'TreasureUI'` to your Podfile.
Run `pod install`.

## Configuration

### TreasureHost

`TreasureHost` class is the main interface that communicates between client application and flexible UI SDK. You can initialize `TreasureHost` in the following way.

```swift
import Treasure

let clientToken = "Your elements client token goes here..."
let env = TreasureEnvironment.sandbox(clientToken: clientToken) // Specify your client environment here.
let treasureHost = TreasureHost(configuration: .init(environment: env))
```

## Set up client side dependencies

Treasure provides interfaces to support passing client dependencies to itself. 

### Load Images
Treasure allows you to pass customized image downloader to the SDK and Treasure will use it to load images when needed.

See code below for an example on how to create a customized image loader using popular image loading libraries -> [SDWebImage](https://github.com/SDWebImage/SDWebImage) + [Lottie](https://github.com/airbnb/lottie-ios)

```swift
import Lottie
import SDWebImage
import Treasure
import UIKit

// Any customized image loader needs to implement TreasureImageLoadable interface.
public final class DefaultTreasureImageLoader: TreasureImageLoadable {

  public init() {}

  public func setImage(
    imageView: UIImageView,
    placeHolder: UIImage?,
    url: URL,
    completion: (() -> Void)?
  ) {
    imageView.sd_setImage(with: url, placeholderImage: placeHolder, completed: { image, _, _, _ in
      completion?()
    })
  }

  public func createAnimationView(
    url: URL,
    imageMode: UIView.ContentMode,
    completion: ((Error?) -> Void)?
  ) -> UIView {
    let lottieView = AnimationView(url: url, closure: { error in
      if let error = error {
        completion?(error)
        return
      }
      completion?(nil)
    })
    setupAnimationViewCommonProps(view: lottieView, imageMode: imageMode)
    return lottieView
  }

  public func createAnimationView(
    animationName: String,
    imageMode: UIView.ContentMode
  ) -> UIView {
    let lottieView = AnimationView(name: animationName)
    setupAnimationViewCommonProps(view: lottieView, imageMode: imageMode)
    return lottieView
  }

  public func playAnimationImage(view: UIView) {
    guard let lottieView = view as? AnimationView else { return }
    lottieView.play(completion: nil)
  }

  private func setupAnimationViewCommonProps(
    view: AnimationView,
    imageMode: UIView.ContentMode
  ) {
    view.contentMode = imageMode
    view.loopMode = .loop
    view.backgroundColor = .clear
    view.layer.masksToBounds = true
  }

  public func getImage(url: URL, completion: ((UIImage?) -> Void)?) {
    SDWebImageManager.shared.loadImage(with: url, options: [], progress: nil) { image, data, error, cachType, success, url in
      completion?(image)
    }
  }
}
```
Now you can pass the customized image loader to TreasureDependency in the following way.
```swift
TreasureDependency.shared.imageLoader = DefaultTreasureImageLoader()
```

### Theme + UI resources

Treasure supports dark/light themes at the moment. Client side colors/fonts/image are passed to TreasureDependency using **ThemeComponent** interface.
 
### Fonts

Treasure supports two different ways of constructing UIFont objects.
1. Constructing using font name and size
  ```json
  "text_font": {
    "name": "Poppins-Medium",
    "size": 18
  } 
  ```
2. Constructing using font string representation provided by client side application.
  ```json
  "text_font": "primary"
  ```
  Example code to provide multiple fonts to Treasure.
  ```swift
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
  ```
  So once Treasure SDK sees "primary" in fonts json block, it will be mapped to the primary font provided by the application.
### Colors

Similar to fonts, Treasure currently supports two different ways of initializing colors.
  1. Using hex string -> this example represents a black text color 
  ```json
  "text_color": "#000000" 
  ```
2. Using color string representation provided by the application.
  ```json
  "text_color": "primary"
  ```
  
  Example code to provide customized colors to Treasure.
  
  ```swift
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
  ```
  
### Images

Treasure provides initializing images from local assets folder and remote download URL. In order to use images from local assets folder you can do the following.
  
```swift
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
```

### Styles

Treasure also supports passing code level style configs as dependencies to the SDK.

```swift
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
```

### Constructing theme object from fonts, colors, images and styles.

In order for treasure to utilize provided resources, you need to construct an object that implements **ThemeRegistrable** interface and then pass that object to TreasureDependency.

```swift
import Treasure
import UIKit

public struct Theme: ThemeRegistrable {
  public var styles: [String: ElementStyle]?
  public var fonts: ThemeComponent<UIFont>?
  public var colors: ThemeComponent<UIColor>?
  public var images: ThemeComponent<UIImage>?
}

TreasureDependency.shared.theme = Theme(
  styles: StylesPlate.toStyles,
  fonts: FontPlate.toFonts,
  colors: ColorPlate.toColors,
  images: LocalImages.toImages
)
```

### External action handler

Treasure provided delegation to handle **ExternalAction**

```swift
final class PaymentFlowViewController: UIViewControlelr {
  
  init() {
    ...
    super.init(nibName: nil, bundle: nil)
    ...
    treasureHost.hostActionHandler = self
  }
}

extension PaymentFlowViewController: TreasureHostActionHandler {
  
  func handle(externalAction: ExternalAction) {
    let vc = UIViewController()
    vc.view.backgroundColor = .red
    treasureHost.pushViewController(vc: vc)
  }
}
```

## Starting Treasure UI

### Method 1: Load from Elements' server.

```swift
func loadFromCheckoutUI() {
  // This method will return a UIViewController on completion, you can either
  // replace the current screen with this view controller or push/present this
  // view controller.
  treasureHost.loadFromCheckoutUI { [weak self] vc in
    self?.replaceScreen(viewController: vc)
  }
}
```

### Method 2: Load from local file

```swift
func loadFromLocal() {
  let filePath = "/Users/elements/Desktop/Treasure/TreasureExample/TreasureExample/Resources/blocks_ui.json"
  let vc = treasureHost.loadFromLocal(filePath: filePath)
  replaceScreen(viewController: vc)
}
```

once you run your application on a simulator you will get the live update feature when you modify your local json file.

## Example App

Clone this repo and run `pod install` and then open `TreasureUIExample.xcworkspace`. The demo app demonstrated how to use Treasure SDK.
