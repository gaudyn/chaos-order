//
//  ViewController.swift
//  Order&Chaos
//
//  Created by Gniewomir Gaudyn on 14.09.2018.
//  Copyright © 2018 Gniewomir Gaudyn. All rights reserved.
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
    
    enum tileStates: Int {
        case empty
        case color1
        case color2
    }
    
    var boardTilesViewArray = [UIView]()
    var boardTilesViewReference =  [UIView:Int]()
    var boardTilesStates = [tileStates]()
    
    
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
        
        resetTiles()
        
        gameEnded = false
        
        turnAndWinLabel.text = NSLocalizedString("Turn", value: "Turn:", comment: "Whose turn it is")
        UIView.animate(withDuration: 0.2, animations: {
            self.currentPlayerView.backgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        })
        if currentPlayer == false{
            changePlayer()
        }
    }
    
    func resetTiles(){
        emptyTiles = 36
        
        for index in 0..<boardSize*boardSize{
            boardTilesViewArray[index].backgroundColor = .white
            boardTilesStates[index] = tileStates.empty
        }
    }
    
    @objc func generateBoard(){
        
        for i in 0..<boardSize*boardSize{
            
            let tile = getTileView(index: i)
            
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.colorTile(tapGesture:)))
            
            tile.addGestureRecognizer(tapRecognizer)
            
            boardTilesViewArray.append(tile)
            boardTilesViewReference[tile] = i
            
            boardTilesStates.append(tileStates.empty)
            
            BoardView.addSubview(tile)
        }
    }
    
    func getTileWidth() -> Double{
        let parentViewWidth = UIScreen.main.bounds.width-16
        let padding = 4
        let availableSpace = parentViewWidth - CGFloat((boardSize-1)*padding)
        return Double(availableSpace/CGFloat(boardSize))
    }
    
    func getTileView(index: Int) -> UIView{
        let newTile = UIView()
        let tileWidth = getTileWidth()
        
        newTile.frame = CGRect(x: Double((index%boardSize))*(tileWidth+4), y: Double((index/boardSize))*(tileWidth+4), width: tileWidth, height: tileWidth)
        
        newTile.backgroundColor = .white
        newTile.layer.cornerRadius = 5
        
        return newTile
    }
    
    @objc func colorTile(tapGesture recognizer: UITapGestureRecognizer){
        if boardTilesStates[boardTilesViewReference[recognizer.view!]!] != tileStates.empty || gameEnded{
            return
        }
        
        
        if(currentColor == true){
            
            boardTilesStates[boardTilesViewReference[recognizer.view!]!] = .color1
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
            
            boardTilesStates[boardTilesViewReference[recognizer.view!]!] = tileStates.color2
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
            setWinnerLabel(orderWins: true)
            
        }else if emptyTiles == 0{
            setWinnerLabel(orderWins: false)
            
        }else{
            changePlayer()
        }
    }
    
    func setWinnerLabel(orderWins: Bool){
        if orderWins{
            currentPlayerLabel.text = NSLocalizedString("Order", value: "Order", comment: "The order player")
        }else{
            currentPlayerLabel.text = NSLocalizedString("Chaos", value: "Chaos", comment: "The opposite of order")
        }
        turnAndWinLabel.text = NSLocalizedString("Winner", value: "Winner:", comment: "And the winner is")
        UIView.animate(withDuration: 0.2, animations: {
            self.currentPlayerView.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        })
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
                if tileState == tileStates.empty {
                    max_con = 0
                    continue
                }
                if color == tileState.rawValue{
                    max_con = max_con + 1
                }else{
                    color = tileState.rawValue
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
                if tileState == .empty {
                    max_con = 0
                    continue
                }
                if color == tileState.rawValue{
                    max_con = max_con + 1
                }else{
                    color = tileState.rawValue
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
            if tileState == .empty {
                max_con = 0
                x+=dir
                y+=1
                continue
            }
            if color == tileState.rawValue{
                max_con = max_con + 1
            }else{
                color = tileState.rawValue
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

