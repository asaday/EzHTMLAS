//
//  HASClickableLabel.swift
//  EzHTMLAS
//
//

import UIKit

open class EzHTMLClickableLabel: UILabel, UIGestureRecognizerDelegate {
	public var didSelectLink: ((String) -> Void)?

	var ges: UITapGestureRecognizer?
	var lastPoint: CGPoint?
	var lastValue: String?

	open func setClickable() { // set this after each set attributedstring
		if ges == nil {
			let g = UITapGestureRecognizer(target: self, action: #selector(tap(ges:)))
			addGestureRecognizer(g)
			g.delegate = self
			ges = g
		}

		let b = hasLink()
		ges?.isEnabled = b
		isUserInteractionEnabled = b
		lastPoint = nil
		lastValue = nil
	}

	open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
		if ges != gestureRecognizer { return true }
		if didSelectLink == nil { return false }

		let pnt = gestureRecognizer.location(in: self)

		if let r = findLink(position: pnt) {
			lastPoint = pnt
			lastValue = r
			return true
		}

		return false
	}

	func tap(ges: UITapGestureRecognizer) {
		let pnt = ges.location(in: self)

		if let lp = lastPoint, let lv = lastValue, pnt.equalTo(lp) { //  already found, short cut rutines
			didSelectLink?(lv)
			return
		}

		if let r = findLink(position: pnt) {
			didSelectLink?(r)
		}
	}
}
