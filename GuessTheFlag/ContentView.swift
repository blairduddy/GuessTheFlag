//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Blair Duddy on 2023-05-15.
//

import SwiftUI

struct FlagImage: View {
    var country: String
   
    var body: some View {
        Image(country)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}

struct ContentView: View {
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var userScore = 0
    @State private var scoreMessage = ""
    @State private var currentQuestion = 0
    @State private var finalAlert = false
    
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            scoreMessage = "You nailed it! That's \(countries[number])!"
            userScore += 1
        } else {
            scoreTitle = "Incorrect"
            scoreMessage = "Not quite right, that looks more like the flag of \(countries[number])..."
        }
        
        currentQuestion += 1
        if currentQuestion >= 8 {
            finalAlert = true
            return
        }
        
        showingScore = true
    }
    
    func askQuestion() {
        if currentQuestion < 8 {
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)
        }
    }
    
    func resetGame() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        userScore = 0
        currentQuestion = 0
        finalAlert = false
    }
    
    
    var body: some View {
        
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(.white)
                
                VStack (spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .font(.subheadline.weight(.heavy))
                            .foregroundStyle(.secondary)
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    Spacer()
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagImage(country: countries[number])
                        }
                    }
                    .alert(scoreTitle, isPresented: $showingScore) {
                        Button("Continue", action: askQuestion)
                    } message: {
                        Text(scoreMessage)
                    }
                    .alert("Game Over", isPresented: $finalAlert) {
                        Button("Start Again?", action: resetGame)
                    } message: {
                        Text("Your final score is \(userScore) out of 8!")
                    }
                    
                    
                    Spacer()
                    
                    Text("Score: \(userScore)")
                        .font(.title.bold())
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .padding()
        }
    }
}
    
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
