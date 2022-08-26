//
//  ViewController.swift
//  Project34
//
//  Created by Sergii Miroshnichenko on 24.08.2022.
//
import GameplayKit
import UIKit

class ViewController: UIViewController {
    var placedChips = [[UIView]]()
    var board: Board!
    var strategist: GKMinmaxStrategist!
    
    var AIMode = true
    
    @IBOutlet var columnButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Players", style: .plain, target: self, action: #selector(gameModeChoose)), UIBarButtonItem(title: "Сomplexity", style: .plain, target: self, action: #selector(complexityModeChoose))]
        
        for _ in 0 ..< Board.width {
            placedChips.append([UIView]())
        }
        
        if AIMode {
            strategist = GKMinmaxStrategist()
            strategist.maxLookAheadDepth = 7
            strategist.randomSource = GKARC4RandomSource()
//        strategist.randomSource = nil
        }

        resetBoard()
    }
    
    @objc func gameModeChoose() {
        let alert = UIAlertController(title: "Game Mode", message: "Choose game mode", preferredStyle: .alert)
        let onePlayer = UIAlertAction(title: "play with AI", style: .default) { [unowned self] (action) in
            AIMode = true
        }
        let twoPlayers = UIAlertAction(title: "play with friend", style: .default) { [unowned self] (action) in
            AIMode = false
        }

        alert.addAction(onePlayer)
        alert.addAction(twoPlayers)
        present(alert, animated: true)
    }
    
    @objc func complexityModeChoose() {
        let alert = UIAlertController(title: "Complexity Mode", message: "Choose complexity mode", preferredStyle: .alert)
        let simple = UIAlertAction(title: "simple", style: .default) { [unowned self] (action) in
            strategist.maxLookAheadDepth = 2
        }
        let medium = UIAlertAction(title: "medium", style: .default) { [unowned self] (action) in
            strategist.maxLookAheadDepth = 7
        }
        let hard = UIAlertAction(title: "hard", style: .default) { [unowned self] (action) in
            strategist.maxLookAheadDepth = 9
        }
        
        alert.addAction(simple)
        alert.addAction(medium)
        alert.addAction(hard)
        
        present(alert, animated: true)
    }
    
    func resetBoard() {
        board = Board()
        
        if AIMode {
            strategist.gameModel = board
        }
        
        updateUI()
        
        for i in 0 ..< placedChips.count {
            for chip in placedChips[i] {
                chip.removeFromSuperview()
            }

            placedChips[i].removeAll(keepingCapacity: true)
        }
    }
    
    func addChip(inColumn column: Int, row: Int, color: UIColor) {
        let button = columnButtons[column]
        let size = min(button.frame.width, button.frame.height / 6)
        let rect = CGRect(x: 0, y: 0, width: size, height: size)

        if (placedChips[column].count < row + 1) {
            let newChip = UIView()
            newChip.frame = rect
            newChip.isUserInteractionEnabled = false
            newChip.backgroundColor = color
            newChip.layer.cornerRadius = size / 2
            newChip.center = positionForChip(inColumn: column, row: row)
            newChip.transform = CGAffineTransform(translationX: 0, y: -800)
            view.addSubview(newChip)

            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                newChip.transform = CGAffineTransform.identity
            })

            placedChips[column].append(newChip)
        }
    }
    
    func positionForChip(inColumn column: Int, row: Int) -> CGPoint {
        let button = columnButtons[column]
        let size = min(button.frame.width, button.frame.height / 6)

        let xOffset = button.frame.midX
        var yOffset = button.frame.maxY - size / 2
        yOffset -= size * CGFloat(row)
        return CGPoint(x: xOffset, y: yOffset)
    }

    @IBAction func makeMove(_ sender: UIButton) {
        let column = sender.tag

        if let row = board.nextEmptySlot(in: column) {
            board.add(chip: board.currentPlayer.chip, in: column)
            addChip(inColumn: column, row: row, color: board.currentPlayer.color)
            continueGame()
        }
    }
    
    func updateUI() {
        title = "\(board.currentPlayer.name)'s Turn"
        
        if AIMode {
            if board.currentPlayer.chip == .black {
                startAIMove()
            }
        }
    }
    
    func continueGame() {
        // 1 We create a gameOverTitle optional string set to nil.
        var gameOverTitle: String? = nil

        // 2 If the game is over or the board is full, gameOverTitle is updated to include the relevant status message.
        if board.isWin(for: board.currentPlayer) {
            gameOverTitle = "\(board.currentPlayer.name) Wins!"
        } else if board.isFull() {
            gameOverTitle = "Draw!"
        }

        // 3 If gameOverTitle is not nil (i.e., the game is won or drawn), show an alert controller that resets the board when dismissed.
        if gameOverTitle != nil {
            let alert = UIAlertController(title: gameOverTitle, message: nil, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Play Again", style: .default) { [unowned self] (action) in
                resetBoard()
            }

            alert.addAction(alertAction)
            present(alert, animated: true)

            return
        }

        // 4 Otherwise, change the current player of the game, then call updateUI() to set the navigation bar title
        board.currentPlayer = board.currentPlayer.opponent
        updateUI()
    }
    
    func columnForAIMove() -> Int? {
        if let aiMove = strategist.bestMove(for: board.currentPlayer) as? Move {
            return aiMove.column
        }

        return nil
    }
    
    func makeAIMove(in column: Int) {
        columnButtons.forEach { $0.isEnabled = true }
        navigationItem.leftBarButtonItem = nil
        
        if let row = board.nextEmptySlot(in: column) {
            board.add(chip: board.currentPlayer.chip, in: column)
            addChip(inColumn: column, row:row, color: board.currentPlayer.color)

            continueGame()
        }
    }
    
    func startAIMove() {
        
        columnButtons.forEach { $0.isEnabled = false }

        let spinner = UIActivityIndicatorView(style: .large)
        spinner.startAnimating()

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: spinner)
        
        DispatchQueue.global().async { [unowned self] in
            let strategistTime = CFAbsoluteTimeGetCurrent()
            guard let column = self.columnForAIMove() else { return }
            let delta = CFAbsoluteTimeGetCurrent() - strategistTime

            let aiTimeCeiling = 1.0
            let delay = aiTimeCeiling - delta

            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.makeAIMove(in: column)
            }
        }
    }
    
}

