//
//  WordleBoard.swift
//  Wordle
//
//  Created by Mischa Hildebrand on 14.01.22.
//

import Combine
import SwiftUI

struct WordleBoard: View {

    @StateObject private var viewModel = WordleBoardViewModel()
    @FocusState private var textFieldActive: Bool
    @State private var showingHint: Bool = false

    var body: some View {
        VStack {
            
            VStack {
                Text("W O R D L E")
                    .foregroundColor(Color(.systemGray))
                .font(.system(size: 50, weight: .bold, design: .rounded))
                Text("Cloned with SwiftUI!")
                    .font(.system(size: 22, weight: .thin, design: .rounded))
                    //.italic()
                    .foregroundColor(Color(.systemGray2))
            }
                
            ZStack {
                TextField("", text: $viewModel.string)
                    .keyboardType(.asciiCapable)
                    .disableAutocorrection(true)
                    .focused($textFieldActive)
                    .opacity(0)
                    .onChange(of: viewModel.string) { [oldString = viewModel.string] newString in
                        viewModel.validateString(newString, previousString: oldString)
                    }
                MatrixGrid(
                    width: viewModel.width,
                    height: viewModel.height,
                    spacing: 8
                ) { row, column in
                    LetterBox(
                        letter: viewModel.letters[row][column],
                        evaluation: viewModel.evaluations[row][column]
                    )
                }
                .frame(maxHeight: .infinity)
                .onTapGesture {
                    textFieldActive.toggle()
                }
            }
//            Button("New Game") {
//                withAnimation {
//                    viewModel.newGame()
//                }
//            }
            
            VStack {
                let hint = viewModel.hintProvider.hasHinted ? String(viewModel.hintProvider.hint).uppercased().separate(every: 1, with: " ") : " "
                Text(hint)
                    .foregroundColor(Color(.systemGray))
                    .bold()
                    .transition(.slide.combined(with: .opacity))
                    .id(hint)
                    .font(.system(size: 24, design: .rounded))
                
                Button(action: {
                    showingHint.toggle()
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(Color(.systemRed))
                            .frame(width: 120, height: 40, alignment: .center)
                        Text("Hint")
                            .foregroundColor(Color(.systemGray5))
                            .font(.system(size: 18, design: .rounded))
                    }
                })
                    .alert(isPresented: $showingHint) {
                        let hint = viewModel.hintProvider.provideHint()
                        let hintsRemaining = viewModel.hintProvider.maxHints - viewModel.hintProvider.hintsGiven
                        let msgText = hintsRemaining > 0 ? "\(hintsRemaining) hints left!" : ""
                        return Alert(title: Text(hint), message: Text(msgText), dismissButton: .default(Text("Got it!")))
                    }
                .padding(8)
                
                Button(action: {
                    withAnimation {
                        viewModel.newGame()
                    }
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(Color(.systemBlue))
                            .frame(width: 120, height: 40, alignment: .center)
                        Text("New Game")
                            .foregroundColor(Color(.systemGray5))
                            .font(.system(size: 18, design: .rounded))
                    }
                })
                .padding(8)
            }
        }
        .padding([.horizontal], 32)
        .padding([.vertical], 24)
        .background(Color.appBackground)
        .alert("You won! 🎉", isPresented: $viewModel.solved) {
            Button("OK", role: .none) {
                viewModel.solved = false
            }
        }
        .alert("You lost! 🥺", isPresented: $viewModel.lost) {
            Button("OK", role: .none) {
                viewModel.lost = false
            }
        } message: {
            Text("The word was:\n" + viewModel.solution.uppercased())
        }
        .onChange(of: viewModel.solved) { solved in
            if solved {
                vibrate(type: .success)
            }
        }
        .onChange(of: viewModel.lost) { lost in
            if lost {
                vibrate(type: .error)
            }
        }
    }
    
    private func vibrate(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VStack {
                WordleBoard().environment(\.colorScheme, .light)
            }
            VStack {
                WordleBoard().environment(\.colorScheme, .dark)
            }
        }
    }
}

