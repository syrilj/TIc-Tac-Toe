//
//  ContentView.swift
//  Tic Tac Toe AI
//
//  Created by Syril Jacob on 2022-10-21.
//

import SwiftUI
import UIKit




struct ContentView: View {
    
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible()),]
    
    @State private var moves: [Move?] = Array(repeating: nil, count: 9)
    @State private var isGameboardDisabled = false
    @State private var alertItem: AlertItem?
    
    var body: some View {
        GeometryReader{geometry in
            VStack{
                Spacer()

                LazyVGrid(columns: columns, spacing: 5){
                    ForEach(0..<9){ i in
                        ZStack{
                            Circle()
                                .foregroundColor(.red).opacity(0.5)
                                .frame(width: geometry.size.width/3 - 15, height:geometry.size.width/3 - 15)
                            Image(systemName: moves[i]?.indicator ?? "")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                        }
                        .onTapGesture{
                            if isSquaredOccupied(in: moves, forIndex: i){return}
                            moves[i] = Move(player:  .human , boardIndex: i)
                            
                            // check for win conditon or draw
                            if checkWinCondition(for: .human, in: moves){
                                alertItem = AlertContext.humanWin
                                return
                            }
                            
                            if CheckForDraw(in: moves){
                                alertItem = AlertContext.draw
                                return
                            }
                            isGameboardDisabled = true
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                                let computerPosition = determineComputerMovePosition(in: moves)
                                moves[computerPosition] = Move(player:  .computer , boardIndex: computerPosition)
                                isGameboardDisabled = false
                                
                                if checkWinCondition(for: .computer, in: moves){
                                    alertItem = AlertContext.computerWin
                                    return
                                }
                                if CheckForDraw(in: moves){
                                    alertItem = AlertContext.draw
                                    return
                                }
                            }
                        }
                    }
                }
                Spacer()
            }
            .disabled(isGameboardDisabled)
            .padding()
            .alert(item: $alertItem, content: { alertItem in
                Alert(title: alertItem.title, message: alertItem.message, dismissButton: .default(alertItem.buttonTitle, action: { resetGame() }))
            })
        }
    }
    func isSquaredOccupied(in moves: [Move?], forIndex index: Int )-> Bool{
        return moves.contains(where: { $0?.boardIndex == index})
    }
    // easy ai randomly
    // if AI can win then win
    // If AI cant win then block
    // if AI cant block then take middle square
    // if AI cant take middle square, take random avaliable square
    func determineComputerMovePosition(in moves: [Move?]) -> Int{
        // if AI can win then win
        let winPatterns: Set<Set<Int>> = [[0,1,2], [3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
        let computerMoves = moves.compactMap { $0 }.filter { $0.player == .computer }
        let computerPositions = Set(computerMoves.map { $0.boardIndex })
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(computerPositions)
            
            if winPositions.count == 1{
                let isAvaliable = !isSquaredOccupied(in: moves, forIndex: winPositions.first!)
                if isAvaliable { return winPositions.first! }
            }
        }
        // If AI cant win then block
        let humanMoves = moves.compactMap { $0 }.filter { $0.player == .human }
        let humanPositions = Set(humanMoves.map { $0.boardIndex })
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(humanPositions)
            
            if winPositions.count == 1{
                let isAvaliable = !isSquaredOccupied(in: moves, forIndex: winPositions.first!)
                if isAvaliable { return winPositions.first! }
            }
        }
        // if AI cant block then take middle square
        let centerSquare = 4
        if !isSquaredOccupied(in: moves, forIndex: centerSquare){
            return centerSquare
        }
        
        // if AI cant take middle square, take random avaliable square
        var movePosition = Int.random(in: 0..<9)
        
        while isSquaredOccupied(in: moves, forIndex: movePosition){
            movePosition = Int.random(in: 0..<9)
        }
        return movePosition
    }
    func checkWinCondition(for player: Player, in moves: [Move?]) -> Bool{
        
        // using set to compare against set of win patternsii
        let winPatterns: Set<Set<Int>> = [[0,1,2], [3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
        
        let playerMoves = moves.compactMap { $0 }.filter { $0.player == player }
        let playerPositions = Set(playerMoves.map { $0.boardIndex })
        // iterating through win patterns and seeing if it is a subset of player positions
        for pattern in winPatterns where pattern.isSubset(of: playerPositions){
            return true
        }
        return false
    }
    // running compact map to remove all nils if the count of that is 9 that means game is over
    func CheckForDraw(in moves: [Move?]) -> Bool {
        return moves.compactMap { $0 }.count == 9
    }
    
    func resetGame() {
        moves = Array(repeating: nil, count: 9)
    }
}

enum Player{
    case human, computer
}

struct Move{
    let player: Player
    let boardIndex: Int
    
    var indicator: String{
        return player == .human ? "xmark" : "circle"
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
