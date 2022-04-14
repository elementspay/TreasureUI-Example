//
//  DefaultTreasureImageLoader.swift
//  TreasureExample
//
//  Created by Tengqi Zhan on 2021-09-24.
//

import SDWebImage
import Lottie
import Treasure
import UIKit

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

