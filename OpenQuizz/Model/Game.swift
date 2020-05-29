//
//  Game.swift
//  OpenQuizz
//
//  Created by Lomig Enfroy on 26/05/2020.
//  Copyright © 2020 Lomig Enfroy. All rights reserved.
//

import Foundation

class Game {
    enum State {
        case ongoing, over
    }

    var score: Int = 0
    var state: State = .ongoing

    private var questions: [Question] = []
    private var currentIndex = 0

    var currentQuestion: Question { questions[currentIndex] }

    func answerCurrentQuestion(with answer: Bool) {
        if answer == currentQuestion.isCorrect { score += 1 }

        nextQuestion()
    }

    func refresh() {
        score = 0
        currentIndex = 0
        state = .over

        QuestionManager.shared.get { questions in
            self.questions = questions
            self.state = .ongoing

            let name = Notification.Name(rawValue: "QuestionsLoaded")
            let notification = Notification(name: name)
            NotificationCenter.default.post(notification)
        }
    }

    private func nextQuestion() {
        currentIndex += 1
        if currentIndex == questions.count { finishGame() }
    }

    private func finishGame() {
        state = .over
    }
}
