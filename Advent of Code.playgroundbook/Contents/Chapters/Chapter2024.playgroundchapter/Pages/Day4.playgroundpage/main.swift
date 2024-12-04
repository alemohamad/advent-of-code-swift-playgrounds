/*:
 # --- Day 4: Ceres Search ---
 
 [https://adventofcode.com/2024/day/4]()
 
 "Looks like the Chief's not here. Next!" One of The Historians pulls out a device and pushes the only button on it. After a brief flash, you recognize the interior of the [Ceres monitoring station](https://adventofcode.com/2019/day/10)!
 
 As the search for the Chief continues, a small Elf who lives on the station tugs on your shirt; she'd like to know if you could help her with her **word search** (your puzzle input). She only has to find one word: `XMAS`.
 
 This word search allows words to be horizontal, vertical, diagonal, written backwards, or even overlapping other words. It's a little unusual, though, as you don't merely need to find one instance of `XMAS` - you need to find **all of them**. Here are a few ways `XMAS` might appear, where irrelevant characters have been replaced with `.`:
 
 * Callout(Example with irrelevant characters:):
   `..X...`  
   `.SAMX.`  
   `.A..A.`  
   `XMAS.S`  
   `.X....`  
 
 The actual word search will be full of letters instead.
 
 * Callout(For example:):
   `MMMSXXMASM`  
   `MSAMXMSMSA`  
   `AMXSXMAAMM`  
   `MSAMASMSMX`  
   `XMASAMXAMM`  
   `XXAMMXXAMA`  
   `SMSMSASXSS`  
   `SAXAMASAAA`  
   `MAMMMXMMMM`  
   `MXMXAXMASX`  
 
 In this word search, `XMAS` occurs a total of `18` times; here's the same word search again, but where letters not involved in any `XMAS` have been replaced with `.`:
 
 * Callout(For example:):
   `....XXMAS.`  
   `.SAMXMS...`  
   `...S..A...`  
   `..A.A.MS.X`  
   `XMASAMX.MM`  
   `X.....XA.A`  
   `S.S.S.S.SS`  
   `.A.A.A.A.A`  
   `..M.M.M.MM`  
   `.X.X.XMASX`  
 
 Take a look at the little Elf's word search. **How many times does XMAS appear?**
 */
import Foundation

let input = readLinesFromFile(fileName: "Day4")

func countOccurrences(of word: String, in grid: [String]) -> Int {
    let matrix = grid.map { Array($0) }
    let numRows = matrix.count
    let numCols = matrix[0].count
    let wordLength = word.count
    let wordChars = Array(word)
    
    let directions = [
        (0, 1),  // Right
        (0, -1), // Left
        (1, 0),  // Down
        (-1, 0), // Up
        (1, 1),  // Diagonal down-right
        (1, -1), // Diagonal down-left
        (-1, 1), // Diagonal up-right
        (-1, -1) // Diagonal up-left
    ]
    
    var totalCount = 0
    
    func isWordFound(at row: Int, col: Int, dir: (Int, Int)) -> Bool {
        for i in 0..<wordLength {
            let newRow = row + dir.0 * i
            let newCol = col + dir.1 * i
            if newRow < 0 || newRow >= numRows || newCol < 0 || newCol >= numCols {
                return false
            }
            if matrix[newRow][newCol] != wordChars[i] {
                return false
            }
        }
        return true
    }
    
    for row in 0..<numRows {
        for col in 0..<numCols {
            for dir in directions {
                if isWordFound(at: row, col: col, dir: dir) {
                    totalCount += 1
                }
            }
        }
    }
    
    return totalCount
}

countOccurrences(of: "XMAS", in: input)
/*:
 ## --- Part Two ---
 
 The Elf looks quizzically at you. Did you misunderstand the assignment?
 
 Looking for the instructions, you flip over the word search to find that this isn't actually an `XMAS` puzzle; it's an `X-MAS` puzzle in which you're supposed to find two `MAS` in the shape of an `X`. One way to achieve that is like this:
 
 * Callout(Example:):
   `M.S`  
   `.A.`  
   `M.S`  

 Irrelevant characters have again been replaced with `.` in the above diagram. Within the `X`, each `MAS` can be written forwards or backwards.
 
 Here's the same example from before, but this time all of the `X-MAS`es have been kept instead:
 
 * Callout(Example from before, updated:):
   `.M.S......`  
   `..A..MSMS.`  
   `.M.S.MAA..`  
   `..A.ASMSM.`  
   `.M.S.M....`  
   `..........`  
   `S.S.S.S.S.`  
   `.A.A.A.A..`  
   `M.M.M.M.M.`  
   `..........`  
 
 In this example, an `X-MAS` appears `9` times.
 
 Flip the word search from the instructions back over to the word search side and try again. **How many times does an `X-MAS` appear?**
 */

func countXMAS(in grid: [String]) -> Int {
    let matrix = grid.map { Array($0) }
    let numRows = matrix.count
    let numCols = matrix[0].count

    var count = 0

    func isCompleteXMAS(centerRow: Int, centerCol: Int) -> Bool {
        let topLeft = (centerRow - 1, centerCol - 1)
        let topRight = (centerRow - 1, centerCol + 1)
        let bottomLeft = (centerRow + 1, centerCol - 1)
        let bottomRight = (centerRow + 1, centerCol + 1)

        // Ensure all positions are within bounds
        guard
            topLeft.0 >= 0, topLeft.1 >= 0,
            topRight.0 >= 0, topRight.1 < numCols,
            bottomLeft.0 < numRows, bottomLeft.1 >= 0,
            bottomRight.0 < numRows, bottomRight.1 < numCols
        else {
            return false
        }

        // Extract characters for the X-MAS shape
        let center = matrix[centerRow][centerCol]
        let topLeftChar = matrix[topLeft.0][topLeft.1]
        let topRightChar = matrix[topRight.0][topRight.1]
        let bottomLeftChar = matrix[bottomLeft.0][bottomLeft.1]
        let bottomRightChar = matrix[bottomRight.0][bottomRight.1]

        let forwardXMAS = (
            topLeftChar == "M" && topRightChar == "S" &&
            bottomLeftChar == "M" && bottomRightChar == "S" &&
            center == "A"
        )
        let backwardXMAS = (
            topLeftChar == "S" && topRightChar == "M" &&
            bottomLeftChar == "S" && bottomRightChar == "M" &&
            center == "A"
        )
        let topSSBottomMM = (
            topLeftChar == "S" && topRightChar == "S" &&
            bottomLeftChar == "M" && bottomRightChar == "M" &&
            center == "A"
        )
        let topMMBottomSS = (
            topLeftChar == "M" && topRightChar == "M" &&
            bottomLeftChar == "S" && bottomRightChar == "S" &&
            center == "A"
        )

        return forwardXMAS || backwardXMAS || topSSBottomMM || topMMBottomSS
    }

    for row in 1..<numRows-1 {
        for col in 1..<numCols-1 {
            if isCompleteXMAS(centerRow: row, centerCol: col) {
                count += 1
            }
        }
    }

    return count
}

countXMAS(in: input)

/*:
 ## --- Sample Test ---
 */

func checkSolution() {
    let exampleInput = [
        "MMMSXXMASM",
        "MSAMXMSMSA",
        "AMXSXMAAMM",
        "MSAMASMSMX",
        "XMASAMXAMM",
        "XXAMMXXAMA",
        "SMSMSASXSS",
        "SAXAMASAAA",
        "MAMMMXMMMM",
        "MXMXAXMASX"
    ]
    
    let resultXMAS = countOccurrences(of: "XMAS", in: exampleInput)
    let expectedXMASOutput = 18
    
    if resultXMAS == expectedXMASOutput {
        print("✅ Test Passed! Your solution is correct.")
    } else {
        print("❌ Test Failed. Expected \(expectedXMASOutput), but got \(resultXMAS).")
    }
    
    let resultX_MAS = countXMAS(in: exampleInput)
    let expectedX_MASOutput = 9
    
    if resultX_MAS == expectedX_MASOutput {
        print("✅ Test Passed! Your solution is correct.")
    } else {
        print("❌ Test Failed. Expected \(expectedX_MASOutput), but got \(resultX_MAS).")
    }
}

checkSolution()
