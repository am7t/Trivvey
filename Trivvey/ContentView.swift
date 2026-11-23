import SwiftUI

struct ContentView: View {
    @State private var questions: [Question] = []
    @State private var selectedAnswers: [UUID: String] = [:]

    private var score: Int {
        questions.filter { selectedAnswers[$0.id] == $0.answer }.count
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("TRIVVEY")
                                .font(.caption.weight(.bold))
                                .tracking(2)
                                .foregroundStyle(.secondary)
                            Text("Quick trivia,\nbig brain energy.")
                                .font(.system(size: 27, weight: .bold, design: .rounded))
                        }
                        Spacer()
                        Image(systemName: "lightbulb.max.fill")
                            .font(.system(size: 34))
                            .foregroundStyle(.yellow)
                    }
                    .padding(.vertical, 12)
                    .listRowBackground(Color.clear)
                }

                Section {
                    HStack {
                        Label("\(selectedAnswers.values.filter { !$0.isEmpty }.count) played", systemImage: "checkmark.circle")
                        Spacer()
                        Text("\(score) correct")
                            .fontWeight(.semibold)
                            .foregroundStyle(.green)
                    }
                    .font(.subheadline)
                }

                Section("Pick a question") {
                    ForEach(questions) { question in
                        NavigationLink {
                            QuestionView(
                                question: question,
                                selectedAnswer: answerBinding(for: question.id)
                            )
                        } label: {
                            QuestionRow(
                                question: question,
                                selectedAnswer: answerBinding(for: question.id)
                            )
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Trivvey")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        questions.shuffle()
                    } label: {
                        Image(systemName: "shuffle")
                    }
                    .accessibilityLabel("Shuffle questions")
                }
            }
            .onAppear(perform: loadQuestions)
        }
        .tint(.green)
    }

    private func loadQuestions() {
        guard questions.isEmpty,
              let url = Bundle.main.url(forResource: "questions", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decodedQuestions = try? JSONDecoder().decode([Question].self, from: data) else {
            return
        }
        questions = decodedQuestions
    }

    private func answerBinding(for id: UUID) -> Binding<String> {
        Binding(
            get: { selectedAnswers[id] ?? "" },
            set: { selectedAnswers[id] = $0 }
        )
    }
}

private struct QuestionRow: View {
    let question: Question
    @Binding var selectedAnswer: String

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: selectedAnswer.isEmpty ? "questionmark.circle.fill" : "checkmark.circle.fill")
                .font(.title2)
                .foregroundStyle(selectedAnswer.isEmpty ? .orange : .green)
            Text(question.question)
                .font(.body.weight(.medium))
                .foregroundStyle(.primary)
        }
        .padding(.vertical, 5)
    }
}
