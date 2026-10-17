import SwiftUI
import UIKit

struct ContentView: View {
    @State private var results: [String] = []
    @State private var report = ""

    var body: some View {
        NavigationView {
            List {
                Section("Информация об устройстве") {
                    row("Версия iOS", UIDevice.current.systemVersion)
                    row("Устройство", UIDevice.current.model)
                }

                Section("Локальные тесты") {
                    Button("Запустить тесты") {
                        runTests()
                    }

                    ForEach(results, id: \.self) { result in
                        Text(result)
                            .font(.footnote)
                    }
                }

                Section("Отчёт") {
                    if report.isEmpty {
                        Text("Сначала запусти тесты.")
                            .foregroundColor(.secondary)
                    } else {
                        ShareLink(
                            item: report,
                            subject: Text("iOS Security Toolkit Report")
                        ) {
                            Label("Экспортировать отчёт", systemImage: "square.and.arrow.up")
                        }
                    }
                }

                Section {
                    Text("Тесты работают только внутри собственного контейнера приложения. Они не обходят защиту iOS и не читают данные других приложений.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Security Toolkit")
        }
    }

    private func row(_ title: String, _ value: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
    }

    private func runTests() {
        results = []
        var lines: [String] = []

        lines.append("iOS Security Toolkit")
        lines.append("Версия iOS: \(UIDevice.current.systemVersion)")
        lines.append("Модель: \(UIDevice.current.model)")
        lines.append("Дата: \(Date())")
        lines.append("")

        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("security-toolkit-test.txt")

        do {
            let sample = "Локальный тест записи и чтения пройден."
            try sample.write(to: url, atomically: true, encoding: .utf8)
            let loaded = try String(contentsOf: url, encoding: .utf8)

            if loaded == sample {
                results.append("✅ Запись и чтение файла: успешно")
                lines.append("Запись и чтение файла: успешно")
            } else {
                results.append("❌ Проверка содержимого: ошибка")
                lines.append("Проверка содержимого: ошибка")
            }
        } catch {
            results.append("❌ Работа с файлом: \(error.localizedDescription)")
            lines.append("Работа с файлом: \(error.localizedDescription)")
        }

        results.append("ℹ️ Тесты выполняются внутри приложения.")
        lines.append("Тесты ограничены контейнером приложения.")

        report = lines.joined(separator: "\n")
    }
}