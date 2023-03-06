import Debug "mo:base/Debug";
import Nat "mo:base/Nat";
import Nat8 "mo:base/Nat8";
import Buffer "mo:base/Buffer";

actor {
  var numBlocks: Nat = 0;
  var blockSize: Nat = 0;
  var totalBytes: Nat = 0;
  var blocks: Buffer.Buffer<Nat8> = Buffer.Buffer<Nat8>(0);

  let blockSizeLimit = 2_000_000; // current upload limit for a single block is 2 MB

  public func prime(newNumBlocks: Nat, newBlockSize: Nat, newTotalBytes: Nat): async () {
    if(numBlocks != 0) {
      Debug.print("numBlocks has already been assigned");
      return;
    };
    if(blockSize != 0) {
      Debug.print("blockSize has already been assigned");
      return;
    };
    if(totalBytes != 0) {
      Debug.print("totalBytes has already been assigned");
      return;
    };
    if(blockSize > blockSizeLimit) {
      Debug.print("attempted blockSize is too large (limit to 2 MB)");
      return;
    };

    numBlocks := newNumBlocks;
    blockSize := newBlockSize;
    totalBytes := newTotalBytes;
  };

  public func download(blockIndex: Nat) : async [Nat8] {
    if(blockIndex >= numBlocks) {
      Debug.print("block index out of range");
      return [];
    };

    let start = blockIndex * blockSize;
    var length = blockSize;
    if(start + length > totalBytes) {
      length := totalBytes - start;
    };
    let slice = Buffer.subBuffer(blocks, start, length);
    Buffer.toArray(slice);
  };

  public func upload(blockIndex: Nat, content: [Nat8]): async Nat {
    if(blocks.size() / blockSize < blockIndex) {
      Debug.print("must assign memory in order of block index");
      return 0;
    };
    if(content.size() > blockSize) {
      Debug.print("content size " # Nat.toText(content.size()) # 
                  " is too large for block size " # Nat.toText(blockSize) # " (try splitting it up)");
      return 0;
    };

    for(byte in content.vals()) {
      blocks.add(byte);
    };
    Debug.print("blocks size: " # Nat.toText(blocks.size()));
    Debug.print("expected total bytes: " # Nat.toText(totalBytes));
    blocks.size()
  };

  public query func getNumBlocks(): async Nat {
    numBlocks;
  };

  public query func getBlockSize(): async Nat {
    blockSize;
  };

  public query func getTotalBytes(): async Nat {
    totalBytes;
  };
};
