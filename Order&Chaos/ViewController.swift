//
//  ViewController.swift
//  Order&Chaos
//
//  Created by Administrator on 14.09.2018.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var BoardView: UIView!
    @IBOutlet weak var currentPlayerView: UIView!
    @IBOutlet weak var turnAndWinLabel: UILabel!
    @IBOutlet weak var currentPlayerLabel: UILabel!
    
    @IBOutlet weak var color1Button: UIView!
    @IBOutlet weak var color2Button: UIView!
    
    var currentPlayer:Bool = false
    var currentColor:Bool = true
    
    var gameEnded:Bool = false
    
    let boardSize = 6
    var emptyTiles = 36
    
    var boardTilesArray = [UIView]()
    var boardTilesDict =  [UIView:Int]()
    var boardTilesStates = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentPlayerView.layer.cornerRadius = 10
        color1Button.layer.cornerRadius = 10
        color2Button.layer.cornerRadius = 10
        
        generateBoard()
        
        changePlayer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeToColor1(_ sender: UITapGestureRecognizer) {
        
        currentColor = true
        
        UIView.animate(withDuration: 0.5, animations: {
            self.color1Button.frame = CGRect(x: 0, y: 0, width: (self.color1Button.superview!.bounds.width-8)*0.66, height: self.color1Button.superview!.bounds.height)
            self.color2Button.frame = CGRect(x: (self.color2Button.superview!.bounds.width-8)*0.66+8, y: 0, width: (self.color2Button.superview!.bounds.width-8)*0.33, height: self.color2Button.superview!.bounds.height)
        })
        
        
    }
    
    @IBAction func changeToColor2(_ sender: UITapGestureRecognizer) {
        currentColor = false
        UIView.animate(withDuration: 0.5, animations: {
            self.color1Button.frame = CGRect(x: 0, y: 0, width: (self.color1Button.superview!.bounds.width-8)*0.33, height: self.color1Button.superview!.bounds.height)
            self.color2Button.frame = CGRect(x: (self.color2Button.superview!.bounds.width-8)*0.33+8, y: 0, width: (self.color2Button.superview!.bounds.width-8)*0.66, height: self.color2Button.superview!.bounds.height)
        })
        
        
    }
    
    @IBAction func restart(_ sender: UIBarButtonItem) {
        
        emptyTiles = 36
        
        for index in 0..<boardSize*boardSize{
            boardTilesArray[index].backgroundColor = .white
            boardTilesStates[index] = 0
        }
        
        gameEnded = false
        
        turnAndWinLabel.text = NSLocalizedString("Turn", value: "Turn:", comment: "Whose turn it is")
        UIView.animate(withDuration: 0.2, animations: {
            self.currentPlayerView.backgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        })
        if currentPlayer == false{
            changePlayer()
        }
    }
    
    @objc func generateBoard(){
        
        let tileWidth = Double((BoardView.bounds.width-CGFloat((boardSize-1)*4))/CGFloat(boardSize))
        
        for index in 0..<boardSize*boardSize{
            let tile = UIView()
            tile.frame = CGRect(x: Double((index%boardSize))*(tileWidth+4), y: Double((index/boardSize))*(tileWidth+4), width: tileWidth, height: tileWidth)
            tile.backgroundColor = .white
            tile.layer.cornerRadius = 5
            
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.colorTile(tapGesture:)))
            
            tile.addGestureRecognizer(tapRecognizer)
            
            boardTilesArray.append(tile)
            boardTilesDict[tile] = index
            
            boardTilesStates.append(0)
            
            BoardView.addSubview(tile)
        }
    }
    
    @objc func colorTile(tapGesture recognizer: UITapGestureRecognizer){
        if boardTilesStates[boardTilesDict[recognizer.view!]!] != 0 || gameEnded{
            return
        }
        if(currentColor == true){
            
            boardTilesStates[boardTilesDict[recognizer.view!]!] = 1
            emptyTiles-=1
            UIView.animate(withDuration: 0.1, animations: {
                recognizer.view?.backgroundColor = self.color1Button.backgroundColor
                recognizer.view?.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }, completion: { (success: Bool) in
                UIView.animate(withDuration: 0.1, animations: {
                    recognizer.view?.transform = CGAffineTransform.identity
                })
            })
        }else{
            
            boardTilesStates[boardTilesDict[recognizer.view!]!] = 2
            emptyTiles-=1
            UIView.animate(withDuration: 0.1, animations: {
                recognizer.view?.backgroundColor = self.color2Button.backgroundColor
                recognizer.view?.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }, completion: { (success: Bool) in
                UIView.animate(withDuration: 0.1, animations: {
                    recognizer.view?.transform = CGAffineTransform.identity
                })
            })
        }
        if checkBoard(){
            turnAndWinLabel.text = NSLocalizedString("Winner", value: "Winner:", comment: "And the winner is")
            currentPlayerLabel.text = NSLocalizedString("Order", value: "Order", comment: "The order player")
            UIView.animate(withDuration: 0.2, animations: {
                self.currentPlayerView.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            })
            
        }else if emptyTiles == 0{
            turnAndWinLabel.text = NSLocalizedString("Winner", value: "Winner:", comment: "And the winner is")
            currentPlayerLabel.text = NSLocalizedString("Chaos", value: "Chaos", comment: "The opposite of order")
            UIView.animate(withDuration: 0.2, animations: {
                self.currentPlayerView.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            })
            
        }else{
            changePlayer()
        }
    }
    
    @objc func changePlayer(){
        if currentPlayer == true {
            
            UIView.animate(withDuration: 0.2, animations: {
                self.currentPlayerView.backgroundColor = #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1)
            })
            currentPlayerLabel.text = NSLocalizedString("Chaos", value: "Chaos", comment: "The opposite of order")
            currentPlayer = false
        }else{
            
            UIView.animate(withDuration: 0.2, animations: {
                self.currentPlayerView.backgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
            })
            currentPlayerLabel.text = NSLocalizedString("Order", value: "Order", comment: "The order player")
            currentPlayer = true
        }
    }
    
    @objc func checkBoard() -> Bool{
        // checking rows
        for y in 0..<boardSize{
            var max_con:Int = 0
            var color:Int = 1
            for x in 0..<boardSize{
                let tileState = boardTilesStates[x+y*boardSize]
                if tileState == 0 {
                    max_con = 0
                    continue
                }
                if tileState == color{
                    max_con = max_con + 1
                }else{
                    color = tileState
                    max_con = 1
                }
                if max_con >= 5{
                    gameEnded = true
                    return true
                }
            }
        }
        // checking columns
        for x in 0..<boardSize{
            var max_con:Int = 0
            var color:Int = 1
            for y in 0..<boardSize{
                let tileState = boardTilesStates[x+y*boardSize]
                if tileState == 0 {
                    max_con = 0
                    continue
                }
                if tileState == color{
                    max_con = max_con + 1
                }else{
                    color = tileState
                    max_con = 1
                }
                if max_con >= 5{
                    gameEnded = true
                    return true
                }
            }
        }
        
        // checking right diagonals
        
        if checkDiagonal(X: 0, Y: 1, dir: 1){
            return true
        }
        if checkDiagonal(X: 0, Y: 0, dir: 1){
            return true
        }
        if checkDiagonal(X: 1, Y: 0, dir: 1){
            return true
        }
        
        // checking left diagonals
        
        if checkDiagonal(X: 4, Y: 0, dir: -1){
            return true
        }
        if checkDiagonal(X: 5, Y: 0, dir: -1){
            return true
        }
        if checkDiagonal(X: 5, Y: 1, dir: -1){
            return true
        }
        
        return false
    }
    
    func checkDiagonal(X: Int,Y: Int,dir: Int)->Bool{
        var x = X
        var y = Y
        var max_con:Int = 0
        var color:Int = 1
        while (x != -1 && y != -1 && x != boardSize && y != boardSize){

            let tileState = boardTilesStates[x+y*boardSize]
            if tileState == 0 {
                max_con = 0
                x+=dir
                y+=1
                continue
            }
            if tileState == color{
                max_con = max_con + 1
            }else{
                color = tileState
                max_con = 1
            }
            if max_con >= 5{
                gameEnded = true
                return true
            }
            x+=dir
            y+=1
        }
        return false
    }


}

