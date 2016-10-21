
// Copyright (c) NagisaWorks asaday
// The MIT License (MIT)

import UIKit

extension String {
	var intValue: Int { return Int(self) ?? 0 }
	var floatValue: Float { return Float(self) ?? 0 }
	var CGFloatValue: CGFloat { return CGFloat(self.floatValue) }
	var length: Int { return characters.count }

	var ns: NSString { return (self as NSString) }

	func has(string str: String) -> Bool {
		if let _ = range(of: str) { return true }
		return false
	}

	func replace(_ dic: [(String, String)]) -> String {
		let ms: NSMutableString = NSMutableString(string: self)
		dic.forEach { (k, v) in
			ms.replaceOccurrences(of: k, with: v, options: .caseInsensitive, range: NSMakeRange(0, ms.length))
		}
		return String(ms)
	}

}

extension UIColor {
	static func hexColor(_ hex: String, alpha: CGFloat = 1.0) -> UIColor {
		var red: CGFloat = 0.0
		var green: CGFloat = 0.0
		var blue: CGFloat = 0.0

		let scanner = Scanner(string: hex.ns.replacingOccurrences(of: "#", with: ""))
		var hexValue: CUnsignedLongLong = 0
		if scanner.scanHexInt64(&hexValue) {
			red = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
			green = CGFloat((hexValue & 0x00FF00) >> 8) / 255.0
			blue = CGFloat(hexValue & 0x0000FF) / 255.0
		}

		return UIColor(red: red, green: green, blue: blue, alpha: alpha)
	}
}
