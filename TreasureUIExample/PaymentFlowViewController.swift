//
//  PaymentFlowViewController.swift
//  TreasureExample
//
//  Created by Tengqi Zhan on 2021-09-07.
//

import Foundation
import SnapKit
import Treasure
import UIKit

final class PaymentFlowViewController: UIViewController {
  private let clientToken = "mck_test_RQVtgnTuOeYBkHiBv8WP6XhmWjDuWEv0Jxu00BrT29KD2VTuBnmrfiHs0g2KkScozHiAoWsh03TA_W2hosY6uQ"

  private var currentViewController: UIViewController?
  private let treasureHost: TreasureHost
  
  init() {
    treasureHost = TreasureHost(configuration: .init(environment: .sandbox(clientToken: clientToken)))
    super.init(nibName: nil, bundle: nil)

    TreasureDependency.shared.imageLoader = DefaultTreasureImageLoader()
    TreasureDependency.shared.theme = Theme(
      styles: StylesPlate.toStyles,
      fonts: FontPlate.toFonts,
      colors: ColorPlate.toColors,
      images: LocalImages.toImages
    )

    treasureHost.hostActionHandler = self
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    loadFromLocal()
  }

  private func loadFromCheckoutUI() {
    treasureHost.loadFromCheckoutUI { [weak self] vc in
      self?.replaceScreen(viewController: vc)
    }
  }

  private func loadFromLocal() {
    let vc = treasureHost.loadFromLocal(filePath: FileResources.blocksUI.rawValue)
    replaceScreen(viewController: vc)
  }
  
  private func replaceScreen(viewController: UIViewController) {
    viewController.willMove(toParent: self)
    addChild(viewController)
    view.addSubview(viewController.view)
    viewController.view.snp.remakeConstraints { make in
      make.edges.equalToSuperview()
    }
    currentViewController?.willMove(toParent: nil)
    currentViewController?.view.removeFromSuperview()
    currentViewController?.removeFromParent()
    viewController.didMove(toParent: self)
    currentViewController = viewController
  }
}

extension PaymentFlowViewController {
  
  private func setupUI() {}
}

extension PaymentFlowViewController: TreasureHostActionHandler {
  
  func handle(externalAction: ExternalAction) {
    let vc = UIViewController()
    vc.view.backgroundColor = .red
    treasureHost.pushViewController(vc: vc)
  }
}
