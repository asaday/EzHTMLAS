//
//  ViewController.swift
//  EzHTMLAS Sample
//

import UIKit
import EzHTMLAS

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		let lbl = UILabel(frame: CGRect(x: 0, y: 100, width: view.bounds.width, height: 100))
		lbl.numberOfLines = 0
		lbl.HTML = "<span align=center><font size=10 line-height=20>hello</font><br/> <b>bold</b></span>"
		view.addSubview(lbl)

		let clbl = ClickableLabel(frame: CGRect(x: 0, y: 200, width: view.bounds.width, height: 100))
		clbl.didSelectLink = { a in print(a) }
		clbl.numberOfLines = 0
		clbl.HTML = "<font point=20>big</font> <font color=red>red</font> <a href=zzz>link</a> aaa  <img width=50 height=50 src=\"https://dummyimage.com/50x50/000/fff&text=\(arc4random())\">"
		clbl.setClickable()
		view.addSubview(clbl)

		
	}
}
