import Foundation

public func readDay1Data() -> (leftList: [Int], rightList: [Int]) {
    var leftList = [Int]()
    var rightList = [Int]()
    
    if let fileURL = Bundle.main.url(forResource: "Day1", withExtension: "txt") {
        do {
            let fileContent = try String(contentsOf: fileURL)
            let lines = fileContent.split(separator: "\n")
            for line in lines {
                let values = line.split(separator: " ").compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
                if values.count == 2 {
                    leftList.append(values[0])
                    rightList.append(values[1])
                }
            }
        } catch {
            print("Error reading file: \(error)")
        }
    } else {
        print("File not found.")
    }
    
    return (leftList, rightList)
}
