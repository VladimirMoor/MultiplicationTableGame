//
//  ContentView.swift
//  MultiplicationTableGame
//
//  Created by Vladimir on 28.05.2021.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTable = 2
    @State private var amountOfQuestion = 5
    @State private var isSelected = [true, false, false, false]
    @State private var gameFieldShow = false
    @State private var a = 0
    @State private var b = 0
    let numOfQuestions = ["5", "10", "20", "All"]
    
    
    var body: some View {
        NavigationView {
            VStack {
            Form {
                
                Section {
                    Text("Which multiplication table do you want to practice?")
                    Stepper(value: $selectedTable, in: 2...12)
                    {
                        Text("\(selectedTable)")
                            .frame(maxWidth: .infinity)
                            .frame(height: 40)
                            .font(.title)
                            .background(Color.blue )
                            .foregroundColor(.primary)
                            .cornerRadius(10)
                            .padding()
                    }

                }
                
                Section {
                Text("How many question you want to be asked?")
                HStack {
                    ForEach(0..<numOfQuestions.count) { num in
                        Button(action: {
                            
                            resetSelection()
                            isSelected[num] = true
                            
                            if num != 3 {
                                amountOfQuestion = Int(numOfQuestions[num])!
                            } else {
                                amountOfQuestion = (selectedTable - 1) * (selectedTable - 1)
                            }
                            
                            
                        })  {
                            Text("\(numOfQuestions[num])")
                                .frame(maxWidth: .infinity)
                                .frame(height: 60)
                                .background(isSelected[num] ? Color.red : Color.blue )
                                .foregroundColor(.primary)
                                .cornerRadius(10)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        
                    }
                }
                }
            }.navigationTitle("TableGame")
            
                NavigationLink(
                    destination: GameFieldView(table: $selectedTable, amountOfQuestions: $amountOfQuestion),
                    label: {
                            Text("Start game")
                    })
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color.green)
                    .foregroundColor(.primary)
                    .cornerRadius(10)
                    .padding()
                Spacer()
            }
        }
    }
    
    func resetSelection() {
        isSelected = [false, false, false, false]
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().preferredColorScheme(.light)
    }
}

struct GameFieldView: View {
    
    @Binding var table: Int
    @Binding var amountOfQuestions: Int
    
    @State private var a = 0
    @State private var b = 0
    @State private var correctAnswer = 0
    @State private var answers: [Int] = [0,0,0]
    @State private var showCorrect = false
    @State private var showNotCorrect = false
    @State private var disableButtons = false
    @State private var isCorrect = ""

    
    var body: some View {
        VStack {

        Text("Questions left: \(amountOfQuestions)")
            .font(.title)
        Spacer()
        
            
        Text("\(a) x \(b) = ??? ")
            .frame(maxWidth: .infinity)
            .frame(height: 70)
            .font(.custom("ChalkboardSE-Bold", size: 35))
            .background(Color.blue)
            .cornerRadius(10)
            .padding()

        Text("Choose correct answer:")
            .padding()
            .font(.title)

        HStack {
            ForEach(0..<answers.count) { num in
                Button(action: {
                    
                    if answers[num] == (a * b) {

                        isCorrect = "Yeaaa!"
                        disableButtons = true
                        
                    } else {
                        
                        
                        isCorrect = "Oups! No"
                        disableButtons = true
                        
                    }
                    
                }, label: {
                    Text("\(answers[num])")
                        .frame(maxWidth: .infinity)
                        .frame(height: 70)
                        .font(.custom("ChalkboardSE-Bold", size: 30))
                        .foregroundColor(.primary)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding()
                        
                })
                .disabled(disableButtons)
            }
            }
            
            Spacer()
            
            VStack {
                
            Text(isCorrect)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .font(.custom("ChalkboardSE-Bold", size: 25))
                .foregroundColor(.primary)
                .cornerRadius(10)
                .padding()
                
            
            Button(action: { newQuestion() }, label: {
                Text("Next question ->")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .font(.custom("ChalkboardSE-Bold", size: 25))
                    .foregroundColor(.primary)
                    .background(Color.green)
                    .cornerRadius(10)
                    .padding()
                    .opacity(disableButtons ? 1 : 0)
                    .disabled(disableButtons)
            })
                
            }
            
          Spacer()
            
            
        }
        .onAppear(perform: {
            newQuestion()
        })
        
    }
    
    func newQuestion() {
        
        isCorrect = ""
        disableButtons = false
        a = (2...table).randomElement() ?? 0
        b = (2...table).randomElement() ?? 0
        correctAnswer = a * b
        
        var minMock: Int { (a * b) - 3 }
        var maxMock: Int { (a * b) + 5 }
        let mockAnswer1 = (minMock..<correctAnswer).randomElement() ?? 0
        let mockAnswer2 = ((correctAnswer + 1)..<maxMock).randomElement() ?? 0
        
        answers = [correctAnswer, mockAnswer1, mockAnswer2].shuffled()
    }
    
}

