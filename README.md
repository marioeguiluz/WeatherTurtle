# VVRR Architecture
## What is this
Implementation of a simple weather app as an example to show a easy and clean architecture done in Swift.
Lets see how some architecture concepts/patterns can be applied to a real world app.

## What will I learn with this
This architecture example tries to show how to have:
* Clean ViewControllers by using ViewModels, ViewStates & Navigators to keep Single Responsabilities clear and separated.
* A Data Layer that is able to fetch your data from the network (or other services like the file-system) plus a cache that allows you to return the cached data while refreshing it in the background in a easy to understand way (no RxSwift or other libraries needed, just some lines of native code and completion blocks).
* A clean flow in each layer of the architecture thanks to the use of enums.
* A clear use of Dependency injection & Protocols to keep your code testable.
* A smart use of Generics and Decodable to have a very clean and effective Network Layer with almost no boiler plate code (we all hate it right).

## General Overview
![VVRR Architecture](http://www.marioeguiluz.com/img/portfolio/VVRR%20Architecture.png)

### Is this the best architecture?
No, of course not. There are tons of amazing architectures all around (VIPER, MVVM, MVP, etc). This is just my way to do teach people how to achieve a decent app with some architecture patterns. I tried to keep it clean while still being easy to understand for new developers.

### "I dont like it", "That is wrong", "This is not how I would do that"
Open a pull request, I will be happy to improve this project.

### "You are coping MVXXX or YYYY architecture!"
This is a mix of concepts that I like and that I think that are easy to apply to an iOS project. I haven't invented anything. Software has been the same since 1970, with its trends are cycles. This is just an exercise to learn and share things from here and there in a practical example. 
