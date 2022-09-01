import UIKit
import GameplayKit

//print(arc4random() % 6)
//print(arc4random_uniform(6))

//print(GKRandomSource.sharedRandom().nextInt())
//print(GKRandomSource.sharedRandom().nextInt(upperBound: 6))

//MARK: low randomize high performance
//let linearRandom = GKLinearCongruentialRandomSource()
//linearRandom.nextInt(upperBound: 50)

//MARK: Goldilocks random
//let arc4 = GKARC4RandomSource()
//// to dropping first 1024 numbers
//arc4.dropValues(1024)
//
//arc4.nextInt(upperBound: 20)

//MARK: Maxi randomize low performance
//let mersenne = GKMersenneTwisterRandomSource()
//mersenne.nextInt(upperBound: 20)

//MARK: Dice

// Six-sided dice
//let d6 = GKRandomDistribution.d6()
//d6.nextInt()

// 20-sided dice
//let d20 = GKRandomDistribution.d20()
//d20.nextInt()

// 11539-sided dice
//let crazy = GKRandomDistribution(lowestValue: 1, highestValue: 11539)
//crazy.nextInt()

// One particular random source
//let rand = GKMersenneTwisterRandomSource()
//let distribution = GKRandomDistribution(randomSource: rand, lowestValue: 10, highestValue: 20)
//print(distribution.nextInt())

//MARK: Random without repeats
//let shuffled = GKShuffledDistribution.d6()
//print(shuffled.nextInt())
//print(shuffled.nextInt())
//print(shuffled.nextInt())
//print(shuffled.nextInt())
//print(shuffled.nextInt())
//print(shuffled.nextInt())

// Gaussian Distribution
//let gauss = GKGaussianDistribution(lowestValue: 1, highestValue: 20)
//print(gauss.nextInt())
//print(gauss.nextInt())
//print(gauss.nextInt())
//print(gauss.nextInt())
//print(gauss.nextInt())
//print(gauss.nextInt())
//print(gauss.nextInt())
//print(gauss.nextInt())

//MARK: Shuffling array
//let lotteryBalls = [Int](1...49)
//let shuffledBalls = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: lotteryBalls)
//print(shuffledBalls[0])
//print(shuffledBalls[1])
//print(shuffledBalls[2])
//print(shuffledBalls[3])
//print(shuffledBalls[4])
//print(shuffledBalls[5])

//MARK: Predictably random using seed value
//let fixedLotteryBalls = [Int](1...49)
//let fixedShuffledBalls = GKMersenneTwisterRandomSource(seed: 1001).arrayByShufflingObjects(in: fixedLotteryBalls)
//print(fixedShuffledBalls[0])
//print(fixedShuffledBalls[1])
//print(fixedShuffledBalls[2])
//print(fixedShuffledBalls[3])
//print(fixedShuffledBalls[4])
//print(fixedShuffledBalls[5])
