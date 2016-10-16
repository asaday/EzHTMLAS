//
//  ViewController.swift
//  EzHTMLASSample
//

import UIKit
import EzHTMLAS

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		let lbl = UILabel(frame: view.bounds)
		lbl.numberOfLines = 0
		view.addSubview(lbl)

		lbl.HTML = "hello <b>bold</b><br/><font point=20>big</font> "
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

}

