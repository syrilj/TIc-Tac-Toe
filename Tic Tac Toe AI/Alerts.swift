//
//  Alerts.swift
//  Tic Tac Toe AI
//
//  Created by Syril Jacob on 2022-10-21.
//

import SwiftUI

struct AlertItem: Identifiable{
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContext{
    static let humanWin = AlertItem(title: Text("You Win!"),
                                    message: Text("You a genius"),
                                    buttonTitle: Text("Try your luck?"))
    static let computerWin = AlertItem(title: Text("You Lose!"),
                                    message: Text("Rematch?"),
                                    buttonTitle: Text("you lost to a computer :("))
    static let draw = AlertItem(title: Text("Yikes!"),
                                    message: Text("Guess your better than I thought"),
                                    buttonTitle: Text("Lets go again?"))
                        
}
