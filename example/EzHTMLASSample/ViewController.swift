//
//  ViewController.swift
//  EzHTMLAS Sample
//

import UIKit
import EzHTMLAS

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		let clbl = ClickableLabel(frame: CGRect(x: 0, y: 200, width: view.bounds.width, height: 100))
		clbl.didSelectLink = { a in print(a) }
		clbl.numberOfLines = 0
		clbl.HTML = "aaa &#x3042;<font point=20>big</font> <font color=red>red</font> <a href=zzz>link</a> aaa  <img width=50 height=50 src=\"https://dummyimage.com/50x50/000/fff&text=\(arc4random())\">"
		clbl.setClickable()
		view.addSubview(clbl)

		HTMLAttributedString.addExtraFont(cssName: "material-icons",
		                                  fontName: "MaterialIcons-Regular",
		                                  charNames: readijmap(name: "MaterialIcons-Regular.ijmap"))

		let lbl = UILabel(frame: CGRect(x: 0, y: 100, width: view.bounds.width, height: 100))
		lbl.numberOfLines = 0
		lbl.HTML = "<span align=center><font size=10 line-height=20>hello</font><br/><br/> <b>bold</b></span><i class=\"material-icons\">&#xe05c;</i></span><i class=\"material-icons 30 -10\">face</i>XXX"
		view.addSubview(lbl)

		//		lbl.font = UIFont(name: "MaterialIcons-Regular", size: 30)
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
