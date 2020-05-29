//
//  ViewController.swift
//  OpenQuizz
//
//  Created by Lomig Enfroy on 26/05/2020.
//  Copyright © 2020 Lomig Enfroy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let name = Notification.Name(rawValue: "QuestionsLoaded")
        NotificationCenter.default.addObserver(self, selector: #selector(questionsLoaded), name: name, object: nil)

        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragQuestionView(_:)))
        questionView.addGestureRecognizer(panGestureRecognizer)

        startNewGame()
    }

    // View
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var questionView: QuestionView!

    // Model
    var game: Game = Game()

    @IBAction func didTapNewGameButton() {
        startNewGame()
    }

    @objc func questionsLoaded() {
        activityIndicator.isHidden = true
        newGameButton.isHidden = false
        questionView.title = game.currentQuestion.title
    }

    @objc func dragQuestionView(_ sender: UIPanGestureRecognizer) {
        if game.state == .over { return }

        switch sender.state {
        case .began, .changed:
            transformQuestionViewWith(gesture: sender)
        case .cancelled, .ended:
            answerQuestion()
        default:
            return
        }
    }


    private func startNewGame() {
        activityIndicator.isHidden = false
        newGameButton.isHidden = true

        questionView.title = "Loading..."
        questionView.style = .standard
        
        scoreLabel.text = "0 / 10"
        game.refresh()
    }

    private func transformQuestionViewWith(gesture: UIPanGestureRecognizer) {
        let translation: CGPoint = gesture.translation(in: questionView)
        let translationTransform: CGAffineTransform = CGAffineTransform(translationX: translation.x, y: 0)

        let screenWidth: CGFloat = UIScreen.main.bounds.width
        let translationPercent = translation.x / (screenWidth / 2)
        let rotationAngle = (CGFloat.pi / 6) * translationPercent
        let rotationTransform: CGAffineTransform = CGAffineTransform(rotationAngle: rotationAngle)

        let transform = translationTransform.concatenating(rotationTransform)
        questionView.transform = transform

        if translation.x > 0 {
            questionView.style = .correct
        } else {
            questionView.style = .incorrect
        }
    }

    private func answerQuestion() {
        switch questionView.style {
        case .correct:
            game.answerCurrentQuestion(with: true)
        case .incorrect:
            game.answerCurrentQuestion(with: false)
        case .standard:
            break
        }

        scoreLabel.text = "\(game.score) / 10"

        animateCard()
    }

    private func animateCard() {
        let screenWidth: CGFloat = UIScreen.main.bounds.width

        var translationTransform: CGAffineTransform
        if questionView.style == .correct {
            translationTransform = CGAffineTransform(translationX: screenWidth, y: 0)
        } else {
            translationTransform = CGAffineTransform(translationX: -screenWidth, y: 0)
        }

        UIView.animate(
            withDuration: 0.3,
            animations: { self.questionView.transform = translationTransform },
            completion: { (success) in
                if success { self.nextQuestion() }
            }
        )
    }

    private func nextQuestion() {
        questionView.transform = .identity
        questionView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        questionView.style = .standard

        switch game.state {
        case .ongoing:
            questionView.title = game.currentQuestion.title
        case .over:
            questionView.title = "Game Over"
        }

        UIView.animate(
            withDuration: 0.4,
            delay: 0.0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.5,
            options: [],
            animations: { self.questionView.transform = .identity },
            completion: nil
        )
    }
}

