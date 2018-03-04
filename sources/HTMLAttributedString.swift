
// Copyright (c) NagisaWorks asaday
// The MIT License (MIT)

import UIKit

extension UILabel {

	public var HTML: String {
		get {
			guard let a = attributedText else { return "" }
			return a.HTMLString()
		}
		set {
			attributedText = newValue.attributedString(font)

			attributedText?.loadAttachedImages { [weak self] in
				guard let me = self else { return }
				let z = me.attributedText
				me.attributedText = NSAttributedString() // reset
				me.attributedText = z
			}
		}
	}

	public func hasLink() -> Bool {
		var has = false
		if let ats = attributedText {
			ats.enumerateAttribute(.link, in: NSMakeRange(0, ats.length), options: [], using: { v, _, _ in
				if v != nil { has = true }
			})
		}
		return has
	}

	public func findLink(position: CGPoint) -> String? {
		guard let ats = attributedText else { return nil }

		let layoutManager = NSLayoutManager()
		let textContainer = NSTextContainer(size: bounds.size)
		let textStorage = NSTextStorage(attributedString: ats)

		layoutManager.addTextContainer(textContainer)
		textStorage.addLayoutManager(layoutManager)

		textContainer.lineFragmentPadding = 0.0
		textContainer.lineBreakMode = lineBreakMode
		textContainer.maximumNumberOfLines = numberOfLines

		let textBoundingBox = layoutManager.usedRect(for: textContainer)

		var offset = CGPoint(x: 0, y: textBoundingBox.origin.y - (bounds.height - textBoundingBox.size.height) / 2)
		if textAlignment == .center { offset.x = textBoundingBox.origin.x - (bounds.width - textBoundingBox.size.width) / 2 }
		if textAlignment == .right { offset.x = textBoundingBox.origin.x - (bounds.width - textBoundingBox.size.width) }

		let pos = CGPoint(x: position.x + offset.x, y: position.y + offset.y)
		if !textBoundingBox.contains(pos) { return nil }
		let index = layoutManager.characterIndex(for: pos, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
		if index < 0 || index >= ats.length { return nil }

		guard let val = ats.attribute(.link, at: index, effectiveRange: nil) as? String else { return nil }
		return val
	}
}

extension UITextView {
	public var HTML: String {
		get {
			guard let a = attributedText else { return "" }
			return a.HTMLString()
		}
		set {
			attributedText = newValue.attributedString(font)

			attributedText.loadAttachedImages { [weak self] in
				guard let me = self else { return }
				let z = me.attributedText
				me.attributedText = NSAttributedString() // reset
				me.attributedText = z
			}
		}
	}
}

extension UIButton {
	public var HTML: String {
		get {
			guard let a = attributedTitle(for: .normal) else { return "" }
			return a.HTMLString()
		}
		set {
			setAttributedTitle(newValue.attributedString(titleLabel?.font), for: .normal)
		}
	}
}

extension String {

	public func attributedString(_ font: UIFont? = nil) -> NSAttributedString {
		return HTMLAttributedString.toAS(self, font: font ?? UIFont.systemFont(ofSize: 17))
	}
}

public extension NSAttributedString {
	func HTMLString() -> String {
		return HTMLAttributedString.toHTML(self)
	}

	func boundedSize(_ size: CGSize) -> CGSize {
		return boundingRect(with: size, options: [.usesFontLeading, .usesLineFragmentOrigin], context: nil).integral.size
	}

	func boundedRect(_ rc: CGRect) -> CGRect {
		var r = rc
		r.size = boundedSize(rc.size)
		return r
	}

	func heightWith(width: CGFloat, max: CGFloat = 30000) -> CGFloat {
		return boundedSize(CGSize(width: width, height: max)).height
	}
}

extension NSAttributedString {
	func loadAttachedImages(completion: (() -> Void)?) {
		enumerateAttribute(NSAttributedStringKey(rawValue: "requestimage"), in: NSMakeRange(0, length), options: []) { value, _, _ in
			guard let param = value as? [String: Any],
				let src = param["src"] as? String,
				let attach = param["attach"] as? NSTextAttachment,
				let url = URL(string: src) else { return }

			let task = URLSession.shared.dataTask(with: url) { d, _, _ in
				guard let od = d, let img = UIImage(data: od) else { return }
				DispatchQueue.main.async {
					if let h = param["capheight"] as? CGFloat {
						attach.bounds = CGRect(x: 0, y: round((h - img.size.height) / 2), width: img.size.width, height: img.size.height)
					}

					attach.image = img
					completion?()
				}
			}
			task.resume()
		}
	}
}

public struct HTMLAttributedString {

	public static func setStyle(_ key: String, _ font: UIFont, _ color: UIColor?, _ bgcolor: UIColor?) {
		var dic: [NSAttributedStringKey: Any] = [:]
		dic[.font] = font
		if let c = color { dic[.foregroundColor] = c }
		if let c = bgcolor { dic[.backgroundColor] = c }
		styles[key] = dic
	}

	public static func setStyle(_ key: String, param: [NSAttributedStringKey: Any]) {
		styles[key] = param
	}

	public static var styles: [String: [NSAttributedStringKey: Any]] = [
		"head": [.font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)], // 17 semi-bold
		"sub": [.font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)], // 15
		"body": [.font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)], // 17
		"foot": [.font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.footnote)], // 13
		"caption1": [.font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption1)], // 12
		"caption2": [.font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption2)], // 11
		"a": [.underlineStyle: 1, .foregroundColor: UIColor(red: 0, green: 0.48, blue: 1, alpha: 1)],

		// you can add more
	]

	public static var fontSizes: [CGFloat] = [0.6, 0.75, 0.9, 1.0, 1.2, 1.5, 2.0, 3.0] // mul

	//	public static var iconFont = "FontAwesome"

	//	let xx = ExtFontParam(font: "")
	struct ExtFontParam {
		let font: String
		let names: [String: Int]
	}

	static var extFonts: [String: ExtFontParam] = [:]

	public static func addExtraFont(cssName: String, fontName: String, charNames: [String: Int]) {
		extFonts[cssName] = ExtFontParam(font: fontName, names: charNames)
	}

	//
	//	// for extend
	//	public static var as2htmlHandler: ((_ atb: [String: Any], _ str: String, _ elements: inout [String]) -> String?)?
	//	public static var html2asHandler: ((_ element: String, _ params: [String: String], _ atb: inout [String: Any]) -> NSAttributedString?)?

	/* return tags
	 font size=1-7
	 font point-size=
	 font color=#hexcolor
	 a href=url
	 b
	 i
	 br
	 img (no src)

	 */

	static func toHTML(_ astring: NSAttributedString) -> String {

		func nsatb2htmlElement(_ atb: [NSAttributedStringKey: Any]) -> [String] {

			var result: [String] = []
			var fontr: [String] = []

			for (k, v) in atb {
				switch k {
				case .font:
					guard let f = v as? UIFont else { break }
					let des = f.fontDescriptor
					if des.symbolicTraits.contains(.traitBold) { result.append("b") }
					if des.symbolicTraits.contains(.traitItalic) { result.append("i") }

					let font = atb[.font] as? UIFont ?? UIFont.systemFont(ofSize: 17)
					if f.pointSize == font.pointSize { break }

					var done = false
					for i in 0 ..< fontSizes.count {
						if font.pointSize * fontSizes[i] == f.pointSize {
							fontr.append("size=\"\(i)\"")
							done = true
							break
						}
					}
					if done { break }
					fontr.append("point-size=\"\((f.pointSize))\"")

				case .foregroundColor:
					guard let c = v as? UIColor else { break }
					var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
					c.getRed(&r, green: &g, blue: &b, alpha: &a)
					let s = String(format: "%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
					fontr.append("color=\"#\(s)\"")

				case .link:
					guard let s = v as? String else { break }
					result.append("a href=\"\(s)\"")

				case .underlineStyle:
					result.append("u")

				default:
					break
				}
			}

			if !fontr.isEmpty { result.append("font " + fontr.joined(separator: " ")) }

			return result
		}

		var current: [String] = []
		var result: String = ""

		astring.enumerateAttributes(in: NSRange(location: 0, length: astring.length), options: []) { attributes, range, _ in
			let elements = nsatb2htmlElement(attributes)
			let str = astring.attributedSubstring(from: range).string

			//			if let h = as2htmlHandler {
			//				if let r = h(attributes, str, &elements) {
			//					result += r
			//					return
			//				}
			//			}

			if str == "\u{fffc}" {
				result += "<img"
				if let v = astring.attribute(NSAttributedStringKey(rawValue: "imgsrc"), at: range.location, effectiveRange: nil) as? String {
					result += " src=\"\(v)\""
				}
				result += "/>"
				return
			}

			while let v = current.last {
				if elements.contains(v) { break }
				result += "</\(v.components(separatedBy: " ").first ?? "")>"
				current.removeLast()
			}

			for v in elements {
				if current.contains(v) { continue }
				result += "<\(v)>"
				current.append(v)
			}

			result += str.replace([
				("&", "&amp;"),
				("\u{a0}", "&nbsp;"),
				("\"", "&quot;"),
				("<", "&lt;"),
				(">", "&gt;"),
				("\n", "<br/>"),
			])
		}

		while let v = current.last {
			result += "</\(v.components(separatedBy: " ").first ?? "")>"
			current.removeLast()
		}

		return result
	}

	/* capable

	 font size=1-7 (default:3 relative)
	 font point-size=point
	 font color=#hexcolor
	 font background=#hexcolor
	 br
	 p
	 p aligin=left,center,right
	 p direction=vertical
	 span style=user-defined-style
	 a href=url
	 img src=name
	 img src=name width= height= x=offset y=offset

	 */
	public static func toAS(_ str: String, font: UIFont) -> NSAttributedString {

		if !str.has(string: "<") {
			return NSAttributedString(string: str, attributes: [.font: font])
		}

		func xstr(_ ptr: UnsafePointer<xmlChar>?) -> String? {
			guard let ptr = ptr else { return nil }
			var r: String?
			ptr.withMemoryRebound(to: CChar.self, capacity: 4) {
				r = String(cString: $0)
			}
			return r
		}

		func changeFontSize(_ atb: inout [NSAttributedStringKey: Any], size: CGFloat) {
			if let f = atb[.font] as? UIFont {
				atb[.font] = UIFont(descriptor: f.fontDescriptor, size: size)
			} else { atb[.font] = UIFont.systemFont(ofSize: size) }
		}

		func changeFontTrait(_ atb: inout [NSAttributedStringKey: Any], traits: UIFontDescriptorSymbolicTraits) {
			if let f = atb[.font] as? UIFont, let fd = f.fontDescriptor.withSymbolicTraits(traits) {
				atb[.font] = UIFont(descriptor: fd, size: f.pointSize)
			} else { atb[.font] = UIFont.boldSystemFont(ofSize: 17) }
		}

		func newParagraph() -> NSMutableParagraphStyle {
			let v = NSMutableParagraphStyle()
			v.lineBreakMode = .byTruncatingTail
			return v
		}

		func modifyAttribute(_ atb: inout [NSAttributedStringKey: Any], node: xmlNodePtr) -> NSAttributedString? {

			var result: NSAttributedString?

			guard let ielement = xstr(node.pointee.name) else { return result }
			let element = ielement.lowercased()

			var params: [String: String] = [:]
			var props = xmlNodePtr(node.pointee.properties)

			while props != nil {
				if props?.pointee.children == nil { continue }
				guard let key = xstr(props?.pointee.name), var val = xstr(props?.pointee.children.pointee.content) else { continue }
				if val.hasSuffix("/") { val = val.ns.substring(to: val.length - 1) }
				params[key.lowercased()] = val
				props = props?.pointee.next
			}

			switch element {
			case "br":
				result = NSAttributedString(string: "\n", attributes: atb)

			case "font":
				if let v = params["size"] {
					var idx = v.intValue
					if v.hasPrefix("+") || v.hasPrefix("-") {
						var org: Int = 3
						if let f = atb[.font] as? UIFont, let fi = fontSizes.index(of: f.pointSize / font.pointSize) { org = fi }
						idx += org
					}
					if idx < 0 || idx >= fontSizes.count { idx = 3 }
					changeFontSize(&atb, size: font.pointSize * fontSizes[idx])
				}

				if let v = params["point-size"] { changeFontSize(&atb, size: v.CGFloatValue) }
				if let v = params["point"] { changeFontSize(&atb, size: v.CGFloatValue) }
				if let v = params["color"] { atb[.foregroundColor] = UIColor.css(v) }
				if let v = params["background"] { atb[.backgroundColor] = UIColor.css(v) }
				if let v = params["normal"] { atb[.font] = UIFont.systemFont(ofSize: v.CGFloatValue) }
				if let v = params["bold"] { atb[.font] = UIFont.boldSystemFont(ofSize: v.CGFloatValue) }
				if let v = params["line-height"] {
					let ps = atb[.paragraphStyle] as? NSMutableParagraphStyle ?? newParagraph()
					ps.maximumLineHeight = v.CGFloatValue
					ps.minimumLineHeight = v.CGFloatValue
					atb[.paragraphStyle] = ps
				}

			case "b":
				changeFontTrait(&atb, traits: .traitBold)

			case "i":
				// <i class="material-icons">face</i>
				// <i class="material-icons 24">face</i>
				// <i class="material-icons 24 -12">face</i>
				// <i class="material-icons">&#xE87C;</i>

				if let cls = params["class"] {
					let ss = cls.components(separatedBy: " ")
					if let ex = extFonts[ss[0]] {
						var size: CGFloat = 18
						if let f = atb[.font] as? UIFont { size = f.pointSize }
						if let v = ss[safe: 1] { size = v.CGFloatValue }
						if let v = ss[safe: 2] { atb[.baselineOffset] = v.floatValue }
						atb[.font] = UIFont(name: ex.font, size: size)
						atb[NSAttributedStringKey("exfont")] = ss[0]
					}
				} else {
					changeFontTrait(&atb, traits: .traitItalic)
				}

			case "img":
				if let src = params["src"] {
					let attach = NSTextAttachment()
					var rc: CGRect = .zero
					if let img = UIImage(named: src) {
						attach.image = img
						rc.size = img.size
						rc.origin.y = round((font.capHeight - img.size.height) / 2)
					}

					if let v = params["width"] { rc.size.width = v.CGFloatValue }
					if let v = params["height"] { rc.size.height = v.CGFloatValue }
					if let v = params["x"] { rc.origin.x = v.CGFloatValue } // may be no effect x
					if let v = params["y"] { rc.origin.y = v.CGFloatValue }

					if rc.width > 0 && rc.height > 0 { attach.bounds = rc }

					let ras = NSAttributedString(attachment: attach).mutableCopy() as? NSMutableAttributedString
					ras?.addAttribute(NSAttributedStringKey(rawValue: "imgsrc"), value: src, range: NSRange(location: 0, length: 1))

					if attach.image == nil {
						var dic: [String: Any] = ["src": src, "attach": attach]
						if rc.width == 0 && rc.height == 0 { dic["capheight"] = font.capHeight }
						ras?.addAttribute(NSAttributedStringKey(rawValue: "requestimage"), value: dic, range: NSRange(location: 0, length: 1))
					}

					result = ras?.copy() as? NSAttributedString
				}

			case "p", "span":
				if element == "p" { result = NSAttributedString(string: "\n", attributes: atb) }

				if let v = params["style"], let style = styles[v] {
					for (k, z) in style { atb[k] = z }
				}

				if let v = params["align"] {
					let ps = atb[.paragraphStyle] as? NSMutableParagraphStyle ?? newParagraph()
					switch v {
					case "left": ps.alignment = .left
					case "right": ps.alignment = .right
					case "center": ps.alignment = .center
					default: break
					}
					atb[.paragraphStyle] = ps
				}

				if let v = params["line-break"] {
					let ps = atb[.paragraphStyle] as? NSMutableParagraphStyle ?? newParagraph()
					switch v {
					case "word-wrapping": ps.lineBreakMode = .byWordWrapping
					case "char-wrapping": ps.lineBreakMode = .byCharWrapping
					case "clipping": ps.lineBreakMode = .byClipping
					case "truncating-head": ps.lineBreakMode = .byTruncatingHead
					case "truncating-tail": ps.lineBreakMode = .byTruncatingTail // when align set, auto selected this
					case "truncating-middle": ps.lineBreakMode = .byTruncatingMiddle
					default: break
					}
					atb[.paragraphStyle] = ps
				}

				if let v = params["direction"], v == "vertical" {
					atb[.verticalGlyphForm] = 1
				}

			case "a":
				if let v = params["href"] {
					atb[.link] = v
					if let style = styles["a"] {
						for (k, z) in style { atb[k] = z }
					}
				}

			default:
				break
			}

			return result
		}

		func asByNode(_ node: xmlNodePtr, attributes: [NSAttributedStringKey: Any]) -> NSAttributedString {

			let result = NSMutableAttributedString()
			var atb = attributes

			if node.pointee.type == XML_ELEMENT_NODE {
				if let r = modifyAttribute(&atb, node: node) {
					result.append(r)
				}
			}

			if node.pointee.type != XML_ENTITY_REF_NODE && node.pointee.type != XML_ELEMENT_NODE && node.pointee.content != nil {
				if let s = xstr(node.pointee.content) {
					result.append(makeAppendAttributedString(s: s, attributes: atb))
				}
			}

			var current = node.pointee.children
			while current != nil {
				result.append(asByNode(current!, attributes: atb))
				current = current?.pointee.next
			}
			return result
		}

		func makeAppendAttributedString(s: String, attributes: [NSAttributedStringKey: Any]) -> NSAttributedString {
			if let exfont = attributes[NSAttributedStringKey("exfont")] as? String, let code = extFonts[exfont]?.names[s.trim()] {
				return NSAttributedString(string: String(describing: UnicodeScalar(code)), attributes: attributes)
			}

			return NSAttributedString(string: s, attributes: attributes)
		}

		let result = NSMutableAttributedString()
		guard let data = str.data(using: .utf8) else { return result }

		let document = htmlReadMemory((data as NSData).bytes.bindMemory(to: Int8.self, capacity: data.count), Int32(data.count), nil, "UTF-8", Int32(HTML_PARSE_NOWARNING.rawValue | HTML_PARSE_NOERROR.rawValue))
		if document == nil { return result }

		var current = document?.pointee.children
		while current != nil {
			result.append(asByNode(current!, attributes: [.font: font]))
			current = current?.pointee.next
		}
		xmlFreeDoc(document)

		return result
	}
}
