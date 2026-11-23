import SwiftUI

struct QuestionView: View {
    let question: Question
    @Binding var selectedAnswer: String

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack {
                Text("YOUR QUESTION")
                    .font(.caption.weight(.bold))
                    .tracking(1.5)
                    .foregroundStyle(.secondary)
                Spacer()
                Image(systemName: "sparkles")
                    .foregroundStyle(.orange)
            }

            Text(question.question)
                .font(.system(size: 29, weight: .bold, design: .rounded))
                .fixedSize(horizontal: false, vertical: true)

            VStack(spacing: 12) {
                ForEach(question.choices, id: \.0) { letter, choice in
                    Button {
                        guard selectedAnswer.isEmpty else { return }
                        selectedAnswer = letter
                    } label: {
                        HStack(spacing: 14) {
                            Text(letter)
                                .font(.headline.weight(.bold))
                                .frame(width: 34, height: 34)
                                .background(.quaternary, in: Circle())
                            Text(choice)
                                .font(.body.weight(.medium))
                            Spacer()
                            if selectedAnswer == letter {
                                Image(systemName: letter == question.answer ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .foregroundStyle(letter == question.answer ? .green : .red)
                            }
                        }
                        .padding(14)
                        .foregroundStyle(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
                        .overlay {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(selectedAnswer == letter ? Color.green.opacity(0.6) : Color.clear, lineWidth: 1.5)
                        }
                    }
                    .buttonStyle(.plain)
                    .disabled(!selectedAnswer.isEmpty)
                }
            }

            if !selectedAnswer.isEmpty {
                Label(
                    selectedAnswer == question.answer ? "That's right!" : "Not quite — the answer is \(question.choices.first { $0.0 == question.answer }?.1 ?? "")",
                    systemImage: selectedAnswer == question.answer ? "checkmark.seal.fill" : "arrow.uturn.backward.circle.fill"
                )
                .font(.headline)
                .foregroundStyle(selectedAnswer == question.answer ? .green : .orange)
                .fixedSize(horizontal: false, vertical: true)
            } else {
                Text("Choose the answer you think is right.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(22)
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("Question")
        .navigationBarTitleDisplayMode(.inline)
    }
}
