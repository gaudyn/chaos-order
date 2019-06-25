//
//  ViewController.swift
//  Order&Chaos
//
//  Created by Gniewomir Gaudyn on 14.09.2018.
//  Copyright © 2018 Gniewomir Gaudyn. All rights reserved.
//

import UIKit

class BoardViewController: UIViewController {
    
    @IBOutlet weak var BoardView: UIView!
    @IBOutlet weak var currentPlayerView: UIView!
    @IBOutlet weak var turnAndWinLabel: UILabel!
    @IBOutlet weak var currentPlayerLabel: UILabel!
    
    @IBOutlet weak var color1Button: UIView!
    @IBOutlet weak var color2Button: UIView!
    
    var boardTilesViewArray = [UIView]()
    var boardTilesViewReference =  [UIView:Int]()
    
    let viewModel = BoardViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentPlayerView.layer.cornerRadius = 10
        color1Button.layer.cornerRadius = 10
        color2Button.layer.cornerRadius = 10
        
        generateBoard()
        
        viewModel.currentPlayer.bind({
            [self] in
            if $0 == true{
                UIView.animate(withDuration: 0.2, animations: {
                    self.currentPlayerView.backgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
                })
                self.currentPlayerLabel.text = NSLocalizedString("Order", value: "Order", comment: "Order player")
                
            }else{
                UIView.animate(withDuration: 0.2, animations: {
                    self.currentPlayerView.backgroundColor = #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1)
                })
                self.currentPlayerLabel.text = NSLocalizedString("Chaos", value: "Chaos", comment: "Chaos player")
            }
        })
        
        for i in 0..<viewModel.getBoardSize()*viewModel.getBoardSize(){
            viewModel.boardTilesStates[i].bind({
                [self] in
                switch $0{
                case .empty:
                    self.boardTilesViewArray[i].backgroundColor = .white
                    break
                case .color1:
                    self.boardTilesViewArray[i].backgroundColor = self.color1Button.backgroundColor
                    break
                case .color2:
                    self.boardTilesViewArray[i].backgroundColor = self.color2Button.backgroundColor
                }
            })
        }
        
        viewModel.gameEnded.bind {
            [self] in
            if $0 == true{
                self.turnAndWinLabel.text = NSLocalizedString("Winner", value: "Winner:", comment: "And the winner is")
                UIView.animate(withDuration: 0.2, animations: {
                    self.currentPlayerView.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                })
                if self.viewModel.getCurrentPlayer() == true{
                    self.currentPlayerLabel.text = NSLocalizedString("Order", value: "Order", comment: "The order player")
                }else{
                    self.currentPlayerLabel.text = NSLocalizedString("Chaos", value: "Chaos", comment: "The opposite of order")
                }
            }
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeToColor1(_ sender: UITapGestureRecognizer) {
        
        viewModel.changeColor(selectedColor: true)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.color1Button.frame = CGRect(x: 0, y: 0, width: (self.color1Button.superview!.bounds.width-8)*0.66, height: self.color1Button.superview!.bounds.height)
            self.color2Button.frame = CGRect(x: (self.color2Button.superview!.bounds.width-8)*0.66+8, y: 0, width: (self.color2Button.superview!.bounds.width-8)*0.33, height: self.color2Button.superview!.bounds.height)
        })
        
        
    }
    
    @IBAction func changeToColor2(_ sender: UITapGestureRecognizer) {
        
        viewModel.changeColor(selectedColor: false)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.color1Button.frame = CGRect(x: 0, y: 0, width: (self.color1Button.superview!.bounds.width-8)*0.33, height: self.color1Button.superview!.bounds.height)
            self.color2Button.frame = CGRect(x: (self.color2Button.superview!.bounds.width-8)*0.33+8, y: 0, width: (self.color2Button.superview!.bounds.width-8)*0.66, height: self.color2Button.superview!.bounds.height)
        })
        
        
    }
    
    @IBAction func restart(_ sender: UIBarButtonItem) {
        
        viewModel.resetGame()
        
        turnAndWinLabel.text = NSLocalizedString("Turn", value: "Turn:", comment: "Whose turn it is")
        UIView.animate(withDuration: 0.2, animations: {
            self.currentPlayerView.backgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        })
    }
    
    @objc func generateBoard(){
        
        let boardSize = viewModel.getBoardSize()
        
        for i in 0..<boardSize*boardSize{
            
            let tile = getTileView(index: i)
            
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.colorTile(tapGesture:)))
            
            tile.addGestureRecognizer(tapRecognizer)
            
            boardTilesViewArray.append(tile)
            boardTilesViewReference[tile] = i
            
            
            BoardView.addSubview(tile)
        }
        
        viewModel.generateBoard()
    }
    
    func getTileWidth() -> Double{
        let parentViewWidth = UIScreen.main.bounds.width-16
        let padding = 4
        
        let boardSize = viewModel.getBoardSize()
        
        let availableSpace = parentViewWidth - CGFloat((boardSize-1)*padding)
        return Double(availableSpace/CGFloat(boardSize))
    }
    
    func getTileView(index: Int) -> UIView{
        let newTile = UIView()
        let tileWidth = getTileWidth()
        
        let boardSize = viewModel.getBoardSize()
        
        newTile.frame = CGRect(x: Double((index%boardSize))*(tileWidth+4), y: Double((index/boardSize))*(tileWidth+4), width: tileWidth, height: tileWidth)
        
        newTile.backgroundColor = .white
        newTile.layer.cornerRadius = 5
        
        return newTile
    }
    
    @objc func colorTile(tapGesture recognizer: UITapGestureRecognizer){
        
        let tileIndex = boardTilesViewReference[recognizer.view!]!
        
        if
           viewModel.getTileColor(index: tileIndex) != .empty || viewModel.gameEnded.value{
            return
        }
        
        let currentColor = viewModel.currentColor
        
        
        if(currentColor == true){
            
            viewModel.setTileColor(index: tileIndex, color: .color1)
            
            UIView.animate(withDuration: 0.1, animations: {
                recognizer.view?.backgroundColor = self.color1Button.backgroundColor
                recognizer.view?.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }, completion: { (success: Bool) in
                UIView.animate(withDuration: 0.1, animations: {
                    recognizer.view?.transform = CGAffineTransform.identity
                })
            })
        }else{
            
            viewModel.setTileColor(index: tileIndex, color: .color2)
            UIView.animate(withDuration: 0.1, animations: {
                recognizer.view?.backgroundColor = self.color2Button.backgroundColor
                recognizer.view?.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }, completion: { (success: Bool) in
                UIView.animate(withDuration: 0.1, animations: {
                    recognizer.view?.transform = CGAffineTransform.identity
                })
            })
        }
        if !viewModel.checkBoard(){
            viewModel.changePlayer()
        }
    }
    
}

