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

    var body: some View {
        VStack {
            Text("W O R D L E")
                .foregroundColor(Color(.systemGray))
                .font(.system(size: 50, weight: .bold, design: .rounded))
                
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
            
            Button(action: {
                withAnimation {
                    viewModel.newGame()
                }
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(.blue)
                        .frame(width: 120, height: 40, alignment: .center)
                    Text("New Game")
                        .foregroundColor(Color(.systemGray5))
                }
            })
            .padding(8)
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

