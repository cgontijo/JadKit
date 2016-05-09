//
//  View.swift
//  JadKit
//
//  Created by Jad Osseiran on 16/07/2014.
//  Copyright (c) 2016 Jad. All rights reserved.
//
//  --------------------------------------------
//
//  A useful set of methods that can be used on views. This is especially useful
//  when writing code without Aurtolayout.
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
 returns: an array of views which share the widest width.
 The returned views are returned in the order of which they are given.å
 - parameter views: Views from which to find the widest ones.
 - returns: The views which share the widest width.
 - complexity: O(n)
 */
public func widestViews(views views: [UIView]) -> [UIView] {
  var widestViews = [UIView]()

  for view in views {
    if widestViews.count > 0 {
      let widestWidth = widestViews.first!.frame.size.width
      let viewWidth = view.frame.size.width

      if widestWidth < viewWidth {
        widestViews.removeAll(keepCapacity: false)
        widestViews += [view]
      } else if widestWidth == viewWidth {
        widestViews += [view]
      }
    } else {
      widestViews += [view]
    }
  }

  return widestViews
}

/**
 returns: the first widest view from the given array of views.
 To return all widest views use the `wisdestViews` function.
 - parameter views: Views from which to find the widest.
 - returns: The first widest view.
 - complexity: O(n)
 */
public func widestView(views views: [UIView]) -> UIView {
  let wideViews = widestViews(views: views)
  return wideViews.first!
}

/**
 returns: an array of views which share the tallest height.
 The returned views are returned in the order of which they are given.
 - parameter views: Views from which to find the tallest ones.
 - returns: The views which share the tallest height.
 - complexity: O(n)
 */
public func tallestViews(views views: [UIView]) -> [UIView] {
  var tallestViews = [UIView]()

  for view in views {
    if tallestViews.count > 0 {
      let tallestHeight = tallestViews.first!.frame.size.height
      let viewHeight = view.frame.size.height

      if tallestHeight < viewHeight {
        tallestViews.removeAll(keepCapacity: false)
        tallestViews += [view]
      } else if tallestHeight == viewHeight {
        tallestViews += [view]
      }
    } else {
      tallestViews += [view]
    }
  }

  return tallestViews
}

/**
 returns: the first tallest view from the given array of views.
 To return all tallest views use the `tallestViews` function.
 - parameter views: Views from which to find the tallest.
 - returns: The first tallest view.
 - complexity: O(n)
 */
public func tallestView(views views: [UIView]) -> UIView {
  let tallViews = tallestViews(views: views)
  return tallViews.first!
}

/**
 Function to retrieve the total combined width of the given views taking into
 account the space separating each view.
 - parameter views: Views which make up the accumulated width.
 - parameter separatorLength: The separator length between each views.
 - returns: The combined total width including the separation between views.
 - complexity: O(n)
 */
public func totalWidth(views views: [UIView], separatorLength: CGFloat = 0.0) -> CGFloat {
  var totalWidth: CGFloat = 0.0
  for view in views {
    totalWidth += view.frame.size.width
  }
  return totalWidth + (CGFloat(views.count - 1) * separatorLength)
}

/**
 Function to retrieve the total combined height of the given views taking into
 account the space separating each view.
 - parameter views: Views which make up the accumulated height.
 - parameter separatorLength: The separator length between each views.
 - returns: The combined total height including the separation between views.
 - complexity: O(n)
 */
public func totalHeight(views views: [UIView], separatorLength: CGFloat = 0.0) -> CGFloat {
  var totalHeight: CGFloat = 0.0
  for view in views {
    totalHeight += view.frame.size.height
  }
  return totalHeight + (CGFloat(views.count - 1) * separatorLength)
}

public extension UIView {
  /**
   The duration for an animation.
   */
  public enum AnimationDuration: Double {
    /// 0.3s, quick animation.
    case short = 0.3
    /// 0.6s, twice as long as the `Short` duration.
    case medium = 0.6
    /// 0.9s, three times as long as the `Short` duration.
    case long = 0.9
  }

  // MARK: Hiding

  // FIXME: This method could get some loving, specially with the iOS 9 UIVisualEffectView stuff.
  /**
   Hides or unhides the view with the option the animate the transition.
   - parameter hidden: Wether the view is to be hidden or not.
   - parameter animated: Flag to animate the trasition.
   - parameter duration: The duration of the hiding animation if turned on. `Short` by default.
   - parameter effect: The `UIVisualEffect` that the view will take when it is shown again.
   `nil` by default.
   - parameter completion: Call back when the view has been hid or unhid. `nil` by default.
   */
  public func setHidden(hide: Bool, animated: Bool,
                        duration: Double = AnimationDuration.short.rawValue,
                        effect: UIVisualEffect? = nil, completion: ((Bool) -> Void)! = nil) {
    if animated {
      if hide {
        UIView.animateWithDuration(duration, animations: {
          if #available(iOS 9, *) {
            if let effectView = self as? UIVisualEffectView {
              effectView.effect = nil
              effectView.contentView.alpha = 0.0
            } else {
              self.alpha = 0.0
            }
          } else {
            self.alpha = 0.0
          }

          }, completion: { finished in
            if finished {
              self.hidden = true
            }

            if completion != nil {
              completion(finished)
            }
        })
      } else {
        if #available(iOS 9, *) {
          if let effectView = self as? UIVisualEffectView {
            effectView.contentView.alpha = 1.0
          } else {
            alpha = 0.0
          }
        } else {
          alpha = 0.0
        }
        hidden = false

        UIView.animateWithDuration(duration, animations: {
          if #available(iOS 9, *) {
            if let effectView = self as? UIVisualEffectView {
              effectView.effect = effect ?? UIBlurEffect(style: .Light)
              effectView.contentView.alpha = 1.0
            } else {
              self.alpha = 1.0
            }
          } else {
            self.alpha = 1.0
          }
        }, completion: completion)
      }
    } else {
      if self is UIVisualEffectView == false {
        alpha = hide ? 0.0 : 1.0
      }
      hidden = hide

      if completion != nil {
        completion(true)
      }
    }
  }

  // MARK: Positioning

  /**
   Calculates and returns: the value for the X origin of the view which will
   center it in relation to the given frame.
   The returned X origin is floored.
   - parameter frame: The frame which the view will use to center itself.
   - returns: The X origin for the view to take in order to be centered.
   */
  public func horizontalCenterWithReferenceFrame(frame: CGRect) -> CGFloat {
    let offset = floor((frame.size.width - self.frame.size.width) / 2.0)
    return frame.origin.x + offset
  }

  /**
   Calculates and returns: the value for the Y origin of the view which will
   center it in relation to the given frame.
   The returned Y origin is floored.
   - parameter frame: The frame which the view will use to center itself.
   - returns: The Y origin for the view to take in order to be centered.
   */
  public func verticalCenterWithReferenceFrame(frame: CGRect) -> CGFloat {
    let offset = floor((frame.size.height - self.frame.size.height) / 2.0)
    return frame.origin.y + offset
  }

  /**
   This method centers the view to be centered on the X axis with relation
   to the passed frame.
   - parameter rect: The rect which is used as a horizontal centering reference.
   */
  public func centerHorizontallyWithReferenceRect(rect: CGRect) {
    self.frame.origin.x = horizontalCenterWithReferenceFrame(rect)
  }

  /**
   This method centers the view to be centered on the Y axis with relation
   to the passed frame.
   - parameter rect: The rect which is used as a vertical centering reference.
   */
  public func centerVerticallyWithReferenceRect(rect: CGRect) {
    self.frame.origin.y = verticalCenterWithReferenceFrame(rect)
  }

  // MARK: Masking

  /**
   Method to set a rounded edges mask on the view's layer.
   - parameter radius: The radius to use for the rounded edges.
   */
  public func maskToRadius(radius: CGFloat) {
    layer.cornerRadius = radius
    layer.masksToBounds = true
  }

  /**
   Masks the view's layer to be in a cirle.
   */
  public func maskToCircle() {
    maskToRadius(frame.size.width / 2.0)
  }
}
