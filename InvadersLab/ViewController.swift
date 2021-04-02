//
//  ViewController.swift
//  InvadersLab
//
//  Created by Разработчик on 26/03/2021.
//  Copyright © 2021 Разработчик. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var scoreLable: UILabel!
    
    var score = Int()
    
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    

  }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.scoreLable.text = String(score)
    }

    @IBAction func unwindSegueBactToMenu(segue: UIStoryboardSegue){}
}

