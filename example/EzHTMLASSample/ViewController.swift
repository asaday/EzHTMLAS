//
//  ViewController.swift
//  EzHTMLASSample
//

import UIKit
import EzHTMLAS

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		let lbl = UILabel(frame: CGRect(x: 0, y: 100, width: view.bounds.width, height: 100))
		lbl.numberOfLines = 0
		view.addSubview(lbl)

		lbl.HTML = "<span align=center><font size=10 line-height=20>hello</font><br/> <b>bold</b></span><br/><font point=20>big</font>fewfwfqwfqwfwqefqfwfewfwfqwfqwfwqefqfwfewfwfqwfqwfwqefqfwfewfwfqwfqwfwqefqfwfewfwfqwfqwfwqefqfwfewfwfqwfqwfwqefqfw"
	}
}

