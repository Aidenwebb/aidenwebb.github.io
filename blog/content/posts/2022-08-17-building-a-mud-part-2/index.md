---
title: "Learning C# - Building a Mud Part 2"
date: 2022-08-17T15:18:57+01:00
draft: true
# weight: 1
# aliases: ["/first"]
tags: ["C-Sharp", "Programming", "Learning", "Building a MUD"]
author: "Aiden Arnkels-Webb"
# author: ["Me", "You"] # multiple authors
showToc: true
TocOpen: false
hidemeta: false
#comments: false
#description: "Desc Text."
#canonicalURL: "https://canonical.url/to/page"
url: "/posts/learning-c-sharp-building-a-mud-part-2"
disableHLJS: false # to disable highlightjs
disableShare: false
hideSummary: false
searchHidden: false
ShowReadingTime: true
ShowBreadCrumbs: true
ShowPostNavLinks: true
ShowWordCount: true
ShowRssButtonInSectionTermList: true
UseHugoToc: true
cover:
    image: "<image path/url>" # image path/url
    alt: "<alt text>" # alt text
    caption: "Photo Credit: []()" # display caption under cover
    relative: true # when using page bundles set this to true
    hidden: true # only hide on current single page
#editPost:
#    URL: "https://github.com/Aidenwebb/aidenwebb-com-blog-code/content"
#    Text: "Suggest Changes" # edit text
#    appendFilePath: true # to append file path to Edit link
---

## Introduction
This is part 2 of a series. Part 1 is [here](/posts/learning-c-sharp-building-a-mud-part-1)

Last we left off, we'd designed our basic class diagram and templated out the file structure. Now is time to implement it.

```mermaid
classDiagram
  ICharacter <|.. PlayerCharacter
  ICharacter <|.. Monster
  IFightable <|.. PlayerCharacter
  IFightable <|.. Monster

  class Dungeon{
    +List~Room~ Rooms
    +GenerateRooms()
    +DescribeDungeon()
  }
  class Room{
    +int RoomID
    +List~Objects~ Contents
    +GenerateContents()
    +DescribeRoom()
  }
  class ICharacter{
    +string Name
    +int Position
    +Move()
  }
  class IFightable{
    +int Health
    +int Level
    +Attack()
    +Defend()
  }
  class PlayerCharacter{
    placeholder
    }
  class Monster{
    placeholder
  }
```

## Implimenting our prototype

### ICharacter interface

Characters need a name and a position, and need some way to change their position (The `Move()` method).

```csharp
namespace AxeheimMUD.Core.Models;

public interface ICharacter
{
    string Name { get; }
    int Position { get; }

    void Move();
}
```

### IFightable interface

Some characters (and later other things) will be able to engage in combat, but not everything will be able to. We should also create a MaxHealth variable and clarify "Health" to be "CurrentHealth" too.

```csharp
namespace AxeheimMUD.Core.Models;

public interface IFightable
{
    int MaxHealth { get; }
    int CurrentHealth {get; }
    int Level { get; }

    void Attack();
    void Defend();
}
```

### Monster class
Monsters are a character and live in a specific room, they are also fightable.