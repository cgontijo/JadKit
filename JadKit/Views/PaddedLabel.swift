//
//  PaddedLabel.swift
//  JadKit
//
//  Created by Jad Osseiran on 11/14/15.
//  Copyright © 2016 Jad Osseiran. All rights reserved.
//
//  --------------------------------------------
//
//  IB friendly padded UILabel.
//
//  --------------------------------------------
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  * Redistributions of source code must retain the above copyright notice,
//  this list of conditions and the following disclaimer.
//
//  * Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
//  THE POSSIBILITY OF SUCH DAMAGE.
//

import UIKit

/**
 An Interface Builder integrated class that allows for padding between the text and the 
 frame of a UILabel.
 */
@IBDesignable
public class PaddedLabel: UILabel {

  /// IB exposed insets that control the padding for the label.
  /// - note: `width` translates to the `left` & `right` of the backing `UIEdgeInsets` object
  /// and `height` translates to the `top` and `bottom` of that same `UIEdgeInsets` object.
  @IBInspectable public var inset: CGSize = CGSize(width: 0.0, height: 0.0)

  /// The driving object that controls the padding for each edge.
  public var padding: UIEdgeInsets {
    var hasText: Bool = false

    if let text = text?.characters.count, text > 0 {
      hasText = true
    } else if let text = attributedText?.length, text > 0 {
      hasText = true
    }

    return hasText ? UIEdgeInsets(top: inset.height, left: inset.width,
                                  bottom: inset.height, right: inset.width) : UIEdgeInsets()
  }

  public override var intrinsicContentSize: CGSize {
    let superContentSize = super.intrinsicContentSize

    let width = superContentSize.width + padding.left + padding.right
    let heigth = superContentSize.height + padding.top + padding.bottom

    return CGSize(width: width, height: heigth)
  }

  public override func drawText(in rect: CGRect) {
    super.drawText(in: UIEdgeInsetsInsetRect(rect, padding))
  }

  // FIXME: This is still not perfect. Spend some time trying to understand it.
  public override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int)
    -> CGRect {
      var rect = super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)

      if let text = text {
        let estimatedWidth = rect.width - (2 * (padding.left + padding.right))
        let estimatedHeight = CGFloat.greatestFiniteMagnitude

        let boundingSize = CGSize(width: estimatedWidth, height: estimatedHeight)
        let calculatedFrame = text.boundingRect(with: boundingSize,
                                                        options: .usesLineFragmentOrigin,
                                                        attributes: [NSFontAttributeName : font],
                                                        context: nil)

        let calculatedWidth = ceil(calculatedFrame.width)
        let calculatedHeight = ceil(calculatedFrame.height)

        // let finalHeight = (calculatedHeight + padding.top + padding.bottom)
        rect.size = CGSize(width: calculatedWidth, height: calculatedHeight)
      }
      
      return rect
  }

  public override func sizeThatFits(_ size: CGSize) -> CGSize {
    let superSizeThatFits = super.sizeThatFits(size)

    let width = superSizeThatFits.width + padding.left + padding.right
    let heigth = superSizeThatFits.height + padding.top + padding.bottom

    return CGSize(width: width, height: heigth)
  }
}
