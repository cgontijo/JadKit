//
//  Color.swift
//  JadKit
//
//  Created by Jad Osseiran on 5/8/16.
//  Copyright © 2016 Jad Osseiran. All rights reserved.
//

import UIKit

public extension UIColor {
  // TODO: Make this more flexible.
  public convenience init?(hexString: String, alpha: CGFloat? = 1.0) {
    guard hexString.hasPrefix("#") && hexString.characters.count == 7 else {
      return nil
    }

    func intFromHexString(string: String) -> UInt32 {
      var hextInt: UInt32 = 0
      let scanner: NSScanner = NSScanner(string: hexString)
      scanner.charactersToBeSkipped = NSCharacterSet(charactersInString: "#")
      scanner.scanHexInt(&hextInt)
      return hextInt
    }

    // Convert hex string to an integer
    let hexInt = Int(intFromHexString(hexString))
    let red = CGFloat((hexInt & 0xff0000) >> 16) / 255.0
    let green = CGFloat((hexInt & 0xff00) >> 8) / 255.0
    let blue = CGFloat((hexInt & 0xff) >> 0) / 255.0
    let alpha = alpha ?? 1.0

    // Create color object, specifying alpha as well
    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }
}
