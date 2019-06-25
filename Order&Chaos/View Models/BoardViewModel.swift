//
//  BoardViewModel.swift
//  Order&Chaos
//
//  Created by Administrator on 25/06/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

import Foundation

class BoardViewModel{
    
    var currentPlayer: Box<Bool> = Box(true)
    var currentColor = true
    
    var gameEnded: Box<Bool> = Box(false)
    
    let boardSize = 6
    var emptyTiles = 36
    
    enum tileStates: Int{
        case empty
        case color1
        case color2
    }
    
    var boardTilesStates: [Box<tileStates>] = [Box(tileStates.empty)]

    func changePlayer(){
        currentPlayer.value = !currentPlayer.value
    }
    
    func changeColor(selectedColor: Bool){
        currentColor = selectedColor
    }
    
    func resetGame(){
        self.resetBoard()
        
        gameEnded.value = false
        
        currentPlayer.value = true
    }
    
    func resetBoard(){
        emptyTiles = 36
        
        for index in 0..<boardSize*boardSize{
            boardTilesStates[index].value = tileStates.empty
        }
    }
    
    func generateBoard(){
        for _ in 0..<boardSize*boardSize{
            boardTilesStates.append(Box(tileStates.empty))
        }
    }
    
    func checkBoard() -> Bool{
        if emptyTiles == 0{
            currentPlayer.value = false
            gameEnded.value = true
            return true
        }
        
        // checking rows
        for y in 0..<boardSize{
            var max_con:Int = 0
            var color:Int = 1
            for x in 0..<boardSize{
                let tileState = boardTilesStates[x+y*boardSize].value
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
                    currentPlayer.value = true
                    gameEnded.value = true
                    return true
                }
            }
        }
        // checking columns
        for x in 0..<boardSize{
            var max_con:Int = 0
            var color:Int = 1
            for y in 0..<boardSize{
                let tileState = boardTilesStates[x+y*boardSize].value
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
                    currentPlayer.value = true
                    gameEnded.value = true
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
            
            let tileState = boardTilesStates[x+y*boardSize].value
            
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
                currentPlayer.value = true
                gameEnded.value = true
                return true
            }
            x+=dir
            y+=1
        }
        return false
    }
    
}

extension BoardViewModel{
    func getBoardSize()->Int{
        return self.boardSize
    }
    
    func getCurrentPlayer()->Bool{
        return self.currentPlayer.value
    }
    
    func getEmptyTiles()->Int{
        return self.emptyTiles
    }
    
    func setTileColor(index: Int, color: tileStates){
        self.boardTilesStates[index].value = color
        self.emptyTiles-=1
    }
    
    func getTileColor(index: Int) -> tileStates{
        return boardTilesStates[index].value
    }
}
