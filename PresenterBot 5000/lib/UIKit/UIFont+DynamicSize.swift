//
//  UIFont+DynamicSize.swift
//  PresenterBot 5000
//
//  Created by Reilly Forshaw on 2018-02-07.
//  Copyright © 2018 Reilly Forshaw. All rights reserved.
//

import Foundation
import UIKit

enum UIFontDynamicSizingMode {
  case fixedWidth
  case fixedHeight
}

extension UIFont {
  static func systemFontOfMaxSize(forString string: NSString, boundedBy boundingSize: CGSize, mode: UIFontDynamicSizingMode, maxFontSize: CGFloat) -> UIFont {
    var fontSize = maxFontSize

    let size: CGSize
    switch mode {
    case .fixedWidth:
      size = CGSize(width: boundingSize.width, height: CGFloat.infinity)
    case .fixedHeight:
      size = CGSize(width: CGFloat.infinity, height: boundingSize.height)
    }

    func height(forFontSize fontSize: CGFloat) -> CGFloat {
      return string.boundingRect(with: size, options: [.usesLineFragmentOrigin], attributes: [.font : UIFont.systemFont(ofSize: fontSize)], context: nil).height
    }

    // O(n). Sue me.
    while height(forFontSize: fontSize) > boundingSize.height {
      fontSize -= 1
    }

    return .systemFont(ofSize: fontSize)
  }
}
