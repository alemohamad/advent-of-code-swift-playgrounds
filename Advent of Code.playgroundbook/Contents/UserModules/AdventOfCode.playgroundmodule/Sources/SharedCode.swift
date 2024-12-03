import Foundation

public func readDataFromFile(fileName: String) -> String? {
    if let fileURL = Bundle.main.url(forResource: fileName, withExtension: "txt") {
        do {
            return try String(contentsOf: fileURL)
        } catch {
            print("Error reading file: \(error)")
        }
    } else {
        print("File not found.")
    }
    return nil
}

public func readLocationsDataFromFile(fileName: String) -> (leftList: [Int], rightList: [Int]) {
    var leftList = [Int]()
    var rightList = [Int]()
    
    // Use readDataFromFile to get the file content
    if let fileContent = readDataFromFile(fileName: fileName) {
        let lines = fileContent.split(separator: "\n")
        for line in lines {
            let values = line.split(separator: " ").compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
            if values.count == 2 {
                leftList.append(values[0])
                rightList.append(values[1])
            }
        }
    }
    
    return (leftList, rightList)
}
