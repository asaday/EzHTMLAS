//
//  ViewController.swift
//  EzHTMLAS Sample
//

import EzHTMLAS
import UIKit

class ViewController: UIViewController {
	override func viewDidLoad() {
		super.viewDidLoad()

		let clbl = EzHTMLClickableLabel(frame: CGRect(x: 0, y: 200, width: view.bounds.width, height: 100))
		clbl.didSelectLink = { a in print(a) }
		clbl.numberOfLines = 0
		// clbl.backgroundColor = .lightGray
		clbl.HTML = "aaa<s>bbb</s><u width=3 color=red>ccc</u><shadow>dddd</shadow> &#x3042;<font point=20 color=#0000ff>big</font> <font color=red>red</font> <font color=#00ff00>green</font> <a href=zzz>link</a> aaa  <img width=100 height=50 src=\"https://dummyimage.com/100x50/000/fff&text=\(arc4random())\"><font point=20 color=white stroke-width=-2 stroke-color=red>naka</font><font color=black:0.1>alpha</font><font color=iosblue>blue</font><font normal=20 weight=heavy>heavy</font>"
		clbl.setClickable()
		view.addSubview(clbl)

		UIColor.cssColorList["tint"] = view.tintColor

		HTMLAttributedString.addExtraFont(cssName: "material-icons",
		                                  fontName: "MaterialIcons-Regular",
		                                  charNames: readijmap(name: "MaterialIcons-Regular.ijmap"))

		let lbl = UILabel(frame: CGRect(x: 0, y: 100, width: view.bounds.width, height: 100))
		lbl.numberOfLines = 0
		lbl.HTML = "<span align=center><font size=10 line-height=20>hello</font><br/><br/> <b>bold</b></span><i class=\"material-icons\">&#xe05c;</i></span><i class=\"material-icons 30 -10\">face</i><span base=20>XXX</span><font color=tint>tint</font>"
		view.addSubview(lbl)

		//		let a = "ddddddd<br/>dddddddddddddddddddddddddd<br/>ddddddd<font point=20>dddddddddddddddddddddddddddddddddddddddddddddddd</font>ddddddddddddddddddddddddddddddddddddddddddddddddddXX".attributedString(UIFont.systemFont(ofSize: 10))

		//		let a = "ddddddd<br/>dddddddddddddddddddddddddd<br/>ddddddd<font point=20>ddddddddddddd</font>ddddddddddddああddddddddX".attributedString()

		let a = lbl.attributedText ?? NSAttributedString()

		print(a.description)
		lbl.attributedText = a

		print(a.size())

		print(a.heightWith(width: view.bounds.width))
		print(a.boundedRect(lbl.frame))

		lbl.sizeToFit()
		lbl.backgroundColor = .lightGray
		print(lbl.frame)
	}

	func readijmap(name: String) -> [String: Int] {
		guard let url = Bundle.main.resourceURL?.appendingPathComponent(name),
			let dat = try? Data(contentsOf: url),
			let json = try? JSONSerialization.jsonObject(with: dat, options: []),
			let root = json as? [String: Any],
			let icons = root["icons"] as? [String: Any]
		else { return [:] }

		var r: [String: Int] = [:]
		for (k, v) in icons {
			guard let num = Int(k, radix: 16),
				let dic = v as? [String: String],
				let name = dic["name"]
			else { continue }

			r[name] = num
		}
		return r
	}
}
