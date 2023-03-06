# content_manager

Made by the team members of Blotch.

Offers the ability to upload and download over 2 MB of data at a time.

<h3>Functions</h3>

```
public func prime(newNumBlocks: Nat, newBlockSize: Nat, newTotalBytes: Nat) : async ()
- sets up the content manager to handle a message of size newTotalBytes using the given partition scheme
```

```
public func download(blockIndex: Nat) : async [Nat8]
- returns the fragment of data corresponding to blockIndex
```

```
public func upload(blockIndex: Nat, content: [Nat8]) : async Nat
- uploads content at the specified blockIndex, returning the amount of data currently stored
```

```
public query func getNumBlocks() : async Nat
- gets the number of blocks used in the partition scheme
```

```
public query func getBlockSize() : async Nat
- gets the size of each block in the partition scheme
```

```
public query func getTotalBytes() : async Nat
- gets the total number of bytes of data to be stored
```
