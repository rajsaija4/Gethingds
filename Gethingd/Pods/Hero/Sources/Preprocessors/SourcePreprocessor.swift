// The MIT License (MIT)
//
// Copyright (c) 2016 Luke Zhao <me@lkzhao.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#if canImport(UIKit)

import UIKit

class SourcePreprocessor: BasePreprocessor {
  override func process(fromViews: [UIView], toViews: [UIView]) {
    for fv in fromViews {
      guard let id = context[fv]?.source,
            let tv = context.destinationView(for: id) else { continue }
      prepareFor(baseView: fv, targetView: tv)
    }
    for tv in toViews {
      guard let id = context[tv]?.source,
            let fv = context.sourceView(for: id) else { continue }
      prepareFor(baseView: tv, targetView: fv)
    }
  }

  func prepareFor(baseView: UIView, targetView: UIView) {
    let targetPos = context.container.convert(targetView.layer.position, from: targetView.superview!)
    let targetTransform = context.container.layer.flatTransformTo(layer: targetView.layer)

    var state = context[baseView]!

    // use global coordinate space since over target position is converted from the global container
    state.coordinateSpace = .global

    state.position = targetPos
    state.transform = targetTransform

    // remove incompatible options
    state.size = nil

    if baseView.bounds.size != targetView.bounds.size {
      state.size = targetView.bounds.size
    }
    if state.cornerRadius == nil, baseView.layer.cornerRadius != targetView.layer.cornerRadius {
      state.cornerRadius = targetView.layer.cornerRadius
    }
    if baseView.layer.shadowColor != targetView.layer.shadowColor {
      state.shadowColor = targetView.layer.shadowColor
    }
    if baseView.layer.shadowOpacity != targetView.layer.shadowOpacity {
      state.shadowOpacity = targetView.layer.shadowOpacity
    }
    if baseView.layer.shadowOffset != targetView.layer.shadowOffset {
      state.shadowOffset = targetView.layer.shadowOffset
    }
    if baseView.layer.shadowRadius != targetView.layer.shadowRadius {
      state.shadowRadius = targetView.layer.shadowRadius
    }
    if baseView.layer.shadowPath != targetView.layer.shadowPath {
      state.shadowPath = targetView.layer.shadowPath
    }
    if baseView.layer.contentsRect != targetView.layer.contentsRect {
      state.contentsRect = targetView.layer.contentsRect
    }
    if baseView.layer.contentsScale != targetView.layer.contentsScale {
      state.contentsScale = targetView.layer.contentsScale
    }

    context[baseView] = state
  }
}

#endif
