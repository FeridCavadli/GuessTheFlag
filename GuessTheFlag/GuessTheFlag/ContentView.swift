//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Ferid on 20.04.25.
//

import SwiftUI


struct FlagImage: View {

    var ImageArray: String
    var body: some View{
        Image(ImageArray)
            .clipShape(.capsule)
            .shadow(radius: 5)
    }
}

struct changeTitles: ViewModifier{
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundStyle(.blue)
    }
}


extension View{
    func standartTitle() -> some View {
        modifier(changeTitles())
    }
}


struct ContentView: View {

    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)

    @State private var showingScore = false
    @State private var limitOfEight = false
    @State private var callCount = 0

    @State private var flagTitle = ""
    @State private var userScore = 0

    var body: some View {
        ZStack{
            LinearGradient(colors: [.black, .green], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack{
                Text("Guess the flag")
                    .standartTitle()
                Spacer()
                VStack(spacing: 15){
                    VStack{
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))

                        Text(countries[correctAnswer])
                            .standartTitle()
                    }

                    ForEach(0..<3){ number in
                        Button{
                            flagTapped(number)
                        }label: {
                            FlagImage(ImageArray: countries[number])
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                .padding()
                .padding()
                Spacer()
                Spacer()
                Text("Score: \(userScore)")
                    .standartTitle()
            }

        }.alert(flagTitle, isPresented: $showingScore){
            Button("Continue", action: askQuestion)
        }message: {
            Text("Your score is \(userScore)")
        }
        .alert("You've reached limit of 5 questions", isPresented: $limitOfEight) {
                    Button("Reset", action: resetGame)
                } message: {
                    Text("Your score  is \(userScore) out of 5")
                }
    }

    func flagTapped(_ num: Int) {
            callCount += 1

            if num == correctAnswer {
                flagTitle = "True"
                userScore += 1
            } else {
                flagTitle = "Wrong, that is the flag of \(countries[num])"
            }

            switch callCount{
            case 5:
                limitOfEight = true
            default:
                showingScore = true
            }
    }

    func askQuestion(){
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }

    func resetGame(){
            callCount = 0
            userScore = 0
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)
            limitOfEight = false
            }

}

#Preview {
    ContentView()
}

