/*:
 # --- Day 3: Mull It Over ---
 
 [https://adventofcode.com/2024/day/3]()
 
 "Our computers are having issues, so I have no idea if we have any Chief Historians in stock! You're welcome to check the warehouse, though," says the mildly flustered shopkeeper at the [North Pole Toboggan Rental Shop](https://adventofcode.com/2020/day/2). The Historians head out to take a look.
 
 The shopkeeper turns to you. "Any chance you can see why our computers are having issues again?"
 
 The computer appears to be trying to run a program, but its memory (your puzzle input) is **corrupted**. All of the instructions have been jumbled up!
 
 It seems like the goal of the program is just to **multiply some numbers**. It does that with instructions like `mul(X,Y)`, where `X` and `Y` are each 1-3 digit numbers. For instance, `mul(44,46)` multiplies `44` by `46` to get a result of `2024`. Similarly, `mul(123,4)` would multiply `123` by `4`.
 
 However, because the program's memory has been corrupted, there are also many invalid characters that should be **ignored**, even if they look like part of a `mul` instruction. Sequences like `mul(4*`, `mul(6,9!`, `?(12,34)`, or `mul ( 2 , 4 )` do **nothing**.
 
 For example, consider the following section of corrupted memory:
 
 `xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))`
 
 Only the four highlighted sections are real `mul` instructions. Adding up the result of each instruction produces `161` (`2*4 + 5*5 + 11*8 + 8*5`).
 
 Scan the corrupted memory for uncorrupted `mul` instructions. **What do you get if you add up all of the results of the multiplications?**
 */
import Foundation
import RegexBuilder

let input = readDataFromFile(fileName: "Day3")

func extractValidMulInstructions(from memory: String) -> [(Int, Int)] {
    let regex = Regex {
        "mul("
        Capture(OneOrMore(.digit))
        ","
        Capture(OneOrMore(.digit))
        ")"
    }
    
    return memory.matches(of: regex).compactMap { match in
        if let x = Int(match.1), let y = Int(match.2) {
            return (x, y)
        }
        return nil
    }
}

if let input {
    let validInstructions = extractValidMulInstructions(from: input)
    let resultTotal = validInstructions.map { $0.0 * $0.1 }.reduce(0, +)
    print(resultTotal)
}
/*:
 ## --- Part Two ---
 
 As you scan through the corrupted memory, you notice that some of the conditional statements are also still intact. If you handle some of the uncorrupted conditional statements in the program, you might be able to get an even more accurate result.
 
 There are two new instructions you'll need to handle:
 
 - The `do()` instruction **enables** future `mul` instructions.
 - The `don't()` instruction **disables** future `mul` instructions.
 
 Only the **most recent** `do()` or `don't()` instruction applies. At the beginning of the program, mul instructions are **enabled**.
 
 For example:
 
 `xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))`
 
 This corrupted memory is similar to the example from before, but this time the `mul(5,5)` and `mul(11,8)` instructions are **disabled** because there is a `don't()` instruction before them. The other mul instructions function normally, including the one at the end that gets re-**enabled** by a `do()` instruction.
 
 This time, the sum of the results is `48` (`2*4 + 8*5`).
 
 Handle the new instructions; **what do you get if you add up all of the results of just the enabled multiplications?**
 */
func calculateEnabledMulSum(from memory: String) -> Int {
    let mulRegex = Regex {
        "mul("
        Capture(OneOrMore(.digit))
        ","
        Capture(OneOrMore(.digit))
        ")"
    }
    let doRegex = Regex { "do()" }
    let dontRegex = Regex { "don't()" }
    
    var isEnabled = true
    var totalSum = 0
    var tempMemory = memory
    
    while !tempMemory.isEmpty {
        do {
            let mulMatch = try? mulRegex.firstMatch(in: tempMemory).map {
                (type: "mul", range: $0.range, x: Int($0.1) ?? 0, y: Int($0.2) ?? 0)
            }
            let doMatch = try? doRegex.firstMatch(in: tempMemory).map {
                (type: "do", range: $0.range, x: 0, y: 0)
            }
            let dontMatch = try? dontRegex.firstMatch(in: tempMemory).map {
                (type: "don't", range: $0.range, x: 0, y: 0)
            }
            
            let allMatches = [mulMatch, doMatch, dontMatch].compactMap { $0 }
            
            guard let firstMatch = allMatches.min(by: { $0.range.lowerBound < $1.range.lowerBound }) else {
                break
            }
            
            switch firstMatch.type {
            case "mul":
                if isEnabled {
                    totalSum += (firstMatch.x ?? 0) * (firstMatch.y ?? 0)
                }
            case "do":
                isEnabled = true
            case "don't":
                isEnabled = false
            default:
                break
            }
            
            tempMemory.removeSubrange(tempMemory.startIndex..<firstMatch.range.upperBound)
        } catch {
            print("Error while matching regex: \(error)")
            break
        }
    }
    
    return totalSum
}

if let input {
    calculateEnabledMulSum(from: input)
}

/*:
 ## --- Sample Test ---
 */

func checkSolution() {
    let exampleInput = """
xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))
"""
    let validInstructions = extractValidMulInstructions(from: exampleInput)
    
    let resultTotal = validInstructions.map { $0.0 * $0.1 }.reduce(0, +)
    let expectedTotalOutput = 161
    
    if resultTotal == expectedTotalOutput {
        print("✅ Test Passed! Your solution is correct.")
    } else {
        print("❌ Test Failed. Expected \(expectedTotalOutput), but got \(resultTotal).")
    }
    
    // ---
    
    let exampleEnabledInput = """
xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))
"""
    let resultEnabledTotal = calculateEnabledMulSum(from: exampleEnabledInput)
    let expectedEnabledTotalOutput = 48
    
    if resultEnabledTotal == expectedEnabledTotalOutput {
        print("✅ Test Passed! Your solution is correct.")
    } else {
        print("❌ Test Failed. Expected \(expectedEnabledTotalOutput), but got \(resultEnabledTotal).")
    }
}

checkSolution()
