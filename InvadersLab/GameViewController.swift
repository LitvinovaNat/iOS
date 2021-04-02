//
//  GameViewController.swift
//  InvadersLab
//
//  Created by Разработчик on 26/03/2021.
//  Copyright © 2021 Разработчик. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
  
  @IBOutlet weak var buttonLeft: UIButton!
  @IBOutlet weak var buttonRight: UIButton!
  @IBOutlet weak var gameOver: UILabel!
  @IBOutlet weak var score: UILabel!
  @IBOutlet weak var scoreLabel: UILabel!
  @IBOutlet weak var endButton: UIButton!
    
  private let shipImage = UIImage(named: "ship")
  private var shipImageView = UIImageView()
  private var playerAttack = 40
  private var playerBullets = [UIImageView]()
    

    
  private var enemies = [[UIImageView]]()
  private var aliveEnemies = 15
  private var enemyXDir :CGFloat = -1
  private var enemyYDir :CGFloat = 0
  private var enemyAttack = 50
  private var enemyBullets = [UIImageView]()
    
  private var time: Timer?
    
  var gameState = GameState()
    
  private var currentScore = 0
    
  override func viewDidLoad() {
     super.viewDidLoad()
    
    
      let buttonLeftImage = UIImage(named: "left")
      let buttonRightImage = UIImage(named: "right")
    
      self.gameOver.isHidden = true
      self.score.isHidden = true
      self.scoreLabel.isHidden = true
      self.endButton.isHidden = true
      self.endButton.isEnabled = false
      
      buttonLeft.setImage(buttonLeftImage, for: .normal)
      buttonRight.setImage(buttonRightImage, for: .normal)
      createShip()
      posEnemies()
      buttonTargets()
    
      time = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(draw), userInfo: nil, repeats: true)
    
    
      
    }
  
  private func createShip () {
    shipImageView = UIImageView(image: shipImage)
    shipImageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
    shipImageView.center = self.view.center
    shipImageView.center.y = buttonLeft.center.y-115
    self.view.addSubview(shipImageView)
  }
    
    @objc func draw()  {
        
        drawEnemies()
        drawPlayer()
     
        
    }
    
    func posEnemies() {
        for i in 1...5 {
            var enemyX = [UIImageView]()
            for j in 1...3{
                let enemyCGRect = CGRect(x:view.frame.width * CGFloat(i*2-1) * (1/11), y:view.frame.width * (1.5/11) * CGFloat(j), width: view.frame.width * (1/11), height: view.frame.width * (1/11))
                let newEnemy = UIImageView(frame: enemyCGRect)
                newEnemy.image = #imageLiteral(resourceName: "enemyb1")
                view.addSubview(newEnemy)
                enemyX.append(newEnemy)
                
            }
            enemies.append(enemyX)
        }
    }
    func drawEnemies() {
        enemiesAttack()
        
        for i in 0...4 {
            for j in 0...2 {
                enemies[i][j].frame.origin.x += enemyXDir
            }
        }
        
        for i in 0...4{
            if enemies[i][0].frame.origin.x + enemies[i][0].frame.width >= view.frame.width {
                enemyXDir = -1
            }
            if enemies[i][0].frame.origin.x  <= 0 {
                enemyXDir = 1
            }
        }
        
        for i in 0...4 {
            for j in 0...2 {
                enemies[i][j].frame.origin.y += enemyYDir
                enemies[i][j].transform = CGAffineTransform(scaleX: enemyXDir, y: 1)
            }
        }
        
        
    }
    
    func enemiesAttack(){
        enemyAttack += 1
        
        if enemyAttack >= 60 {
            let randx = Int.random(in: 0...4)
            let randy = Int.random(in: 0...2)
            let selectedEnemy = enemies[randx][randy]
            if !selectedEnemy.isHidden {
                let myView = CGRect(x: selectedEnemy.frame.origin.x + selectedEnemy.frame.width * 0.45, y: selectedEnemy.frame.origin.y + selectedEnemy.frame.height * 0.3, width: selectedEnemy.frame.width * 0.5, height: selectedEnemy.frame.height * 0.5)
                let newEnemyBullet = UIImageView(frame: myView)
                newEnemyBullet.image = #imageLiteral(resourceName: "bullet")
                view.addSubview(newEnemyBullet)
                enemyBullets.append(newEnemyBullet)
                enemyAttack = 0
            }
        }
        
        for (number, item) in enemyBullets.enumerated() {
            item.frame.origin.y += 5
            if item.frame.origin.y > item.frame.height + view.frame.height {
                enemyBullets[number].removeFromSuperview()
                enemyBullets.remove(at: number)
            }
        }
        
        
    }
   
    
    private func buttonTargets(){
        self.buttonLeft.addTarget(self, action: #selector(moveShipLeft(sender:)), for: .touchDown)
        self.buttonRight.addTarget(self, action: #selector(moveShipRight(sender:)), for: .touchDown)
        self.endButton.addTarget(self, action: #selector(goToMenu(sender:)), for: .touchUpInside)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToMenu"{
            if let vc = segue.destination as? ViewController{
                if let temp = sender as? Int{
                    vc.score = temp
                }
            }
        }
        
    }
    
    @objc func goToMenu(sender: UIButton){
        performSegue(withIdentifier: "goToMenu", sender: self.currentScore)
    }
    
    func drawPlayer() {
        playerAttack += 1
        Shoot()
        
        
        ourDeath()
        
        
    }
    
    func ourDeath() {
        
        for (number, item) in enemyBullets.enumerated() {
            item.frame.origin.y += 5
            if item.frame.origin.y > item.frame.height + view.frame.height {
                enemyBullets[number].removeFromSuperview()
                enemyBullets.remove(at: number)
            }
            if (item.frame.origin.y - shipImageView.frame.height*0.3 > shipImageView.frame.origin.y){
                if (item.frame.intersects(shipImageView.frame)) {
                    enemyBullets[number].removeFromSuperview()
                    enemyBullets.remove(at: number)
                    gameState.health-=1
                    if (gameState.health==0) {
                      aliveEnemies = 15
                      score.text = String(currentScore)
                      score.isHidden = false
                      scoreLabel.isHidden = false
                      gameOver.isHidden = false
                      self.endButton.isHidden = false
                      self.endButton.isEnabled = true
                      self.buttonLeft.isHidden = true
                      self.buttonRight.isHidden = true
                      time?.invalidate()
                    }
                    
                }
            }
        }
        
    }
    
    private func Shoot(){
        if playerAttack > gameState.fireRate {
            let myView = CGRect(x: shipImageView.frame.origin.x + shipImageView.frame.width * 0.45, y: shipImageView.frame.origin.y-shipImageView.frame.height * 0.3, width: shipImageView.frame.width * 0.1, height: shipImageView.frame.height * 0.5)
            let newPlayerBullet = UIImageView(frame: myView)
            newPlayerBullet.image = #imageLiteral(resourceName: "ourBullet")
            view.addSubview(newPlayerBullet)
            playerBullets.append(newPlayerBullet)
            playerAttack = 0
        }
        
        //player bullet intersect check
        let enemyPos = enemies[0][2].frame.origin.y + enemies[0][2].frame.height
        outer: for (number, item) in playerBullets.enumerated(){
            item.frame.origin.y -= 10
            if item.frame.origin.y < -150 {
                playerBullets[number].removeFromSuperview()
                playerBullets.remove(at: number)
            } else {
                if enemyPos >= item.frame.origin.y {
                    inner : for i in 0...4 {
                        for j in 0...2 {
                            if (item.frame.intersects(enemies[i][j].frame) && enemies[i][j].isHidden==false) {
                                playerBullets[number].removeFromSuperview()
                                playerBullets.remove(at: number)
                                enemies[i][j].isHidden = true
                                currentScore += 1
                                score.text = String(currentScore)
                                aliveEnemies -= 1
                                
                                if aliveEnemies == 0 {
                                    time?.invalidate()
                                    aliveEnemies = 15
                                    score.text = String(currentScore)
                                    score.isHidden = false
                                    scoreLabel.isHidden = false
                                    gameOver.isHidden = false
                                    self.endButton.isHidden = false
                                    self.endButton.isEnabled = true
                                    self.buttonLeft.isHidden = true
                                    self.buttonRight.isHidden = true
                                    
                                    
                                    break outer
                                }
                                break inner
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc private func shootTimer(sender: UIButton){
        self.Shoot()
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(shootTimer(sender:)), userInfo: nil, repeats: false)
    }
        
    
    
    @objc private func moveShipLeft(sender: UIButton){
        if buttonLeft.isHighlighted && shipImageView.frame.minX>self.view.bounds.minX{
            shipImageView.center = CGPoint(x: shipImageView.center.x-3, y: shipImageView.center.y)
            perform(#selector(moveShipLeft(sender:)), with: nil, afterDelay: 0.015)
        }
    }
 
    @objc private func moveShipRight(sender: UIButton){
        if buttonRight.isHighlighted && shipImageView.frame.maxX<self.view.bounds.width{
            shipImageView.center = CGPoint(x: shipImageView.center.x+3, y: shipImageView.center.y)
            perform(#selector(moveShipRight(sender:)), with: nil, afterDelay: 0.015)
        }
    }
  
 

}
